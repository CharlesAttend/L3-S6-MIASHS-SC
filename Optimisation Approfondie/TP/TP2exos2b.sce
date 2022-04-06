// NOM et PRENOM : VIN-CHARLES, N'GOLO TRAORE


// nettoyage

clear          // efface les variables
xdel(winsid()) // ferme les figures
clc(0)         // nettoie la console
mode(0)        // affiche les valeurs necessaires (sans ';')

// charge les procedures a utiliser

exec ChoixPas.sci
exec MethGrad.sci
exec MethNewton.sci

// Definir la fonction a optimiser
deff('[z]=F(x)','z=(x(1) + x(2)^2)^2');
deff('[z]=gradF(x)','z=[2*(x(1) + x(2)^2), 4*x(2)*(x(1) + x(2)^2 )]');
deff('[z]=HessF(x)','z=[2 , 4*x(2) ; 4*x(2) , 4*( x(1) + 3*x(2)^2 )]');

// appel des fonctions pour des donnees particulieres
x0=[1;0];
tol=0.00001;
nmax = 10000;


// Newton a pas fixe
disp("NOUVELLE LIGNE Newton a pas fixe")
sol1=NewtonPasFixe(F,gradF,HessF,x0,tol,nmax);
plot2d(sol1(1,:),sol1(2,:),style=[1], leg="Newton-PasFixe");

// Newton a pas optimal
disp("NOUVELLE LIGNE Newton a pas optimal");
sol2=NewtonPasOpt(F,gradF,HessF,x0,tol,nmax)
plot2d(sol2(1,:),sol2(2,:),style=[2], leg="Newton-PasOpti");

// Quasi Newton Davidon-Fletcher-Powell
disp("NOUVELLE LIGNE Newton Davidon-Fletcher-Powell");
sol3=QuasiNewtonDFP(F,gradF,x0,tol,nmax)
plot2d(sol3(1,:),sol3(2,:),style=[3], leg="QN-DFP");

// Quasi Newton Broyden-fletcher-Goldfarb-Shanno
disp("NOUVELLE LIGNE Quasi Newton Broyden-fletcher-Goldfarb-Shanno");
sol4=QuasiNewtonBFGS(F,gradF,x0,tol,nmax)
plot2d(sol4(1,:),sol4(2,:),style=[4], leg="QN-BFGS");

// gradient pas optimal armijo
disp("NOUVELLE LIGNE Armijo");
sol5=GradPasOptArmijo(x0,F,gradF,tol,nmax);
plot2d(sol5(1,:),sol5(2,:),style=[5], leg="Armijo");

// gradient pas optimal Golstein
disp("NOUVELLE LIGNE Golstein");
sol6=GradPasOptGoldstein(x0,F,gradF,tol,nmax);
plot2d(sol6(1,:),sol6(2,:),style=[6], leg="Goldstein");

// Representation graphique
h1=legend(['Newton-PasFixe';'Newton-PasOpti';'QN-DFP';'QN-BFGS'; 'Armijo'; 'Goldstein'],4);
xtitle("Methodes de descente de type Newton");



