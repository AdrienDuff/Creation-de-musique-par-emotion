#!/usr/bin/python
# -*-coding:Utf-8 -*

import os.path

rep = "SegLabelSoft"
noms = os.listdir(rep)
for nom in noms:
	new_name = nom.replace('_','')
	#Cette ligne sert juste pour un fichier avec les perhaps.
	new_name = nom.replace(',','-')
	os.rename(rep + "/" + nom, rep + "/" + new_name)
