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

### Install the following software :  

* Terminal program.  For Windows MobaXterm is highly recommended : https://mobaxterm.mobatek.net/

* Notepad++ if you are using windows : https://notepad-plus-plus.org/

* mothur : https://github.com/mothur/mothur/releases/tag/v1.39.5

* R : https://pbil.univ-lyon1.fr/CRAN/

* R studio : https://www.rstudio.com/products/rstudio/download/#download

* Download and install the following libraries by running under R studio the following lines

```R
install.packages("readr")     # To read and write files
install.packages("readxl")    # To read excel files

install.packages("dplyr")     # To manipulate dataframes
install.packages("tibble")    # To work with data frames
install.packages("tidyr")     # To work with data frames

install.packages("stringr")   # To manipulate strings

install.packages("ggplot2")   # To do plots


source("https://bioconductor.org/biocLite.R")
biocLite('dada2')             # metabarcode data analysis
biocLite('phyloseq')          # metabarcode data analysis
biocLite('Biostrings')        # needed for fastq.geometry

```
### Directory structure

* **/fastq** : fastq files
* **/dada2** : dada2 processed files
* **/databases** : PR2 database files (contains PR2 database formatted for dada2 and mothur - https://github.com/pr2database/pr2database/releases/)
* **/img** : Images

* **/R_dada2** : Dada2 tutorial for Illumina files
* **/mothur/454** : Mothur Tutorial for 454 files
* **/mothur/illumina** : Mothur Tutorial for Illumina files

### Short introduction to tutorials

* [Dada2 Illumina](https://github.com/vaulot/metabarcodes_tutorials/raw/master/R_dada2/R_dada2_tutorial_beamer.pdf)

### Step by step instructions

* [Mothur 454](https://github.com/vaulot/metabarcodes_tutorials/blob/master/mothur/454/Mothur%20tutorial%20454.pptx)
* [Mothur Illumina](https://github.com/vaulot/metabarcodes_tutorials/blob/master/mothur/illumina/tutorial_mothur_illumina.pdf)
* [R Dada2 Illumina](https://vaulot.github.io/tutorials/R_dada2_tutorial.html)
* [Compare analysis with mothur vs. dada2](https://vaulot.github.io/tutorials/R_dada2_vs_mothur.html)
* [Mothur Illumina](https://github.com/vaulot/metabarcodes_tutorials/blob/master/mothur/illumina/tutorial_mothur_illumina.pdf)

### Issues or questions

Please post [here](https://github.com/vaulot/metabarcodes_tutorials/issues)

