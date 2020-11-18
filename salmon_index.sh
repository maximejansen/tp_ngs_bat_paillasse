#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data


mkdir -p mydata/salmon_index

salmon index -t mydata/trinity/Trinity_RF.fasta -i mydata/salmon_index -p 4
