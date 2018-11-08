list.of.packages <- c("calibrate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressPackageStartupMessages(require("calibrate"))

salmonella_path="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/data/proteome_prediction_salmonella/proteome_99287.featureWeights.txt"
human_path="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/data/proteome_prediction_human/proteome_9606.featureWeights.txt"
conservedKmer_path="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/data/kmer_enriched_human.txt"

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) 

salmonella_path = args[1]
human_path = args[2]
conservedKmer_path = args[3]
out = args[4]

human = read.table(human_path, header = F, stringsAsFactors = F)
salmonella = read.table(salmonella_path, header=F, stringsAsFactors = F)

table = merge(salmonella, human, by = "V1", all = T)
table[is.na(table)] = 0

conservedKmer = read.table(conservedKmer_path,colClasses = c("character"))

names = colnames(table)
names[!(colnames(table) %in% conservedKmer[,1])]=""
indexConservedKmer = colnames(table) %in% conservedKmer[,1]

xrange = 1.5
yrange = 2

pdf(out)
smoothScatter(table[,2],table[,3], xlim=c(-xrange,+xrange), ylim=c(-yrange,+yrange),
              xlab="Salmonella", nbin = 200,
              ylab="Human", colramp = colorRampPalette(c("white", "gray30")),
              nrpoints=0, pch= 20)
abline(h=0)
abline(v=0)
lines(table[table$V1 %in% conservedKmer[,1],2], table[table$V1 %in% conservedKmer[,1],3],
      t="p", pch=17, cex = 1, col="red")
textxy(table[table$V1 %in% conservedKmer[,1],2], table[table$V1 %in% conservedKmer[,1],3],
       conservedKmer[,1],cex=1)
dev.off()

