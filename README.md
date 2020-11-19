# TP NGS Bat paillasse

readme du projet ngs



# Jour 1:

Une fois les données récupérées sur le serveur de l'IGFL et une connections au GitHub réalisée, on à commencer par regarder ce que l'ont a à faire et comment le faire.

Il y a six couples que je te donner numéroter entre 1 et 6. Chaque couple est représenté par deux fichiers représentant les 2 Read nommés R1 et R2, soit d'un Paired-End Reads.


# Jour 2:

On a commencé par examiner la qualité des jeux de données que l'on a reçu. Pour ce faire, on a utilisé le programme FASTQC afin de pouvoir analyser la qualité des différents jeux de données comprenant le séquençage des ARNm. On peut retrouver le code qui a été écrit pour faire cela dans le fichier Trinity.sh

Les résultats obtenus via ce programme ont étaient rangés dans mydata/fastqc/original_data

voici 2 résultats type:
![GitHub Logo](/picture/Lib1_31_20_S1_R1_001.fastq.gz.png)
![GitHub Logo](/picture/Lib1_31_20_S1_R2_001.fastq.gz.png)

Comme on peut constater, les résultats sont globalement concluant sur la qualité des séquençage. Au revanche, on peut constater qu'il y a des problèmes au niveau des neuf premiers pas de base ainsi que à la fin de chaque séquence. Pour ce dernier, il est possible que ce soit les inserts qui soit aussi analyser, réduisant ainsi la fiabilité à la fin. Pour régler le problème, on a décidé de faire fonctionner le logiciel Trimmomatic afin de régler les différents problèmes Ainsi que d'harmoniser les différents séquençage. 

Il est possible de voir le code utilisé aussi dans Trinity.sh, à la suite. La suite est réalisée avec uniquement les paired fichiers. Le résultat de Trimmomatic se situe dans mydata/trimmomatic. 


# Jour 3:

En premier lieu, le programme FASTQC À été relancé cette Fois ci sur les résultats de Trimmomatic paired. Étant donné qu'il n'y avait pas de nouvelles anomalies et que tout s'est bien passé, on a pu continuer avec la suite. les résultats de cela se situe dans mydata/fastqc/trimmomatic. il est possible de trouver le code utilisé dans Trinity.sh, à la suite de ce qui à étaient fait hier. 

Nous avons par la suite utiliser le script Trinity, un outil d'assemblage de novo, afin de pouvoir avoir tous les variants de gènes exprimés. Au total il y en a environ 311 000 gene, soit 10 fois plus que de gène codant dans une cellule. seul les paired de Trimmomatic on était pris avec un assemblage de tous les R1 contre les R2. Le résultat de Trinity se trouve dans mydata/trinity. on peut y voire tout les paramètres utilisés à la suite du fichier Trinity.sh. Comme cela aurait pris 2 jour, on nous la finalement donner. 

Enfin, afin de quantifier le résultat obtenu avec Trinity, nous avons utilisé Salmon pour quantifier. Ainsi nous avons utilisé le programme index de Salmon afin de créer en premier lieu une index grâce au résultat de Trinity. Le code utilisé est le fichier salmon_index.sh. Le résultat a été créé dans mydata/salmon_index. 
Cela a été utilisé pour faire la quantification via l'outil quant de Salmon. l'input 1 est un fichier R1, et R2 pour l'input 2 de la même série, ainsi que l'index créé. le code utilisé est le script salmon_quant.sh. Le résultat se trouve dans mydata/salmon_quant. 



