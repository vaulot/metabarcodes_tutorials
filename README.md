# Tutorials for metabarcode analysis

In this repository, you will find a set of tutorials of metabarcode analyses using different approaches

* Mothur
     - [454 data](https://github.com/vaulot/metabarcodes_tutorials/tree/master/mothur/454)
     - [Illumina data](https://github.com/vaulot/metabarcodes_tutorials/tree/master/mothur/illumina)
* Dada2
     - [Illumina data](https://github.com/vaulot/metabarcodes_tutorials/tree/master/R_dada2)
     
## How to use

### Download and uncompress

* The whole set of tutorials from the download link (top-right above file list)

* [PR2 database](https://github.com/vaulot/pr2_database/releases/download/4.7.2/pr2_version_4.7.2_mothur.zip). This file must be decompressed in the /databases directory


### Install the following software :  

* Terminal program.  For Windows MobaXterm is highly recommended : https://mobaxterm.mobatek.net/

* Notepad++ if you are using windows : https://notepad-plus-plus.org/

* mothur : https://github.com/mothur/mothur/releases/tag/v1.39.5

* R : https://pbil.univ-lyon1.fr/CRAN/

* R studio : https://www.rstudio.com/products/rstudio/download/#download

* Download and install the following libraries by running under R studio the following lines

```R
install.packages("dplyr")     # To manipulate dataframes
install.packages("stringr")   # To strings
install.packages("ggplot2")   # To do plots
install.packages("readxl")    # To read excel files
install.packages("tibble")    # To work with data frames
install.packages("tidyr")    # To work with data frames

source("https://bioconductor.org/biocLite.R")
biocLite('dada2')             # metabarcode data analysis
biocLite('phyloseq')          # metabarcode data analysis
biocLite('Biostrings')        # needed for fastq.geometry

```

### Follow the step by step instructions :

* [Mothur 454](https://github.com/vaulot/metabarcodes_tutorials/blob/master/mothur/454/Mothur%20tutorial%20454.pptx)
* [Mothur Illumina](https://vaulot.github.io/tutorials/R_dada2_tutorial.html)
* [R Dada2 Illumina](https://github.com/vaulot/metabarcodes_tutorials/blob/master/R_dada2/R_dada2_tutorial.pdf)

### Issues or questions

Please post [here](https://github.com/vaulot/metabarcodes_tutorials/issues)

