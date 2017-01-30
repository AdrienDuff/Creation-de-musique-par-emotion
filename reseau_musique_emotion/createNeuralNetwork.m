% 
%  Ce programme permet la création d'un réseau de neuronne.
%  On choisit le nombre de couche et le nombre de noeud par couche ainsi que d'autres paramètres.

%% Initialisation
clear ; close all; clc
fprintf('-------    Création d''un nouveau réseau de neurones    -------\n\n')

%L'utilisateur choisit la configuration du réseau de neuronnes
taille_Couches = input('Nombre d''entrées pour la première couche (sans le biais) : ');
nb_couches_cachees = input('Nombre de couche(s) cachées : ');
answer = 0;
while ((answer ~= 'y') & (answer ~= 'n'));
  answer = input('Même nombre de neurones par couche ? (y/n) ','s');
end
if (answer == 'y');
  nb_neurone_par_couche = input('Combien de neurones par couche ? ');
  taille_Couches = [taille_Couches (ones(1,nb_couches_cachees)*nb_neurone_par_couche)];
else
  sprintf('\n\nTaille Couche d''entrée : %d',taille_Couches(1,1))
  for i = 1:nb_couches_cachees
    fprintf('Taille Couche %d : ',i+1)
    taille = input('');
    taille_Couches = [taille_Couches taille];
  end
end
taille = input('Taille couche de sorties : ');
taille_Couches = [taille_Couches taille];
fprintf('Les dimensions des différentes couches sont :')
disp(taille_Couches)

%L'utilisateur choisit un nom pour son réseau de neurones. On pourra ainsi enregistrer plusieurs réseaux.
%Les paramètres du réseaux de neurones sont enregistrés dans le dossier Réseaux.
if exist('Réseaux') == 0; % Si le dossier 'Réseaux n'existe pas
  mkdir Réseaux;
end
cd Réseaux;
existe = 2;
while existe == 2;
  nom_reseau = input('Choisir un nom pour ce réseau de neurones : ','s');
  existe = exist(nom_reseau);
end
nom_reseau = strcat(nom_reseau,'.mat');
cd ..;


%Maintenant nous allons initialiser les différentes matrices théta autour de 0.
%Nous stockons toutes les matrices thetas dans all_theta. C'est un tableau à 1 dimension (cell) de matrices.
fprintf('\n\nInitialisation des matrices theta...')
all_theta = {};
nb_couche = size(taille_Couches,2);
for i= 1:(nb_couche-1)
  all_theta{i} = randInitializeWeights(taille_Couches(i),taille_Couches(i+1));
end
fprintf('\nFait.\n\n')

%L'utilisateur choisit le paramètre lambda
lambda = input('Paramètre de régularisation lambda : ');

cd Réseaux;
%L'utilisateur choisit la base d'entrainement. Il faut un fichier .mat du dossier Data avec une matrice X de taille m*nb_features_entrée (sans biais)
%Et y de de taille m. y contient ainsi le numéro de la classe à laquelle appartient X.
fprintf('\nFichier de données. Ce fichier au format .mat doit contenir une matrice X de taille m*nb_de_noeuds_en_entrée, ainsi qu''une matrice Y de taille m*1.\n')
fprintf('Ce fichier doit se situer dans le dossier Data du dossier Réseaux.')
cd Data
%On vérifie que le fichier de données existe et est conforme aux attentes.

file_ok = false;
while file_ok ~= true;
  fprintf('\n\nChoisir parmis :\n')
  ls
  data_file = input('Nom du fichier qui contient les données : ','s');
  if ((exist(data_file) ~= 0) | (exist(strcat(data_file,'.mat')) ~= 0)); % Si le fichier existe, on le charge
    load(data_file);
    if size(X,2) ~= taille_Couches(1);
      fprintf('\nLe nombre de colonne de X (%d) ne correspond pas au nombre de neurones en entrée (%d)',size(X,2),taille_Couches(1))
    else
      if size(y,2) ~= 1;
        fprintf('\nOn ne doit avoir qu''une seule colonne pour y, ici il y en a (%d)',size(y,2))
      else
        if size(X,1) ~= size(y,1)
          fprintf('\nIl n''y a pas le même nombre d''exemple dans X (%d) et y (%d)',size(X,1),size(y,1))
        else
          m = size(X,1);
          fprintf('\nLes données sont conformes, il y a %d exemples.\n',m)
          file_ok = true;
        end
      end
    end
  else
    fprintf('\nLe fichier n''existe pas !')
  end
end

cd ..

%L'utilisateur choisit le pourcentage d'exemples qui vont servir pour l'entrainement et pour la vérification.
fprintf('\n\n')
answer = 0;
while ((answer ~= 'y') & (answer ~= 'n'));
	answer = input('Choisir la répartition de la base d''entrainement par défault [60,20,20] ? (y/n) ','s');
end
if (answer == 'y');
	repartition_exemple = [60 20 20];
else
	somme = 0;
	while somme ~= 100;
		fprintf('\n La somme des 3 chiffres doit faire 100\n')
		m1 = input('Choisir le pourcentage d''exemples qui va servir à l''entrainement : ');
		m2 = input('Choisir le pourcentage d''exemples qui va servir à vérifier le résultat (1) : ');
		m3 = input('Choisir le pourcentage d''exemples qui va servir à vérifier le résultat (2) : ');
		somme = m1 + m2 + m3;
	end
	repartition_exemple = [m1 m2 m3];
end

%On initialise le temps pour lequel le réseau s'est entrainé à 0.
%On initialise le nb d'itération effectué pour l'entrainement du réseau à 0.
tps_entrainement = 0;
nb_iteration_entrainement = 0;
pourc_reussi_entrainement = 0;
pourc_reussi1 = 0;
pourc_reussi2 = 0;

%On enregistre le réseaux de neurones
fprintf('\nEnregistrement des paramètres dans le fichier %s',nom_reseau)
save(nom_reseau,'taille_Couches','lambda','data_file','repartition_exemple','pourc_reussi_entrainement','pourc_reussi1','pourc_reussi2','tps_entrainement','nb_iteration_entrainement','all_theta');
fprintf('\nFait.\n')
cd ..;
