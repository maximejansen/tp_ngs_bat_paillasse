#! /bin/bash

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

#création du dossier pour salmon quant
mkdir -p mydata/salmon_quant

#execution du programme 
for n in $var
do
salmon quant -i mydata/salmon_index -l A -1 $input/Lib${n}_31_20_S${n}_R1_paired.fastq.gz -2 $input/Lib${n}_31_20_S${n}_R2_paired.fastq.gz --validateMappings -o mydata/salmon_quant
done

