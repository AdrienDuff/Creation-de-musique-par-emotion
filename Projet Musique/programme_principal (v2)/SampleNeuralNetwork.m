function [] = SampleNeuralNetwork(nb_iteration)
% Fait tourner le réseau de neurone déjà entraîné sur un exemple en particulier

cd Réseaux
clear ; close all; clc

%Chargement des données
fprintf('-------    Prédiction d''un sample    -------\n\n')
fprintf('A partir de quel réseau voulez-vous faire le prédiction ?\nChoisir parmis :\n')
ls
file_ok =false;

while file_ok ~= true;
	fprintf('\n')
	nom_reseau = input('Nom du réseau : ','s');
	if ((exist(nom_reseau) ~= 0) || (exist(strcat(nom_reseau,'.mat')) ~= 0));
		fprintf('\nChargement des données...')
		load(nom_reseau);
		file_ok = true;
	else
		fprintf('\nNom incorrect.\n')
	end
end

cd Data
load(data_file);
cd ..


cd DataSample
fprintf('A partir de quel réseau voulez-vous faire la prédiction ?\nChoisir parmis :\n')
ls
file_ok =false;

while file_ok ~= true;
	fprintf('\n')
	sample = input('Nom du fichier contenant le vecteur de données : ','s');
	if ((exist(sample) ~= 0) || (exist(strcat(sample,'.mat')) ~= 0));
		fprintf('\nChargement des données...')
		load(sample);
		file_ok = true;
	else
		fprintf('\nNom incorrect.\n')
	end
end

fprintf('\nFait.\n')

cd ../..

%Prédiction
 p = predictAllClass(all_theta,X);
 
 %Affichage de la prédiction
 for i=1:18
     p(i)
 end
 
 
 
 cd Réseaux
 cd DataSampleResultats
 save(sample,'p');
 
cd ../..
end