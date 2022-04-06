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
// appel sans donner une base initiale
[v,x]=simplex(A,a,f)
disp(v,'La valeur de la solution est')
disp(x,'La solution x est')
