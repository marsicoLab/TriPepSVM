options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) 

suppressPackageStartupMessages(require(data.table))
#dom_file="/project/owlmayerTemporary/Bressin/Salmonella/proteome_prediction/proteomes/out.temp"
#out_file="/home/bressin/Desktop/Master/Script/SVMKmer/Train/Database_SPOT/test.test"

dom_file = args[1]
len = as.numeric(args[2])-1
out_file = args[3]

info_domain = read.table(dom_file)
#info_domain=data.frame(fread(dom_file,sep="\n",skip=9))

colNr = nrow(info_domain)


removeCol = ceiling(len/60)

id = substring(info_domain[colNr-removeCol,],2)

info_domain = as.character(info_domain[-c(1,(colNr-removeCol):colNr),])


if (length(info_domain)!=0){
  split1 = do.call(rbind,strsplit(info_domain,split="\\."))
  split2 = do.call(rbind,strsplit(split1[,2],split="-"))
  
  dom_len = as.numeric(split2[,2])-as.numeric(split2[,1])+1
  
  write.table(t(c(id,sum(dom_len)/len)), row.names=F,col.names=F ,quote = F,sep="\t",append=T,file=out_file)
}else{
  write.table(t(c(id,0)), row.names=F,col.names=F ,quote = F,sep="\t",append=T,file=out_file)
}
