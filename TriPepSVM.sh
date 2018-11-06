#!/usr/bin/env bash

#####################################################################################################################################
### TriPepSVM : SVM-based prediction of RBPs based on counts of oligopeptide frequencies of a specific taxonomical group
#####################################################################################################################################

scriptDir=$(dirname "$0")

#######################
# Set default parameter, parse input and check parameter:

#bash 

bash $scriptDir/source/setDefaultparseParameter.sh $@

source $scriptDir/source/parameter.in

if [ "$exit" == "1" ];then
	exit 0
fi

#######################
# Create output folder:

mkdir -p $outDir

#######################
# Collect data:

# collect data in outDir if new taxon is selected, use existing data if not
if [ "$taxon_id" == "9606" ] || [ "$taxon_id" == "590" ];then
	data=$scriptDir/trainData
else
	data=$outDir/trainData
fi

# create pos set if not exist
if [ ! -f $data/RBP_$taxon_id.fasta ];then 
	bash $scriptDir/source/posDataset.sh $taxon_id $data $recM
fi

# create neg set if not exist
if [ ! -f $data/NRBP_$taxon_id.fasta ];then 
	bash $scriptDir/source/negDataset.sh $taxon_id $data $recM
fi

base=${INPUT_FILE##*/}
filename=${base%.*}

Rscript $scriptDir/source/kmerPrediction.r $data/RBP_${taxon_id}.fasta $data/NRBP_${taxon_id}.fasta $INPUT_FILE $k $cost $outDir \
						${filename}.TriPepSVM.pred.txt ${filename}.featureWeights.txt $posW $negW $thr


















