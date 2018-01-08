# These two lines are necessary to set up the dada2 library if not set up before
# source("https://bioconductor.org/biocLite.R")
# biocLite("dada2")

  library("dada2")
  library(Biostrings) # To manipulate DNA sequences
  
  library("ggplot2")
  library("stringr")
  library("dplyr")

# Function to plot quality of Illumina files ------------------------------------------

  fastq_qual_plot <- function(fastq_path) {
  # fastq_path <- "C:/Data Biomol/RNA/Tags/CEE 2014 Andres/fastq"
  
   fns <- sort(list.files(fastq_path, full.names = TRUE)) 
   fns <- fns[str_detect( basename(fns),".fastq")] 
 
   for(i in 1:length(fns)) { 
     p1 <- plotQualityProfile(fns[i]) + ggtitle(basename(fns[i]))
     p1_file <- paste0(basename(fns[i]),".pdf")
     ggsave( plot=p1, filename= paste0(fastq_path,"/qual/",p1_file), 
              device = "pdf", width = 15, height = 15, scale=1, units="cm")
    } 
 
}


# Function to compute number of sequences in fastq files ---------------------------------------------

  fastq_size <- function(fastq_path) {
    
   df <- data.frame()  
   
   fns <- sort(list.files(fastq_path, full.names = TRUE)) 
   fns <- fns[str_detect( basename(fns),"R1")]
   
   for(i in 1:length(fns)) { 
     geom <- fastq.geometry(fns[i])
     df_one_row <- data.frame (n_seq=geom[1], file_name=basename(fns[i]) )
     df <- bind_rows(df, df_one_row)
   } 
   df
   
  }


# The main program --------------------------------------------------------
  
  # Change the following line to the path where you unzipped the tutorials
  tutorial_dir <- "C:/Users/vaulot/Google Drive/Scripts/"

  working_dir <- paste0( tutorial_dir, "metabarcodes tutorials/mothur/illumina")
  setwd(working_dir)

  ngs_dir <- paste0( tutorial_dir, "metabarcodes tutorials/fastq_carbom")


# Number of paired reads ---------------------------------------------------------------
  df <- fastq_size(ngs_dir)
  df <- df %>% filter(str_detect(file_name,"R1") == TRUE)
  
  write.table(df, file = paste0(working_dir,"/n_seq.txt"), sep="\t", row.names = FALSE, na="", quote=FALSE)

  ggplot(df, aes(x=n_seq)) + 
          geom_histogram( alpha = 0.5, position="identity", binwidth = 10) +
           xlim(0, 2000)

# Plot quality ------------------------------------------------------------

  fastq_qual_plot(ngs_dir)
  
# Clean up memory ------------------------------------------------------------

  rm(list=ls())


