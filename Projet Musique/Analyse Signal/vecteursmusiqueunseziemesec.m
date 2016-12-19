clear all;

%On charge le nom des fichiers à lire dans la cellule M
fileID = fopen('musiques.csv');
M = textscan(fileID,'%s %*[^\n]', 'Delimiter',',');
fclose(fileID);

%on analyse tous les morceaux
for i=1:3223
[x,fs] = audioread(M{1}{i,1});
info = audioinfo(M{1}{i,1});


% /!\
%/ ! \
%on analyse que les 3 premieres secondes, si on veut étudier sur sur z secondes, on change tous les 3 en z dans le paragraphe suivant.
nbsec = info.Duration;
troisec = 3*size(x,1)/nbsec;
x = x(:, 1); 
x = x(1:floor(troisec)); 
nbsec = 3;


%calcul du niveau sonore
sizeX = size(x,1);
volume = 0;
for i= 1 : sizeX
    volume = volume + abs(x(i));
end
volume = volume/sizeX;


%calcul de la BPM
BPM1 = calcul_peigne(x,fs);


% /!\
%/ ! \
%deno est un facteur arbitraire qui va permette de faire des TFCT plus ou moins précises ( plus équivaut à moins de valeurs dans plus de fenetre, moins équivaut à plus de valeurs donc moins de fenêtres ).
%ici on va avoir une precision de 1/16 de seconde

deno = 16*nbsec;
window = length(x)/deno ; %création fenêtre de longueur window
[s,w,t] = spectrogram(x,window);  %on divise notre signal en fenetre de temps window


%freq echantillonnage du signal audio 44.1 Khz ( norme mondiale )
F = 0:fs/(length(s(:,1))-1):fs;
%figure
%plot(F,abs(s(:,1)));%affichage du premier echantillon

freq = zeros(5,4,floor(deno));

for l=1 : deno
    [pks,locs] = findpeaks(abs(s(:,l)),F,'SortStr','none'); %pks est un vecteur avec les maximums du premier echantillon ( premiere colonne de s )
                                %on créera plus tard une matrice pour les max
                                %par échantillon. On peut choisir un nb de
                                %pks mais pas utile lje pense..( a méditer )
    
    ampmax = max(pks)/4;    
  
	
%text(locs+.02,pks,num2str((1:numel(pks))'))%ici on a un tri par amplitude decroissante, on veut ce meme tri par
%frequence croissante ce qui nous permet de reconnaitre plus fcailement les
%hramoniques par fondamentales.

    q=1;
    p=1;
   

    while(p<6)&&(q<size(pks,1))%valeur arbitraire
        if (pks(q)>=ampmax)&&(locs(q)>27.5)&&(locs(q)<800)
            freq(1,p,l) = locs(q);
            p = p + 1;
        end
        q = q + 1;
    end

    
    for li=1 : size(freq,2);
        for lj=1 : length(locs)
            for k=2 : 5
                if(freq(1,li,l)==0)
                    freq(k,li,l)=0;
                elseif((k*freq(1,li,l) > locs(lj)-5*k) && (k*freq(1,li,l) < locs(lj)+5*k))
                    freq(k,li,l)=locs(lj);
                end
            end
        end
    end
end


%creation du vecteur final
freq1 = reshape(freq,1,[]);
final = [volume, BPM1,freq1];

%écriture de la matrice dans un fichier de donnée, à revoir pour la mettre sous forme de vecteur.
dlmwrite('resultats2.csv',final,'-append');
end
