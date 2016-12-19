#!/usr/bin/python
# -*-coding:Utf-8 -*

import csv
import os.path

filename = 'samples_fourrier.csv'
path_dir = 'SegLabelSoft/'
#On lit le fichier samples_fourrier
c_fourrier = csv.reader(open(filename,"rb"))
current_song = ""
c_y = csv.writer(open("emotions_y.csv", "wb"))
c_X = csv.writer(open("fourrier_X.csv", "wb"))
for row in c_fourrier:
    name_song = row[0][:-6] + ".csv"
    c_X.writerow(row[1:])

    #On ouvre le bon fichier
    if name_song != current_song:
    	samples_number = 1
    	c_samples = csv.reader(open(path_dir + name_song,"rb"))

	#il faut retrouver la bonne ligne
	ligne = 0
	for r in c_samples:
		ligne = ligne + 1
		if (ligne == samples_number + 1):
			emotions_sample = r[2:20]



    c_y.writerow(emotions_sample)
    current_song = name_song
    	


