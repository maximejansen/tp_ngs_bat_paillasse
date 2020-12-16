#!/bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#création des input et de la variable de la boucle
input="mydata/trimmomatic"
var="1
2
3
4
5
6"

# input de l'index:
indexon="mydata/salmon_index"

#création du dossier pour salmon quant et de sa variable
mkdir -p mydata/salmon_quant
output="mydata/salmon_quant"

#execution du programme 
for n in $var
do
salmon quant -i $indexon -l A -1 $input/Lib${n}_31_20_S${n}_R1_paired.fastq.gz -2 $input/Lib${n}_31_20_S${n}_R2_paired.fastq.gz --validateMappings --gcBias -p 4 -o $output/quant_${n}
done

