# These two lines are necessary to set up the dada2 library if not set up before
# source("https://bioconductor.org/biocLite.R")
# biocLite("dada2")

  library("dada2")
  library(Biostrings) # To manipulate DNA sequences
  
  library("ggplot2")
  library("stringr")
  library("dplyr")


# Set up directories --------------------------------------------------------
  
  # change the following line to the path where you unzipped the tutorials
    tutorial_dir <- "C:/Users/vaulot/Google Drive/Scripts/"
  
  # working directory in R_dada2
    working_dir <- paste0( tutorial_dir, "metabarcodes_tutorials/R_dada2")
    setwd(working_dir)
  
  # ngs directory
    ngs_dir <- paste0( tutorial_dir, "metabarcodes_tutorials/fastq_carbom")

  # get a list of all fastq files in the ngs directory and separate R1 and R2
    fns <- sort(list.files(fastq_path, full.names = TRUE)) 
    fns <- fns[str_detect( basename(fns),".fastq")]
    fns_R1 <- fns[str_detect( basename(fns),"R1")]
    fns_R2 <- fns[str_detect( basename(fns),"R2")]
  
  # Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
    sample.names <- sapply(str_split(basename(fns_R1), "_"), `[`, 1)
    sample.names <- str_split(basename(fns_R1), pattern = "_", n = 1, simplify = TRUE) 
    sample.names <- sample.names[,1]
    
  # Primer set
    primer_set_fwd = c("CCAGCAGCCGCGGTAATTCC", "CCAGCACCCGCGGTAATTCC", "CCAGCAGCTGCGGTAATTCC", "CCAGCACCTGCGGTAATTCC")
    primer_set_rev = c("ACTTTCGTTCTTGATYRATGA")
    primer_length_fwd <- str_length(primer_set_fwd[1]) 
    primer_length_rev <- str_length(primer_set_rev[1]) 
  
# Compute number of paired reads ---------------------------------------------------------------
    
  # create an empty data frame  
    df <- data.frame()  

  # loop throuh all the R1 files (no need to go through R2 which should be the same) 

    for(i in 1:length(fns_R1)) { 
      
      # use the dada2 function fastq.geometry
        geom <- fastq.geometry(fns_R1[i])
        
      # extract the information on number of sequences and file name 
        df_one_row <- data.frame (n_seq=geom[1], file_name=basename(fns[i]) )
        
      # add one line to data frame
        df <- bind_rows(df, df_one_row)
   } 
  # display number of sequences and write data to small file
    df
    write.table(df, file = paste0(working_dir,"/n_seq.txt"), sep="\t", row.names = FALSE, na="", quote=FALSE)

  # plot the histogram with number of sequences
    ggplot(df, aes(x=n_seq)) + 
          geom_histogram( alpha = 0.5, position="identity", binwidth = 10) +
          xlim(0, 2000)

# Plot quality ------------------------------------------------------------

  # loop throuh all the R1 files (no need to go through R2 which should be the same) 

   for(i in 1:length(fns)) { 
     
    # Use dada2 function to plot quality
      p1 <- plotQualityProfile(fns[i])
      
    # Only plot on screen for first 2 files  
      if (i <= 2) {print(p1)}
      
    # save the file as a pdf file 
      p1_file <- paste0(ngs_dir,"/qual/",basename(fns[i]),".pdf")
      ggsave( plot=p1, filename= p1_file, 
                device = "pdf", width = 15, height = 15, scale=1, units="cm")
    }   

# Filter and Trim the reads -------------------------------------------------
    
  # Place filtered files in filtered/ subdirectory    
    filt_dir <- file.path(ngs_dir, "filtered")
  
    filt_R1 <- file.path(filt_dir, paste0(sample.names, "_R1_filt.fastq"))
    filt_R2 <- file.path(filt_dir, paste0(sample.names, "_R2_filt.fastq"))

  # This step is done because primers are degenerated so all four combinations  net to be tested
  #   however primer testing can be done later
  # Filter all sequences with N, truncate R2 to 240 bp, and find primers 
  #   On Windows set multithread=FALSE  

    out_all <-data.frame(id=length(fns_R1))
    for (i in 1:4) {
      out <- filterAndTrim(fns_R1, filt_R1, fns_R2, filt_R2, truncLen=c(250,240), trimLeft = c(0,0),
                maxN=0, maxEE=c(Inf, Inf), truncQ=10, rm.phix=TRUE, primer.fwd = primer_set[i], 
                compress=FALSE, multithread=FALSE) 
      out_all <- cbind(out_all, out)
    }

  # Filter all sequences with N, truncate R2 to 240 bp, 
  # remove the primers because they are a source of problem after    
    out <- filterAndTrim(fns_R1, filt_R1, fns_R2, filt_R2, 
                         truncLen=c(250,240), trimLeft = c(primer_length_fwd,primer_length_rev),
                         maxN=0, maxEE=c(Inf, Inf), truncQ=10, rm.phix=TRUE,  
                         compress=FALSE, multithread=FALSE) 

# Learn error rates -------------------------------------------------------

    err_R1 <- learnErrors(filt_R1, multithread=FALSE)
    err_R2 <- learnErrors(filt_R2, multithread=FALSE)
    plotErrors(err_R1, nominalQ=TRUE)
    plotErrors(err_R2, nominalQ=TRUE)  
    

# Dereplicate the reads ---------------------------------------------------

    derep_R1 <- derepFastq(filt_R1, verbose=TRUE)
    derep_R2 <- derepFastq(filt_R2, verbose=TRUE)
    
  # Name the derep-class objects by the sample names
    names(derep_R1) <- sample.names
    names(derep_R2) <- sample.names    
    

# Sequence-variant inference algorithm to the dereplicated data. ----------

    dada_R1 <- dada(derep_R1, err=err_R1, multithread=FALSE)
    dada_R2 <- dada(derep_R2, err=err_R2, multithread=FALSE)
    
    dada_R1[[1]]
    dada_R2[[1]]
    

# Merge sequences ---------------------------------------------------------

    mergers <- mergePairs(dada_R1, derep_R1, dada_R2, derep_R2, verbose=TRUE)
    
  # Inspect the merger data.frame from the first sample
    head(mergers[[1]])    
    

# Make sequence table -----------------------------------------------------

    seqtab <- makeSequenceTable(mergers)
    
    dim(seqtab)
    t_seqtab <- t(seqtab)

  # Inspect distribution of sequence lengths
    table(nchar(getSequences(seqtab))) 
    

# Remove chimeras ---------------------------------------------------------

  # Methods can be pooled or consensus
    seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=FALSE, verbose=TRUE)
    
  # Compute ratio of non chimeras
    dim(seqtab.nochim)
    sum(seqtab.nochim)/sum(seqtab)
    

# Track number of reads at each step --------------------------------------

    getN <- function(x) sum(getUniques(x))
    
    track <- cbind(out, sapply(dada_R1, getN), sapply(mergers, getN), rowSums(seqtab), rowSums(seqtab.nochim))

    colnames(track) <- c("input", "filtered", "denoised", "merged", "tabled", "nonchim")
    rownames(track) <- sample.names
    
    track    

# Assing taxonomy ---------------------------------------------------------
    pr2_file <- paste0(tutorial_dir, "metabarcodes_tutorials/databases/pr2_version_4.72_dada2_Eukaryota.fasta.gz")
    taxa <- assignTaxonomy(seqtab.nochim, refFasta=pr2_file,  
                           taxLevels = c("Kingdom", "Supergroup","Division", "Class", "Order", "Family", "Genus", "Species"),
                           minBoot = 0, outputBootstraps = TRUE,
                           verbose = TRUE)
    

# Export data -------------------------------------------------------------

    write.table(taxa$tax, file = paste0(working_dir,"/taxa.txt"), sep="\t", row.names = TRUE, na="", quote=FALSE, append=FALSE)   
    write.table(taxa$boot, file = paste0(working_dir,"/taxa_boot.txt"), sep="\t", row.names = TRUE, na="", quote=FALSE, append=FALSE) 
    write.table(t(seqtab.nochim), file = paste0(working_dir,"/seqtab.txt"), sep="\t", row.names = TRUE, na="", quote=FALSE, append=FALSE)    
    
# Clean up memory ------------------------------------------------------------

  rm(list=ls())


