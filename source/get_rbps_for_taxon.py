import argparse
from bioservices import QuickGO
from bioservices import UniProt
import pandas as pd

def get_rbp_ids_for_taxon(taxon, mode='exact'):
    """ Retrieve UniProt IDs for all RBPs for a given taxon.

    Note: This does not work reliably because quickGO restricts
    the number of pages for retrieval to 25. That means, one
    cannot retrieve more than 2500 annotations as the max. page
    size is 100 entries.
    """
    rna_binding_goterm = "GO:0003723"
    g = QuickGO(verbose=False)

    # query once the first page to see how many there are
    annot = g.Annotation(goId=rna_binding_goterm,
                         taxonId=taxon,
                         taxonUsage=mode,
                         goUsage='descendants',
                         geneProductType='protein',
                         geneProductSubset='Swiss-Prot',
                         limit=100
                        )
    if annot['pageInfo']['total'] > 25:
        print("WARNING: Trying to retrieve more than 2500 annotations. This is not possible from quickGO and fails silently.")
    num_pages = min(25, annot['pageInfo']['total'])
    all_dfs = []
    for page in range(1, num_pages):
        rbps = g.Annotation(goId=rna_binding_goterm,
                            taxonId=taxon,
                            taxonUsage=mode,
                            goUsage='descendants',
                            geneProductType='protein',
                            geneProductSubset='Swiss-Prot',
                            limit=100,
                            page=page)
        if type(rbps) is int:
            print (rbps, page)
        all_dfs.append(pd.DataFrame(rbps['results']))
    all_rbps = pd.concat(all_dfs)
    all_rbp_ids = all_rbps.geneProductId.unique()

    # remove trailing 'Uniprot:' of IDs
    all_rbp_ids = [i.split(':')[1] for i in all_rbp_ids]

    return all_rbp_ids


def write_fasta_for_ids(uniprot_ids, output_file):
    u = UniProt(verbose=False)
    count = 1
    all_seqs = []
    for uni_id in uniprot_ids:
        all_seqs.append(u.retrieve(uni_id, 'fasta'))
        if count % 500 == 0:
            print ("Retrieved sequence for {}/{} IDs".format(count, len(uniprot_ids)))
        count += 1
    all_fasta_seqs = [i for i in all_seqs if not type(i) == int]
    final_fasta = ''.join(all_fasta_seqs)
    with open(output_file, 'w') as f:
        f.write(final_fasta)
    #print ("Wrote {} sequences to file".format(len(all_fasta_seqs)))


def parse_args():
    parser = argparse.ArgumentParser(description='Get AA sequences for a given list of UniProt identifiers')
    parser.add_argument('-ids', '--annotation_list', help='Path to a tsv file that contains the retrieved annotations',
                        dest='annotation_file',
                        type=str
                        )
    """
    parser.add_argument('-m', '--mode', help='"descendants" if all species under the given\
                                              one should be included, otherwise "exact"',
                        dest='mode',
                        default='exact',
                        type=str
                        )
    """
    parser.add_argument('-o', '--output', help='where to write the resulting fasta file',
                        dest='output_file',
                        type=str
                        )
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    # parse arguments
    args = parse_args()
    # get UniProt IDs that match GO term RNA-binding
    #uniprot_rbp_ids = get_rbp_ids_for_taxon(taxon=args.taxon, mode=args.mode)
    #print ("Obtained {} distinct UniProt IDs of RBPs from QuickGO".format(len(uniprot_rbp_ids)))

    # read the annotations from disk & preprocess
    annotation_df = pd.read_csv(args.annotation_file, sep='\t')
    # remove all empty substrains, if recursive mode entered only the headers...
    annotation_df = annotation_df[annotation_df['GENE PRODUCT DB'] != 'GENE PRODUCT DB']
    annotation_df.set_index('GENE PRODUCT ID', inplace=True)
    uniprot_rbp_ids = annotation_df.index.unique()
    print ("Found {} unique UniProt IDs in annotation. Retrieve sequences".format(len(uniprot_rbp_ids)))
    write_fasta_for_ids(uniprot_ids=uniprot_rbp_ids, output_file=args.output_file)