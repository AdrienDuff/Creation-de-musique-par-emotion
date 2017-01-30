function g = sigmoidGradient(z)


%retourne le gradient de la fonction sigmoide évaluée en z

g = zeros(size(z));
sig_z = sigmoid(z);
g = sig_z .* (1 - sig_z);


end
