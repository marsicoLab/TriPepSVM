list.of.packages <- c("seqinr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressPackageStartupMessages(library(seqinr))

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) 

file=args[1]
ordered_file=args[2]
disordered_file=args[3]

seq = read.fasta(file,as.string=T,seqonly=T,forceDNAtolower=F)
string = seq[[1]][1]
len = nchar(string)
vector = strsplit(string,split="")[[1]]
disord = grep("[a-z]",vector)
disordered <- list()
ordered <- list()
temp_disordered <-c()
temp_ordered <- c()
pos=1
i=1
if(!is.na(disord[1])){
  mode=ifelse(disord[1]==1,"d","o")
}else{
  mode="o"
}

while(pos<=len){
  if (!is.na(disord[i])){
    if(disord[i]==pos){
      temp_disordered = c(temp_disordered,vector[pos])
      pos = pos+1
      temp_mode="d"
      i=i+1 
    }else{
      temp_ordered = c(temp_ordered,vector[pos])
      pos = pos+1
      temp_mode="o"
    }
  }else{
    temp_ordered = c(temp_ordered,vector[pos])
    pos = pos+1
    temp_mode="o"
  }
  if(temp_mode!=mode){
    if (temp_mode=="o"){
      disordered=c(disordered,paste(toupper(temp_disordered),collapse =""))
      temp_disordered = c()
    }
    if (temp_mode=="d"){
      ordered=c(ordered,paste(temp_ordered,collapse =""))
      temp_ordered = c()
    }
    mode=temp_mode
  }
}

temp_mode=ifelse(temp_mode=="o","d","o")

if("new"!=mode){
  if (temp_mode=="o"){
    disordered=c(disordered,paste(toupper(temp_disordered),collapse =""))
    temp_disordered = c()
  }
  if (temp_mode=="d"){
    ordered=c(ordered,paste(temp_ordered,collapse =""))
    temp_ordered = c()
  }
  mode=temp_mode
}
if(length(ordered)!=0){
  write.fasta(ordered,names=1:length(ordered),as.string=T,file.out=ordered_file,open="a")
  
}
if(length(ordered)!=0){
  write.fasta(disordered,names=1:length(disordered),as.string=T,file.out=disordered_file,open="a")
  
}
