#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#création du sossier pour l'output de salmon index et de sa variable:
mkdir -p mydata/salmon_index
output="mydata/salmon_index"

#variable de l'input:
input="mydata/trinity/Trinity_RF.fasta"



salmon index -t $input -i $output -p 4
