#!/usr/bin/python
# -*-coding:Utf-8 -*

import csv
import os


#Chargement du premier vecteur musique (3s)
data_music = csv.reader(open("debut.csv","rb"))

#Création du fichier de sortie 
data_output = csv.writer(open("sortie.csv"))


#Initialisation des variables
predic = []

nb_sec = input('Entrer le nombre de secondes pour la séquence en sortie : ')

emo = os.system("matlab predictAllClass")

for k in range(nb_sec/3) :
	emo = eng.predictAllClass(all_theta_1,data_music)

	

