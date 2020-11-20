#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data


# realisation de Trinity. 

# définition des outputs et inputs, ainsi que les listes pour les différents inputs: les R1 et les R2
input="mydata/trimmomatic"
mkdir -p mydata/trinity2
output="mydata/trinity2"
input_all1=$(ls $input/*R1_paired.fastq.gz |paste -d "," -s)
input_all2=$(ls $input/*R2_paired.fastq.gz |paste -d "," -s)
#le output est trinity 2 car on ne le run pas entièrement et on nous l'a donné dans trinity. 

#teste des listes
echo $input_all1
echo $input_all2

#Trinity en fonctionnement
Trinity --seqType fq \
        --max_memory 14G \
        --CPU 4 \
        --left $input_all1 \
        --right $input_all2 \
        --output $output \
        --SS_lib_type RF

