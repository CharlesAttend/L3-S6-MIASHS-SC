// NOM et PRENOM : VIN-CHARLES, N'GOLO TRAORE


// nettoyage

clear          // efface les variables
xdel(winsid()) // ferme les figures
clc(0)         // nettoie la console
mode(0)        // affiche les valeurs necessaires (sans ';')

// charge les procedures a utiliser

exec ChoixPas.sci
exec MethGrad.sci

// Exercice 2(a)

// Definir la fonction a optimiser

deff('[z]=F(x)','z=1/2*x(1)^2+7/2*x(2)^2');
deff('[z]=gradF(x)','z=[x(1),7*x(2)]');

// appel des fonctions pour des donnees particulieres

x0=[7;1.5];
tol=0.00001;
N = 10000;
rho = [0.25,0.1,0.05];

// gradient a pas fixe

disp("NOUVELLE LIGNE ")
sol1=GradPasFixe(x0,F,gradF,rho(1),tol,N);

plot2d(sol1(1,:),sol1(2,:),style=[4],leg="rho=0.25")
disp("NOUVELLE LIGNE ")
sol2=GradPasFixe(x0,F,gradF,rho(2),tol,N);
plot2d(sol2(1,:),sol2(2,:),style=[2],leg="rho=0.1");
disp("NOUVELLE LIGNE ")
sol3=GradPasFixe(x0,F,gradF,rho(3),tol,N);
plot2d(sol3(1,:),sol3(2,:),style=[5],leg="rho=0.05");

// gradient a pas optimal
disp("NOUVELLE LIGNE ")
sol4=GradPasOpt(x0,F,gradF,tol,N);
plot2d(sol4(1,:),sol4(2,:),style=[23]);
disp("NOUVELLE LIGNE ")
// gradient conjugue
A=[1, 0;0,7];
b=[0;0];
c=0;
sol5=GradConj(A,b,c,x0,tol);
plot2d(sol5(1,:),sol5(2,:),style=[19]);
h1=legend(['rho=0.25';'rho=0.1';'rho=0.05'; 'PasOpt'; 'GradConj'],4)
xtitle("Methodes de descente de type gradient")
