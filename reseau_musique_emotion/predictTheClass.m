function p = predictTheClass(all_theta, X)
% Prédit  à quelle catégorie appartiennent les données dans X en fonction du réseau de neuronne qui est donné.
% X peut contenir plusieurs exemples (1 à chaque ligne) et peut donc être une matrice.
% On ne renvoie que l'indice du max de la prédiction. 
% Si on ne veut prédire qu'un seul exemple il faut entrer un vecteur ligne.

m = size(X, 1);
nb_mat_theta = size(all_theta,2);


p = zeros(m, 1);

% Sortie de la couche 1.
h = X;
for l = 1:nb_mat_theta
	h = sigmoid([ones(m, 1) h] * (all_theta{l})');
end

%On prend le max sur chaque ligne de h
%val est un vecteur contenant la valeur maximale de chaque ligne
%p est un vecteur contenant l'indice de la valeur maximale pour chaque ligne
[val, p] = max(h, [], 2);

end
