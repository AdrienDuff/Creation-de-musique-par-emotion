function W = randInitializeWeights(L_in, L_out)
% Initialise aléatoirement une matrice de taille L_out*(1 + L_in)
% On prend donc en compte le biais de la couche d'entrée.
%On casse la simétrie grâce à cette initialisation aléatoire
W = zeros(L_out, 1 + L_in);

%epsilon init = 0.12;
%On utilise la note qui nous founie une bonne stratégie de choix pour epsilon_init.
epsilon_init = sqrt(6) / sqrt(L_in + L_out);
W = rand(L_out, 1 + L_in) * 2 * epsilon_init - epsilon_init;

%Chaque composante est comprise entre -epsilon_init et epsilon_init

end
