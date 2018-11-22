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
    tutorial_dir <- "C:/xxx/Scripts/metabarcodes_tutorials/"
  
  # set up working directory
    working_dir <- paste0( tutorial_dir, "mothur/illumina")
    setwd(working_dir)
  
  # ngs directory
    ngs_dir <- paste0( tutorial_dir, "fastq_carbom")

  # get a list of all fastq files in the ngs directory and separate R1 and R2
    fns <- sort(list.files(ngs_dir, full.names = TRUE)) 
    fns <- fns[str_detect( basename(fns),".fastq")]
    fns_R1 <- fns[str_detect( basename(fns),"R1")]
    fns_R2 <- fns[str_detect( basename(fns),"R2")]
  
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

    
    
# Clean up memory ------------------------------------------------------------

  rm(list=ls())


