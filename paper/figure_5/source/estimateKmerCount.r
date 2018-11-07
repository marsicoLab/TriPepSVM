list.of.packages <- c("Biostrings","seqinr" ,"stringr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressPackageStartupMessages(library(Biostrings))
suppressPackageStartupMessages(library(seqinr))
suppressPackageStartupMessages(library(stringr))

options(echo = F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) # count dont_use_bad_overy


fasta <- args[1]
humankmer <- args[2]
output1 <- args[3]

seq <- read.fasta(fasta,seqtype = "AA", as.string = T,seqonly = T)
annot <- read.fasta(fasta,seqtype = "AA", as.string = T,seqonly = F)

seq <- as.character(seq)

annot <- getName(annot)
split <- strsplit(annot,split = "\\|")
annot <- 1:length(split)

kmer <- read.table(humankmer,na.strings = "NA")
kmer <- as.character(kmer[,1])

count <- function(x){
  return(str_count(x,kmer))
}

freq <- as.data.frame(lapply(seq,count))
freq <- t(freq)

colnames(freq) <- kmer
rownames(freq) <- annot

freqProt <- as.data.frame(freq)

freqAll = colSums(freq)

write.table(freqAll, file = output1, row.names = T, col.names = F, quote = FALSE, sep = "\t")

