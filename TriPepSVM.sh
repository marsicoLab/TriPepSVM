#!/usr/bin/env bash

#####################################################################################################################################
### TriPepSVM : SVM-based prediction of RBPs based on counts of oligopeptide frequencies of a specific taxonomical group
#####################################################################################################################################

scriptDir=$(dirname "$0")

#######################
# Set default parameter, parse input and check parameter:

help="\n
############################################################### \n
### \n
### TriPepSVM : SVM-based prediction of RBPs based on counts of \n
###             oligopeptide  frequencies of a specific taxonomical group \n
### \n
############################################################### \n
# \n
# USAGE: \n
# ./TriPepSVM.sh [OPTION] ... -i INPUT.[fasta|fa] \n
#  -i,\t--input [INPUT.fasta|fa] : AA sequence in fasta format, NO DEFAULT \n
#  -o,\t--output : path to output folder, DEFAULT: current directory \n
#  -id,\t--taxon-id [9606|590|...] : Uniprot taxon id, DEFAULT: 9606 (human) \n
#  -c,\t--cost : change COST parameter, DEFAULT: 1 \n
#  -k,\t--oligo-length : change k parameter, DEFAULT: 3 \n
#  -pos,\t--pos-class : change positive class weight, DEFAULT: inverse proportional to class size \n
#  -neg,\t--neg-class : change negative class weight, DEFAULT: inverse proportional to class size \n
#  -thr,\t--threshold : change prediction threshold, DEFAULT: 0 \n
#  -r,\t--recursive [TRUE|FALSE]: apply recursive mode, DEFAULT: FALSE \n
#  -h,\t--help : help text \n
# \n 
####################### \n
# REQUIREMENTS: \n
# R (>= 3.2.0) \n
# Kebabs \n
# HMMER (in PATH variable) \n
# CDHIT (in PATH variable) \n
# \n
# - write permission in output directory \n
# - read permission input file \n
# - internet connection (if tool is applied to different taxon) \n
# \n
####################### \n
# USAGE EXAMPLE: \n
# ./TriPepSVM.sh -i salmonellaProteom.fasta -o Results/ -id 590 -r True -posW 1.8 -negW 0.2 -thr 0.68 \n
# ./TriPepSVM.sh -i humanProteom.fasta -o Results_Human/ -posW 1.8 -negW 0.2 -thr 0.28 \n
# \n
####################### \n
"


#######################
# Set default parameter:

scriptDir=$(dirname "$0")
outDir=$(pwd)/Results
INPUT_FILE=""
taxon_id=9606
cost=1
k=3
posW=inversePropClassSize
negW=inversePropClassSize
thr=0
recM=FALSE
mode=allData

#######################
# Parse input:

#######################
# Parse input:

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -i|--input)
    INPUT_FILE="$2"
    shift 2
    ;;

    -o|--output)
    outDir="$2"
    shift 2
    ;;

    -id|--taxon-id)
    taxon_id="$2"
    shift 2
    ;;

    -c|--cost)
    cost="$2"
    shift 2
    ;;
    
    -k|--oligo-length)
    k="$2"
    shift 2
    ;;
    
    -pos|--pos-class)
    posW="$2"
    shift 2
    ;;
    
    -neg|--neg-class)
    negW="$2"
    shift 2
    ;;

    -thr|--threshold)
    thr="$2"
    shift 2
    ;;
    
    -r|--recursive)
    recM="$2"
    shift 2
    ;;

    -m|--mode)
    mode="$2"
    shift 2
    ;;

    -h|--help)
    echo -e $help
    exit 1
    ;;
    
    *)
    status="---- > $key isn't a valid input argument"
    echo -e $help
    echo $status
    exit 1
    ;; 
esac
done
#######################
# Check parameter:

if [ "$INPUT_FILE" == "" ];then
	status="---- > Please specify an input file using either -i or --input option"
	echo -e $help
	echo $status
	exit 1 
fi

if [ "$taxon_id" == "590" ];then
	if [ "$posW" != "1.8" ] || [ "$negW" != "0.2" ];then
		status="---- > ATTENTION: Application use suboptimal positive and negative class weights\n---- > we recommend positive class weight = 1.8 and nagetive class weight = 0.2"
		echo -e $status\n
	fi

	if [ "$thr" != "0.28" ];then
		status="---- > ATTENTION: Application use suboptimal classification cutoff\n---- > we recommend a threshold = 0.28\n"
		echo -e $status
	fi
fi	

if [ "$taxon_id" == "9606" ];then
	if [ "$posW" != "1.8" ] || [ "$negW" != "0.2" ];then
		status="---- > ATTENTION: Application use suboptimal positive and negative class weights\n---- > we recommend positive class weight = 1.8 and nagetive class weight = 0.2"
		echo -e $status
	fi

	if [ "$thr" != "0.68" ];then
		status="---- > ATTENTION: Application use suboptimal classification cutoff\n---- > we recommend a threshold = 0.68\n"
		echo -e $status
	fi
fi	


#######################
# Create output folder:

mkdir -p $outDir

#######################
# Collect data:

# collect data in outDir if new taxon is selected, use existing data if not
# mode : developer parameter for performance measurements, default mode=allData but
# could be also trainData for special application
if [ "$taxon_id" == "9606" ] || [ "$taxon_id" == "590" ] || [ "$taxon_id" == "561" ];then
	data=$scriptDir/$mode
else
	data=$outDir/$mode
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

posSize=`grep "^>" $data/RBP_${taxon_id}.fasta | wc -l`
negSize=`grep "^>" $data/NRBP_${taxon_id}.fasta | wc -l`
echo "positive set size: $posSize"
echo "positive set size: $negSize"

Rscript $scriptDir/source/kmerPrediction.r $data/RBP_${taxon_id}.fasta $data/NRBP_${taxon_id}.fasta $INPUT_FILE $k $cost $outDir \
						${filename}.TriPepSVM.pred.txt ${filename}.featureWeights.txt $posW $negW $thr


















