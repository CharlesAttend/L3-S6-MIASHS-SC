// Tester l'algo du simplex

// les variables globales
si_max_iterations=500;
i_tolerance_test_0=1/10^(12);
si_pivotage='mvp';
si_details=%f;
//Problème 1
//matrice des contraintes
A=[1 3 1 0 0;1 1 0 1 0;2 1 0 0 1];
//second membre
a=[18;8;14]
// fonction objectif
f=[-2 -3 0 0 0]
// appel en donnant la matrice inverse initiale , la base et la solution de base 
Ainv=[1 0 0;0 1 0; 0 0 1]
bornes=[0 %inf; 0 %inf; 0 %inf; 0 %inf; 0 %inf]
xI=[0;0;18;8;14]
I=[3,4,5]
epsi=[1; 1; 0 ;0 ;0]
[v,x]=simplex(A,a,f,bornes,xI,epsi,Ainv,I)
//disp('solution optimale', x)
//disp(x)
disp(v,'La valeur de la solution est')
disp(x,'La solution x est')
