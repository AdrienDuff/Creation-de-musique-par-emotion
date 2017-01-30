function g = sigmoid(z)
%calcul de la fonction sigmoid

g = 1.0 ./ (1.0 + exp(-z));
end
