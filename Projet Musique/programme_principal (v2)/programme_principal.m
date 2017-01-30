clear all; 
%% Chargement des données 

%Vecteur musique d'entrée :
finput = input('Entrer le nom du fichier en entrée (vecteur compo musique) : ','s');
data_music = load(finput);

%Vecteurs de poids des réseaux :
rn1 = load('emotionC_200_110_l05.mat');
rn2 = load('predi_150_70.mat');
nb_sec = input('Entrer le nombre de secondes pour la séquence en sortie (multiple de 3) : ');



%% Prédiction 

%Initialisation du vecteur de sortie :
%on met au début la séquence d'entrée
predic = data_music;

%Constantes tempo et volume du vecteur d'entrée :
const = data_music(1:2);

%Création de séquences de musique de 3s :
%Explication des variables :
% - predic3 = séquence de 3s prédite
% - predic16 = séquence de 1/16s prédite
for k = 1 : (nb_sec/3)
    %Exécution du réseau de neurone 1 : extraction de l'émotion
    emo = predictAllClass_type1(rn1.all_theta, data_music);
    
    %Initialisation de la prédiction avec les constantes :
    predic3 = const;
    
    %Prédiction de la prochaine séquence de 3s par prédiction de 1/16s :
    %1/16s représente 6 éléments du vecteur musique
    for i = 1 : length(data_music)/6
        %Construction du vecteur d'entrée du réseau de neurone 2 : 
        % prédiction du 1/16s suivant
        data2 =[emo,const,data_music(9:length(data_music))];
        
        %Exécution du réseau de neurone 2 :
        %Remarque : on multiplie par 2390.2 pour se remette à l'échelle
        %(effacer la normalisation des données -entre 0 et 1)
        predic16 = predictAllClass_type2(rn2.all_theta, data2)*2390.2;
        % predic16 = predictAllClass_type1(rn2.all_theta, data2)*2390.2;
        
       
        %On modifie le vecteur musique en supprimant le premier 1/16s
        %et en ajoutant le 1/16s prédit.
        %On garde les constantes devant.
        data_music = [const,data_music(9:length(data_music)),predic16];
        
        %On construit la séquence de 3s prédite en ajoutant les 1/16s 
        %à chaque tour de boucle
        predic3 = [predic3,predic16];
       
    end
    
    %On modifie le vecteur musique avec la nouvelle séquence de 3s prédite.
    data_music = predic3;
    
    %On construit la prédiction complète en ajoutant la nouvelle séquence
    %de 3s
    predic = [predic, predic3];
end

%% Sortie

%On enregistre le vecteur sortie dans un fichier (mettre les extensions
%dans la saisie du nom de fichier
foutput = input('Entrer le nom du fichier de sortie : ','s');
csvwrite(foutput,predic)