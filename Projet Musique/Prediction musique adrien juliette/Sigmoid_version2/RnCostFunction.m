function [J grad_unroll] = RnCostFunction(all_theta_unroll, ...
                                   taille_Couches, ...
                                   X, y, lambda)
% La fonction calcule le cout J ainsi que le gradient avec l'algorithme de backpropagation.
% Fonctionne pour tout configuration du réseau, indiquée dans taille_Couches.
% Les paramètres thetas sont déroullées dans all_theta_unroll.
% grad_unroll est un vecteur déroullé des dérivées partielles de J par rapport à tout les thetas.

% On doit renvoyer J et all_theta_grad déroulé.
J = 0;

% m contient le nombre d'exemples
m = size(X, 1);

% On reforme les paramètre thetas dans la variable "cell" all_theta.
all_theta = {};
all_theta_grad = {};
L = size(taille_Couches,2);
debut_vecteur = 1;
for i=1:(L-1)
	all_theta{i} = reshape(all_theta_unroll(debut_vecteur:(debut_vecteur - 1 + taille_Couches(i+1)*(taille_Couches(i) + 1))), ...
							taille_Couches(i+1),(taille_Couches(i) + 1));
	debut_vecteur = debut_vecteur + (taille_Couches(i+1)*(taille_Couches(i) + 1));
	all_theta_grad{i} = zeros(taille_Couches(i+1),(taille_Couches(i) + 1));

	%On profite de cette boucle pour calculer le terme de régularisation qu'on ajoute à J si lambda est différent de 0.
	%On ne prend pas en compte le terme de biais. Donc on enlève la première colonne de chaque matrice theta.
	if lambda ~= 0;
		J = J + sum(sum((all_theta{i}(:,2:end)).^2));

	end
end
J = (lambda/2)*J;

% On ajoute le terme de biais à X.

%X = [ones(m, 1) X];
% Dans les variable cell z et a, on met respectivement les combinaisons linéaires de la couche i dans z(i) et sigmoid(z(i)) dans a(i).
% z(i) et a(i) sont donc des vecteurs colonnes de la taille de la couche i.

for k= 1:m
	a = {};
	z = {};
	% a(1) est en fait les entrées de la première couche. z(1) ne représente rien.
	z{1} = 0;
	a{1} = X(k,:)';
	for l=2:L-1
		z{l} = all_theta{l-1}*[1 ; a{l-1}];
		a{l} = sigmoid(z{l});
	end
	%Sigmoid différente pour la dernière couche
	z{L} = all_theta{L-1}*[1 ; a{L-1}];
	a{L} = sigmoid01(z{L});
	% a(L) contient h(x). La sortie sur la dernière couche.
	% Le sum correxpond à la somme sur K, la taille de la dernière couche.
	%J = J - sum(y(k,:)'.*log(a{L}) + (1-y(k,:)').*log(1-a{L}));
	%Test d'une autre fonction de cout
	J = J + sum((a{L} - y(k,:)').^2);



	% On calcule les dérivées partielles grâce à l'algorithme de backpropagation

	% delta contient les erreurs de chaque neurones sur chaque couche.
	delta = {};
	delta{L} = (a{L} - y(k,:)').*sigmoidGradient01(z{L});
	%delta{L} = a{L} - y(k,:)';
	all_theta_grad{L-1} = all_theta_grad{L-1} + delta{L}*[1 ; a{L-1}]';

	for l=(L-1):-1:2
		% Le (2:end) correspond à ne pas calculer le terme d'erreur de biais.
		delta{l} = (all_theta{l}'*delta{l+1})(2:end).*sigmoidGradient(z{l});
		all_theta_grad{l-1} = all_theta_grad{l-1} + delta{l}*[1 ; a{l-1}]';
	end
end 

J = J/(2*m);

% On doit diviser par m toutes les matrices de gradient et ajouter le terme de régularisation.
% On en profite pour dérouler les matrices dans un vecteur colonne.
grad_unroll = [];
for l=1:(L-1)
	% La colonne de zeros sert à ne pas régulariser les termes de biais.
	all_theta_grad{l} = (all_theta_grad{l} + lambda*[zeros(size(all_theta_grad{l},1),1) all_theta{l}(:,2:end)]) / m;
	grad_unroll = [grad_unroll ; all_theta_grad{l}(:)];
end
end
