#!/usr/bin/env bash
##################################
### oligoPepSVM : SVM-based prediction of RBPs based on counts of oligopeptide frequencies of
### a specific taxonomical group
##################################
# USAGE:
# ./oligoPepSVM.sh [predictionFile] [OUTDIR] [TAXON_ID] [P] [COST] [RECURSIVE] [TRAINSET]
# predictionFile : fasta file with protein sequences for prediction
# OUTDIR : output path
# TAXON_ID: uniprot ttaxon identifier, e.g. 1566 (human), 230 (salmonella), 535 (escherichia)
# P : subsequence length, e.g. 3 or 4
# COST : cost parameter, e.g. 1
# RECURISVE : data set collecetion in recursive mode?, e.g. False

#######################
# Requirements:
# R 
# HMMER
# CDHIT
# IUPRED
# (please add locations to environmental path)
#######################
# USAGE EXAMPLE:
# ./oliPepSVM.sh x.fa Results/ 590 3 1 False
#
#######################
scriptDir=$(dirname "$0")

PRED=$1
RESULT=$2
TAXON=$3
P=$4
COST=$5
RECURSIVE=$6
mode=$7
posW=$8
negW=$9
cutoff=${10}

mkdir -p $RESULT

# create pos set if not exist
if [ ! -f $scriptDir/$mode/RBP_$TAXON.fasta ];then 
	bash $scriptDir/posDataset.sh $TAXON $scriptDir/$mode $RECURSIVE
fi

# create neg set if not exist
if [ ! -f $scriptDir/$mode/NRBP_$TAXON.fasta ];then 
	bash $scriptDir/negDataset.sh $TAXON $scriptDir/$mode $RECURSIVE
fi

xbase=${PRED##*/}
FILENAME=${xbase%.*}

Rscript $scriptDir/kmerPrediction.r $scriptDir/$mode/RBP_$TAXON.fasta $scriptDir/$mode/NRBP_$TAXON.fasta $PRED $P $COST $RESULT $FILENAME.oligoPepSVM.pred.txt $posW $negW $cutoff


















