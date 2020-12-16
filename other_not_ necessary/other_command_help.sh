#!/bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

nouhup ./fichier.sh >& nohup/fichier.out &

grep ">" mydata/trinity/Trinity_RF.fasta |less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|sort|less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|sort |uniq |less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|sort |uniq |wc -l