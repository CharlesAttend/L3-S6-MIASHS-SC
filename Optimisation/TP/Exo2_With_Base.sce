// Tester l'algo du simplex

// les variables globales
si_max_iterations=500;
i_tolerance_test_0=1/10^(12);
si_pivotage='mvp';
si_details=%f;
//Problème 1

//matrice des contraintes
A=[1 1 0 2 0 1 0 0 0;
   1 0 2 0 0 0 1 0 0;
   0 2 0 0 1 0 0 1 0;
   1 1 1 1 1 0 0 0 1];
//second membre
a=[8;4;9;16]
// fonction objectif
f=[-3 -4 -1 -7 -2 0 0 0 0]

// appel en donnant la matrice inverse initiale , la base et la solution de base 
Ainv=[1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1] // A^-1 de la base trivial 
bornes=[0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf] // X_i > 0
xI=[0;0;0;0;0;8;4;9;16] // Cout réduit C en bas du tableau
I=[6;7;8;9] // Indice des variable de la base triviale
epsi=[1;1;1;1;1; 0;0;0;0] // la composante vaut 1 si la variable est hors-base, 0 si elle est dans la base;
[v,x]=simplex(A,a,f,bornes,xI,epsi,Ainv,I)
//disp('solution optimale', x)
//disp(x)
disp(v,'La valeur de la solution est')
disp(x,'La solution x est')
