#!/usr/bin/env bash

scriptDir=$(dirname "$0")

#####  get performance: salmonella
if [ ! -f $scriptDir/../data/test/TriPepSVM/RBP_590.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/test/RBP_590.fasta -o $scriptDir/../data/test/TriPepSVM -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $scriptDir/../data/test/TriPepSVM/NRBP_590.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/test/NRBP_590.fasta -o $scriptDir/../data/test/TriPepSVM -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

#####  get performance: human
if [ ! -f $scriptDir/../data/test/TriPepSVM/RBP_9606.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/test/RBP_9606.fasta -o $scriptDir/../data/test/TriPepSVM -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -m trainData
fi

if [ ! -f $scriptDir/../data/test/TriPepSVM/NRBP_9606.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/test/NRBP_9606.fasta -o $scriptDir/../data/test/TriPepSVM -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -m trainData
fi

##### data processing

### RNAPred
RNAPred_Cutoff=-0.24
for file in $scriptDir/../data/test/RNAPred/*9606*.temp;do
	base=${file%.*} 	
	awk -v OFS="\t" -F"\t" '{ if( $2 >= '$RNAPred_Cutoff' ) print $1,$2,"RNA-binding protein"; else print $1,$2,"Non RNA-binding protein";}' $file > $base.txt  
done

RNAPred_Cutoff=-0.18
for file in $scriptDir/../data/test/RNAPred/*590*.temp;do
	base=${file%.*} 	
	awk -v OFS="\t" -F"\t" '{ if( $2 >= '$RNAPred_Cutoff' ) print $1,$2,"RNA-binding protein"; else print $1,$2,"Non RNA-binding protein";}' $file > $base.txt  
done

### RBPPred
RBPPred_Cutoff=0.81
for file in $scriptDir/../data/test/RBPPred/*9606*.temp;do
	base=${file%.*}
	awk -v OFS="\t" -F"\t" '{ if( $2 >= '$RBPPred_Cutoff' ) print $1,$2,"RNA-binding protein"; else print $1,$2,"Non RNA-binding protein";}' $file > $base.txt
done


RBPPred_Cutoff=0.34
for file in $scriptDir/../data/test/RBPPred/*590*.temp;do
	base=${file%.*}
	awk -v OFS="\t" -F"\t" '{ if( $2 >= '$RBPPred_Cutoff' ) print $1,$2,"RNA-binding protein"; else print $1,$2,"Non RNA-binding protein";}' $file > $base.txt
done

##### plot performance

Rscript $scriptDir/source/plotPerformance.r $scriptDir/../data/test 590 $scriptDir/590.pdf
Rscript $scriptDir/source/plotPerformance.r $scriptDir/../data/test 9606 $scriptDir/9606.pdf
