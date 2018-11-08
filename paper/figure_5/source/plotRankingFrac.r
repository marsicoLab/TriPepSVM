list.of.packages <- c("data.table","msir")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("msir"))

args <- commandArgs(trailingOnly = TRUE) 
options(scipen = 999)

ordered_path_sal = args[1]
disordered_path_sal = args[2]
featureWeights_path_sal = args[3]
ordered_path_hum = args[4]
disordered_path_hum = args[5]
featureWeights_path_hum = args[6]
span = as.numeric(args[7])
out = args[8]

getTable = function(ordered_path, disordered_path, featureWeights_path){
  ordered = fread(ordered_path)
  disordered = fread(disordered_path)
  featureWeights = fread(featureWeights_path, stringsAsFactors = F, header=F)
  
  colnames(featureWeights) = c("kmer","weights")
  
  featureWeights = data.table(featureWeights)
  featureWeights$weights = as.numeric(featureWeights$weights)
  
  featureWeights = featureWeights[order(featureWeights$weights, decreasing = T)]
  
  table = merge(ordered, disordered, by = "V1")
  
  colnames(table) = c("kmer","ordered","disordered")
  
  table = table[!(table$ordered == 0 & table$disordered == 0),]
  table$frac = table$disordered / (table$ordered + table$disordered)
  
  table = merge(table , featureWeights, by = "kmer")
  
  table = table[order(abs(table$weights), decreasing = T)]
  
  return(table)
}

table_sal = getTable(ordered_path_sal, disordered_path_sal, featureWeights_path_sal)
table_hum = getTable(ordered_path_hum, disordered_path_hum, featureWeights_path_hum)

index_sal = 1:length(table_sal$frac)
lo_sal = loess.sd(table_sal$frac ~ index_sal, span = span)

index_hum = 1:length(table_hum$frac)
lo_hum = loess.sd(table_hum$frac ~ index_hum, span = span)

conf1 = lo_sal$upper
conf2 = lo_sal$lower
conf3 = lo_hum$upper
conf4 = lo_hum$lower

smooth_sal = lo_sal$y
smooth_hum = lo_hum$y

sal_80_sm = sort(smooth_sal)[round(length(smooth_sal)*0.80)]
hum_80_sm = sort(smooth_hum)[round(length(smooth_hum)*0.80)]

pdf(out)
plot(index_sal, smooth_sal, col = "black", t = "l", ylim = c(0,0.6), xlab ="tripeptides",ylab="frequency disordered regions of RBPs")
lines(index_hum, smooth_hum, col = "red", t = "l", ylim = c(0,0.6))
polygon(c(index_sal,rev(index_sal)),c(conf1,rev(conf2)), border = F, col = rgb(0,0,0,1/8))
polygon(c(index_hum,rev(index_hum)),c(conf3,rev(conf4)), border = F, col = rgb(1,0,0,1/8))

abline(h=sal_80_sm)
abline(h=hum_80_sm)

abline(v=min(which(smooth_hum<=hum_80_sm)), col ="red")
abline(v=min(which(smooth_sal<=sal_80_sm)))

legend("topright",c("Human","Salmonella"), col=c("red","black"),pch=20)
dev.off()

