clear all; 
%% Chargement des données 

%Vecteur musique d'entrée :
data_music = load('debut.csv');

%Vecteurs de poids des réseaux :
rn1 = load('emotionC_200_110_l05.mat');
rn2 = load('test_pour_caro.mat');
%nb_sec = input('Entrer le nombre de secondes pour la séquence en sortie : ');
nb_sec = 19;


%% Prédiction 
predic = data_music;
const = data_music(1:2);
for k = 1 : (nb_sec/3)
    emo = predictAllClass(rn1.all_theta, data_music)
    %size(data_music)
    predic3 = const;
    for i = 1 : length(data_music)/6
        data2 =[emo,const,data_music(9:length(data_music))];
        predic16 = predictAllClass(rn2.all_theta, data2)*2390.2;
        %size(predic16)
        data_music = [const,data_music(9:length(data_music)),predic16];
        predic3 = [predic3,predic16];
        %size(predic3)
    end
    data_music = predic3;
    predic = [predic, predic3];
end

csvwrite('sortie.csv',predic)