function p = predictAllClass_type2(all_theta, X)
% Prédit  à quelle catégorie appartiennent les données dans X en fonction du réseau de neuronne qui est donné.
% X peut contenir plusieurs exemples (1 à chaque ligne) et peut donc être une matrice.
% On renvoie toutes les valeurs que nous donne le réseaau de neurones.
% Si on ne veut prédire qu'un seul exemple il faut entrer un vecteur ligne.

m = size(X, 1);

nb_mat_theta = size(all_theta,2);

% Pour l'instant on veut retourner toutes les valeurs que nous renvoie le réseau de neuronnes.


% Sortie de la couche 1.
h = X;
for l = 1:nb_mat_theta-1 
	h = sigmoid([ones(m, 1) h] * (all_theta{l})');
end
h = sigmoid01([ones(m,1) h] * (all_theta{nb_mat_theta})');
p = h;

% =========================================================================


end
