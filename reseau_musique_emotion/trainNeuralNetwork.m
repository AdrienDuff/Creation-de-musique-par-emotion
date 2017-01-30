function [] = trainNeuralNetwork(nb_iteration)
% Cette fonction peut entraîner un réseau de neuronne quelconque sur une base d'exemples
% implémentation de l'évaluation prpre au reseau musique-émotion sur ces mêmes données, puis sur d'autres.
% Le nombre d'itérations est à préciser ici.

cd Réseaux
clear ; close all; clc

fprintf('-------    Entrainement d''un réseau    -------\n\n')
fprintf('Quel réseau voulez-vous entrainer ?\nChoisir parmis :\n')
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
fprintf('\nFait.\n')
% On a maintenant accès à toutes les variables caratérisant les réseaux :
% lambda, taille_Couches, all_theta, repartition_exemple, tps_entrainement et nb_iteration_entrainement 

%  Et à la base d'entraînement
% X et y

cd ../..

%on calcule m1,m2,m3. Ce sont les nombres d'exemples réservés pour l'entrainement et les vérifications.
m = size(X,1);
if ((repartition_exemple(2) == 0) && (repartition_exemple(3) == 0));
	m1 = m;
	m2 = 0;
	m3 = 0;
	X_entrainement = X;
	y_entrainement = y;
	X_verif1 = 0;
	y_verif1 = 0;
	X_verif2 = 0;
	y_verif2 = 0;
elseif repartition_exemple(3) == 0;
	m1 = floor((m*repartition_exemple(1))/100);
	m2 = m - m1;
	m3 = 0;
	X_entrainement = X(1:m1,:);
	y_entrainement = y(1:m1,:);
	X_verif1 = X(m1+1:end,:);
	y_verif1 = y(m1+1:end,:);
	X_verif2 = 0;
	y_verif2 = 0;
else
	m1 = floor((m*repartition_exemple(1))/100);
	m2 = floor((m*repartition_exemple(2))/100);
	m3 = m - m1 - m2;
	X_entrainement = X(1:m1,:);
	y_entrainement = y(1:m1,:);
	X_verif1 = X(m1+1:m1+m2,:);
	y_verif1 = y(m1+1:m1+m3,:);
	X_verif2 = X(m1+m2+1:end,:);
	y_verif2 = y(m1+m2+1:end,:);
end

%Il faut dérouler tout les paramètres theta dans un vecteur.
inital_theta_unroll = all_theta{1}(:);
%L contient le nb de couches
L = size(taille_Couches,2);
for i=2:(L-1)
	inital_theta_unroll = [inital_theta_unroll ; all_theta{i}(:)];
end
% on fait un raccourcie sur la fonction en précisant explicitement que c'est une fonction de p, c'est à dire tout les thetas.
costFunction = @(p) RnCostFunction(p, ...
                                   taille_Couches, ...
                                   X_entrainement, y_entrainement, lambda);


%On choisie le nombre d'itération pour la fonction fmincg, sauf si c'était en paramètre

if ~exist('nb_iteration', 'var') || isempty(nb_iteration)
    nb_iteration = input('Nombre d''itération :');
end

options = optimset('MaxIter', nb_iteration);

[all_theta_unroll, cost] = fmincg(costFunction, inital_theta_unroll, options);
nb_iteration_entrainement = nb_iteration_entrainement + nb_iteration;

% On reforme all_theta
all_theta = {};
L = size(taille_Couches,2);
debut_vecteur = 1;
for i=1:(L-1)
	all_theta{i} = reshape(all_theta_unroll(debut_vecteur:(debut_vecteur - 1 + taille_Couches(i+1)*(taille_Couches(i) + 1))), ...
							taille_Couches(i+1),(taille_Couches(i) + 1));
	debut_vecteur = debut_vecteur + (taille_Couches(i+1)*(taille_Couches(i) + 1));
end

 
% On teste l'efficacité du réseau de neurone .

% Plusieurs méthodes d'évaluation du réseau musique-émotion

%Pour les exemples sur lesquelles on s'est entrainé.

% évaluation basique
if 0
 nb_reussi = 0;
 % On fait la prédiction
 p = predictAllClass(all_theta1,X_entrainement);
 for i = 1:m1     %m1 étant le nombre d'exemples sur lesquels on s'est entraîné
 	if y_entrainement(i) == p(i);
 		nb_reussi = nb_reussi + 1;
 	end
 end
 %
 pourc_reussi_entrainement = (nb_reussi / m1)*100;
 sprintf('\n\nPourcentage de réussite pour l''entrainement : %f',pourc_reussi_entrainement)
end
 
 %%% (1) Prédiction correcte si la case maximale de la prédiction est non nulle dans le y de la base 
if 0
  nb_reussi = 0;
 % On fait la prédiction
 p = predictTheClass(all_theta,X_entrainement);
 for i = 1:m1     %m1 étant le nombre d'exemples sur lesquels on s'est entraîné
 	if y_entrainement(i,p(i)) ~= 0;
 		nb_reussi = nb_reussi + 1;
 	end
 end

 pourc_reussi_entrainement = (nb_reussi / m1)*100;
 sprintf('\n\nPourcentage de réussite pour l''entrainement : %f',pourc_reussi_entrainement)
end
 

 %%% (2) Prédiction correcte si la case maximale de la prédiction est aussi la case maximale dans le y de la base 
if 0
  nb_reussi = 0;
 % On fait la prédiction
 p = predictTheClass(all_theta,X_entrainement);
 [val, q] = max(y_entrainement, [], 2);
 for i = 1:m1     %m1 étant le nombre d'exemples sur lesquels on s'est entraîné
 	if y_entrainement(i,p(i)) == y_entrainement(i,q(i));
 		nb_reussi = nb_reussi + 1;
 	end
 end

 pourc_reussi_entrainement = (nb_reussi / m1)*100;
 sprintf('\n\nPourcentage de réussite pour l''entrainement : %f',pourc_reussi_entrainement)
end
 
  %%% (3) Prédiction correcte si les 2 cases maximales de la prédiction sont non nulles dans le y de la base 
if 0
 nb_reussi = 0;
 % On fait la prédiction
 [p1,p2] = predict2Class(all_theta,X_entrainement);
 for i = 1:m1     %m1 étant le nombre d'exemples sur lesquels on s'est entraîné
 	if y_entrainement(i,p1(i)) ~= 0 && y_entrainement(i,p2(i)) ~= 0 ;
 		nb_reussi = nb_reussi + 1;
 	end
 end

 pourc_reussi_entrainement = (nb_reussi / m1)*100;
 sprintf('\n\nPourcentage de réussite pour l''entrainement : %f',pourc_reussi_entrainement)
end
 
 %%% (4) Prédiction correcte si tous les indices de la prédiction et de la base sont égaux à + ou - 0,2 près

 nb_reussi = 0;
 % On fait la prédiction
 p = predictAllClass(all_theta,X_entrainement);
 for i = 1:m1 %m1 étant le nombre d'exemples sur lesquels on s'est entraîné
     
 	if p(i)>=y_entrainement(i)-0.2 && p(i)<=y_entrainement(i)+0.2 ;
 		nb_reussi = nb_reussi + 1;
 	end
 end
 
 pourc_reussi_entrainement = (nb_reussi / m1)*100;
 sprintf('\n\nPourcentage de réussite pour l''entrainement : %f',pourc_reussi_entrainement)

 
 % ========================================================================
 % ========================================================================


%Pour les exemples sur lesquelles on ne s'est pas entrainé.

%  évaluation basique
if 0
if repartition_exemple(2) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictAllClass(all_theta1,X_verif1);
	for i = 1:m2     %m2 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif1(i) == p(i);
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi1 = (nb_reussi / m2)*100;
	sprintf('\n\nPourcentage de réussite 1 : %f',pourc_reussi1)
end
end

%%% (1)
if 0
if repartition_exemple(2) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictTheClass(all_theta1,X_verif1);
	for i = 1:m2     %m2 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif1(i,p(i)) ~= 0;
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi1 = (nb_reussi / m2)*100;
	sprintf('\n\nPourcentage de réussite 1 : %f',pourc_reussi1)
end
end

%%% (2)
if 0
if repartition_exemple(2) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictTheClass(all_theta1,X_verif1);
  [val, q] = max(y_verif1, [], 2);
	for i = 1:m2     %m2 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif1(i,p(i)) == y_verif1(i,q(i));
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi1 = (nb_reussi / m2)*100;
	sprintf('\n\nPourcentage de réussite 1 : %f',pourc_reussi1)
end
end


%%% (4)

if repartition_exemple(2) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictAllClass(all_theta,X_verif1);
	for i = 1:m2     %m2 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
        save(nom_reseau,'p');
		if p(i)>=y_verif1(i)-0.2 && p(i)<=y_verif1(i)+0.2;
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi1 = (nb_reussi / m2)*100;
	sprintf('\n\nPourcentage de réussite 1 : %f',pourc_reussi1)
end

 % ========================================================================
 % ========================================================================
 
 
%Pour les exemples sur lesquelles on ne s'est pas entrainé.

% évaluation basique
if 0
if repartition_exemple(3) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictAllClass(all_theta1,X_verif2);
	for i = 1:m3  %m3 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif2(i) == p(i);
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi2 = (nb_reussi / m3)*100;
	sprintf('\n\nPourcentage de réussite 2 : %f',pourc_reussi2)
end
end

%%%(1)
if 0
if repartition_exemple(3) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictTheClass(all_theta1,X_verif2);
	for i = 1:m3  %m3 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif2(i,p(i)) ~= 0;
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi2 = (nb_reussi / m3)*100;
	sprintf('\n\nPourcentage de réussite 2 : %f',pourc_reussi2)
end
end

%%%(2)
if 0
if repartition_exemple(3) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictTheClass(all_theta1,X_verif2);
  [val, q] = max(y_verif2, [], 2);
	for i = 1:m3  %m3 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if y_verif2(i,p(i)) == y_verif2(i,q(i));
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi2 = (nb_reussi / m3)*100;
	sprintf('\n\nPourcentage de réussite 2 : %f',pourc_reussi2)
end
end

%%% (4)

if repartition_exemple(3) ~= 0
	nb_reussi = 0;
	% On fait la prédiction
	p = predictAllClass(all_theta,X_verif2);
	for i = 1:m3  %m3 étant le nombre d'exemples sur lesquels on ne s'est pas entraîné
		if p(i)>=y_verif2(i)-0.2 && p(i)<=y_verif2(i)+0.2;
			nb_reussi = nb_reussi + 1;
		end
	end

	pourc_reussi2 = (nb_reussi / m3)*100;
	sprintf('\n\nPourcentage de réussite 2 : %f',pourc_reussi2)
end


% On enregistre les pourcentages de réussites avec les paramètres du réseau
cd Réseaux
fprintf('\nEnregistrement des paramètres dans le fichier %s','evaluationBasique')
save('evaluationBasique','taille_Couches','lambda','data_file','repartition_exemple','pourc_reussi_entrainement','pourc_reussi1','pourc_reussi2','tps_entrainement','nb_iteration_entrainement','all_theta');
fprintf('\nFait.\n')
cd ..
end