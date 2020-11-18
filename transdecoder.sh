#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data


grep ">" mydata/trinity/Trinity_RF.fasta |less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|short |less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|short |uniq |less
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|short |uniq |wc -l
