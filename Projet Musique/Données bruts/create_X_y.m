filename_X = 'fourrier_X.csv';
filename_y = 'emotions_y.csv';
X = csvread(filename_X);
y = csvread(filename_y);

%On doit mélanger les lignes
m = size(X,1);
%On génère une permutation aléatoire de longeur m
perm = randperm(m);
X = X(perm,:);
y = y(perm,:);

save('samples_fourrier.mat','X','y')