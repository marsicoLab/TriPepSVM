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
x = args[3]
y = args[4]
conservedKmer_path = args[5]
out = args[6]

human = read.table(human_path, header = F, stringsAsFactors = F)
salmonella = read.table(salmonella_path, header=F, stringsAsFactors = F)

table = merge(salmonella, human, by = "V1", all = T)
table[is.na(table)] = 0

conservedKmer = read.table(conservedKmer_path,colClasses = c("character"))

names = colnames(table)
names[!(colnames(table) %in% conservedKmer[,1])]=""
indexConservedKmer = colnames(table) %in% conservedKmer[,1]

xrange = 1.5
yrange = round(max(abs(table[,3]))+0.5,0)

correlation = cor(table[,2],table[,3])


pdf(out)
smoothScatter(table[,2],table[,3], xlim=c(-xrange,+xrange), ylim=c(-yrange,+yrange),
              xlab=x, nbin = 200,
              ylab=y, colramp = colorRampPalette(c("white", "gray30")),
              nrpoints=0, pch= 20)
abline(h=0)
abline(v=0)
lines(table[table$V1 %in% conservedKmer[,1],2], table[table$V1 %in% conservedKmer[,1],3],
      t="p", pch=17, cex = 1, col="red")
textxy(table[table$V1 %in% conservedKmer[,1],2], table[table$V1 %in% conservedKmer[,1],3],
       conservedKmer[,1],cex=1)
textxy(-0.5,1.5,paste("r=",as.character(round(correlation,2)),sep=""),cex=1)
dev.off()

