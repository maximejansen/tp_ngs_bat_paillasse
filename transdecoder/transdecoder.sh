#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

# création du dossier de sortie et de sa direction:
output="mydata/transdecoder"
mkdir -p $output


# définition des entrées de fasta et de la gene_trans_map:
input="mydata/trinity/Trinity_RF.fasta"
input_map="mydata/trinity/Trinity_RF.fasta.gene_trans_map"


# Exécution des 2 scripts TransDecoder:
TransDecoder.LongOrfs -t $input --gene_trans_map $input_map -O $output -m 100 -S
TransDecoder.Predict -t $input -O $output --single_best_only
