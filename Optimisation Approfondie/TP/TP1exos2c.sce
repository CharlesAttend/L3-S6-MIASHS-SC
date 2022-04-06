// NOM et PRENOM : VIN-CHARLES, N'GOLO TRAORE


// nettoyage

clear          // efface les variables
xdel(winsid()) // ferme les figures
clc(0)         // nettoie la console
mode(0)        // affiche les valeurs necessaires (sans ';')

// charge les procedures a utiliser

exec ChoixPas.sci
exec MethGrad.sci

// Exercice 2(c)

// Definir la fonction a optimiser
A=[10,0 ; 0,2];
b=[2;1];
c=-12;

deff('[z]=F(x)','z=1/2 * x'' * A * x - b''*x + c ');
deff('[z]=gradF(x)','z= 1/2 * x'' * (A + A'') - b'' ');

// appel des fonctions pour des donnees particulieres

x0=[1;2];
tol=0.0001;
N = 10000;
rho = [0.25,0.1,0.05];

// gradient a pas fixe

disp("NOUVELLE LIGNE GradPasFixe 1/6 ");
sol1=GradPasFixe(x0,F,gradF, 1/6 ,tol,N);
plot2d(sol1(1,:),sol1(2,:),style=[1], leg="rho=1/6");

// gradient a pas optimal
disp("NOUVELLE LIGNE Armijo")
sol4=GradPasOptArmijo(x0,F,gradF,tol,N);
plot2d(sol4(1,:),sol4(2,:),style=[2], leg="Armijo");

disp("NOUVELLE LIGNE Section dorée")
sol4=GradPasOptSectionDoree(x0,F,gradF,tol,N);
plot2d(sol4(1,:),sol4(2,:),style=[3], leg="Section_dorée");

// gradient conjugue
disp("NOUVELLE LIGNE Gradient Conjugué");
sol5=GradConj(A,b,c,x0,tol);
plot2d(sol5(1,:),sol5(2,:),style=[4], leg="GradConj");

h1=legend(['rho=1/6';'Armijo'; 'Section_dorée'; 'GradConj'],4);
xtitle("Methodes de descente de type gradient");
