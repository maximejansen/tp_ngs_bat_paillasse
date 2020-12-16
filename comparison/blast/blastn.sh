#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data


# Entrées de référence de homo sapiences et du résultat de TransDecoder:
input_homo="mydata/blast/homo/Homo_sapiens.GRCh38.cds.fa"
input_trans="mydata/transdecoder/Trinity_RF.fasta.transdecoder.cds"

# création des dossiers de sortie et de leur direction (le premier pour la sortie de makeblastdb et l'entrée de blastn; la seconde pour la sortie de blastn):
output1="mydata/blast/makeblastdb/banque"
output2="mydata/blast/blastn/blastn.blast"
mkdir -p $output1
mkdir -p $output2


#réalisation des 2 scripts:
/softwares/ncbi-blast-2.10.1+/bin/makeblastdb -in $input_homo -dbtype nucl -parse_seqids -out $output1
/softwares/ncbi-blast-2.10.1+/bin/blastn -db $output1 -query $input_trans -evalue 1e-4 -outfmt 6 -out $output2 -max_target_seqs 1