#!/bin/bash

scriptDir=$(dirname "$0")

TAXON=$1
RESULT=$2
RECURSIVE=$3

# create Database folder
DATABASE=$RESULT/TEMP_POS
mkdir -p $DATABASE

# Retrieve UniProt IDs of annotated RBPs from QuickGO
# In recursive mode, query each strain specifically

if [ ! -e "$DATABASE/RBP.fasta" ];then
	if [ "$RECURSIVE" == "TRUE" ];then
        # get all substrains of the given taxon from UniProt
		if [ ! -e "$DATABASE/parseTaxonomyUniprot.temp" ];then
			query_taxonomy="https://www.uniprot.org/taxonomy/?query=ancestor:$TAXON&fil=uniprot%3A(*)&format=tab"
			curl $query_taxonomy > $DATABASE/parseTaxonomyUniprot.temp
		fi
        # get the IDs for each substrain and write everything to file
		searchID=`cut -f1 $DATABASE/parseTaxonomyUniprot.temp | tail -n +2`
		for organism_id in $searchID;do
            echo $organism_id
			#query_go="http://www.ebi.ac.uk/QuickGO/GAnnotation?format=fasta&limit=-1&goid=GO:0003723&db=UniProtKB&tax=$organism_id"
            query_go="https://www.ebi.ac.uk/QuickGO/services/annotation/downloadSearch?goId=GO%3A0003723&taxonId=$organism_id&taxonUsage=exact&goUsage=descendants&geneProductType=protein"
            curl -X GET --header 'Accept:text/tsv' $query_go >> $DATABASE/rbp_ids.temp.tsv
		done
	else
        # Only extract IDs for the exact matching taxon
        query_go="https://www.ebi.ac.uk/QuickGO/services/annotation/downloadSearch?goId=GO%3A0003723&taxonId=$TAXON&taxonUsage=exact&goUsage=descendants&geneProductType=protein"
		curl -X GET --header 'Accept:text/tsv' $query_go > $DATABASE/rbp_ids.temp.tsv
	fi
	
fi
# get AA sequences for the IDs using a python script
if [ ! -e "$DATABASE/RBP.fasta" ];then
    python get_rbps_for_taxon.py -ids $DATABASE/rbp_ids.temp.tsv -o $DATABASE/RBP.fasta
fi

# Finally, remove duplicate sequences from the fasta file, using cd-hit
if [ ! -e "$RESULT/RBP_$TAXON.fasta" ];then
	bash $scriptDir/createUniqSet.sh $RESULT $DATABASE/RBP.fasta $RESULT/RBP_$TAXON.fasta
fi

rm -R $DATABASE
