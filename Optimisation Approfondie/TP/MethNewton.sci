// methodes de Newton et quasi Newton
//
//méthode de Newton à pas fixe
function sol=NewtonPasFixe(F,gradF,HessF,x0,tol,nmax)
    k=1
    sol(:,k)=x0
    x=x0
    g=gradF(x0)
    H=HessF(x0)
    d=-H\g'
    while(abs(g*d)>tol & k<=nmax) do
        k=k+1
        x=x+d
        sol(:,k)=x
        H=HessF(x);g=gradF(x)
        d=-H\g'
    end
    disp(k-1,'nombre d''itérations méthode de Newton pas fixe')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction
//
// méthode de Newton pas optimal
//
function sol=NewtonPasOpt(F,gradF,HessF,x0,tol,nmax)
    k=1
    sol(:,k)=x0
    x=x0
    g=gradF(x0)
    H=HessF(x0)
    d=-H\g'
    //utiliser armijo pour recherche linéaire
    m=0.3
    while(abs(g*d)>tol & k<=nmax) do
        k=k+1
        rho=Armijo(F,gradF,x,d,m)
        x=x+rho*d
        sol(:,k)=x
        H=HessF(x);g=gradF(x)
        d=-H\g'
    end
    disp(k-1,'nombre d''itérations méthode de Newton pas optimal')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction
//
// Quasi Newton Davidon-Fletcher-Powell
//
function sol=QuasiNewtonDFP(F,gradF,x0,tol,nmax)
    k=1
    sol(:,k)=x0
    x=x0
    g=gradF(x0)
    //utiliser goldstein pour recherche linéaire
    m1=0.4; m2=0.7
    B=eye(size(x0,1),size(x0,1))
    while(abs(g*(B*g'))>tol & k<=nmax) do
        k=k+1
        d=-B*g'
        rho=Goldstein(F,gradF,x,d,m1,m2)
        v=rho*d
        x=x+v
        w=gradF(x)-g
        g=g+w
        u=B*w'
        B=B-(u*u')/(w*u)+(v*v')/(v'*w')
        sol(:,k)=x
    end
    disp(k-1,'nombre d''itérations méthode BFS')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction
// QuasiNewton Broyden-fletcher-Goldfarb-Shanno
//
function sol=QuasiNewtonBFGS(F,gradF,x0,tol,nmax)
    k=1
    sol(:,k)=x0
    x=x0
    g=gradF(x0)
    //utiliser goldstein pour recherche linéaire
    m1=0.4; m2=0.7
    B=eye(size(x0,1),size(x0,1))
    while(abs(g*(B*g'))>tol & k<=nmax) do
        k=k+1
        d=-B*g'
        rho=Goldstein(F,gradF,x,d,m1,m2)
        v=rho*d
        x=x+v
        w=gradF(x)-g
        g=g+w
        u=B*w'
        B=B+1/(w*v)*(1+(w*u)/(w*v))*v*v'-(B*w'*v'+v*w*B)/(w*v)
        sol(:,k)=x
    end
    disp(k-1,'nombre d''itérations méthode de BFGS')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction
