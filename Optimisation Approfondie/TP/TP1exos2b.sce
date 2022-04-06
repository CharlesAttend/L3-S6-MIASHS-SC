// NOM et PRENOM : VIN-CHARLES, N'GOLO TRAORE


// nettoyage

clear          // efface les variables
xdel(winsid()) // ferme les figures
clc(0)         // nettoie la console
mode(0)        // affiche les valeurs necessaires (sans ';')

// charge les procedures a utiliser

exec ChoixPas.sci
exec MethGrad.sci

// Exercice 2(b)

// Definir la fonction a optimiser
A=[2,1 ; 1,2];
b=[-1;0];
c=0;

deff('[z]=F(x)','z=1/2 * x'' * A * x - b''*x + c ');
deff('[z]=gradF(x)','z= 1/2 * x'' * (A + A'') - b'' ');

// appel des fonctions pour des donnees particulieres

x0=[0;0];
tol=0.0001;
N = 10000;
rho = [0.25,0.1,0.05];

// gradient a pas fixe

disp("NOUVELLE LIGNE GradPasFixe 0.5 ");
sol1=GradPasFixe(x0,F,gradF,0.5,tol,N);
plot2d(sol1(1,:),sol1(2,:),style=[2],leg="rho=0.5");

// gradient a pas optimal
disp("NOUVELLE LIGNE Armijo")
sol4=GradPasOptArmijo(x0,F,gradF,tol,N);
plot2d(sol4(1,:),sol4(2,:),style=[3], leg="Armijo");

disp("NOUVELLE LIGNE Section dorée")
sol4=GradPasOptSectionDoree(x0,F,gradF,tol,N);
plot2d(sol4(1,:),sol4(2,:),style=[4], leg="SectionDorée");

// gradient conjugue
disp("NOUVELLE LIGNE Gradient Conjugué");
sol5=GradConj(A,b,c,x0,tol);
plot2d(sol5(1,:),sol5(2,:),style=[5], leg="GradConj");
h1=legend(['rho=0.5';'Armijo';'SectionDorée'; 'GradConj'],4)
xtitle("Methodes de descente de type gradient")
