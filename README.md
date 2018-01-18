# Tutorials for metabarcode analysis

In this repository, you will find a set of tutorials of metabarcode analyses using different approaches

* Mothur
     - 454 data
     - Illumina data
	 
## Prerequisites

Install the following software :  

* mothur : https://github.com/mothur/mothur/releases/tag/v1.39.5

* PR2 database : https://github.com/vaulot/pr2_database/releases/download/4.7.2/pr2_version_4.7.2_mothur.zip . This file must be decompressed in the /databases directory

* R : https://pbil.univ-lyon1.fr/CRAN/

* R studio : https://www.rstudio.com/products/rstudio/download/#download

* Download and install the following libraries by running under R studio the following lines

```R
install.packages("dplyr")     # To manipulate dataframes
install.packages("stringr")   # To strings

install.packages("ggplot2")   # for high quality graphics

source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")        # manipulate sequences
biocLite('dada2')             # metabarcode data analysis

`

