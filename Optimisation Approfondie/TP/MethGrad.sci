// Methodes de descente de gradient 
//

// gradient pas fixe
function sol=GradPasFixe(x0,F,gradF,rho,tol,nmax)
    k=1
    sol(1,k)=x0(1)
    sol(2,k)=x0(2)
    x=x0
    d=gradF(x)'
    while (norm(d,2)>tol & k<=nmax) do
        x(1)= x(1)-rho*d(1)
        x(2)=x(2)-rho*d(2)
        d=gradF(x)'
        k=k+1
        sol(1,k)=x(1)
        sol(2,k)=x(2)
    end
    disp(k-1,'=',rho,'Nombre d itérations Pas')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction

// gradient pas optimal
function solPO=GradPasOptArmijo(x0,F,gradF,tol,nmax)
    k=1
    solPO(1,k)=x0(1)
    solPO(2,k)=x0(2)
    x=x0
    d=-gradF(x)'
    //utiliser armijo pour recherche linéaire
    m=0.3
    while (norm(d,2)>tol & k<=nmax) do
        rho=Armijo(F,gradF,x,d,m)
//        rho=SectionDoree(F,x,d,tol)
//        rho=Goldstein(F,gradF,x,d,0.3,0.7)
        x(1)= x(1)+rho*d(1)
        x(2)=x(2)+rho*d(2)
        d=-gradF(x)'
        k=k+1
        solPO(1,k)=x(1)
        solPO(2,k)=x(2)
    end    
    disp(k-1,'Nombre d itérations Pas Optimal=')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction

function solPO=GradPasOptSectionDoree(x0,F,gradF,tol,nmax)
    k=1
    solPO(1,k)=x0(1)
    solPO(2,k)=x0(2)
    x=x0
    d=-gradF(x)'
    
    m=0.3
    while (norm(d,2)>tol & k<=nmax) do
        // rho=Armijo(F,gradF,x,d,m)
        rho=SectionDoree(F,x,d,tol)
//        rho=Goldstein(F,gradF,x,d,0.3,0.7)
        x(1)= x(1)+rho*d(1)
        x(2)=x(2)+rho*d(2)
        d=-gradF(x)'
        k=k+1
        solPO(1,k)=x(1)
        solPO(2,k)=x(2)
    end    
    disp(k-1,'Nombre d itérations Pas Optimal=')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction

function solPO=GradPasOptGoldstein(x0,F,gradF,tol,nmax)
    k=1
    solPO(1,k)=x0(1)
    solPO(2,k)=x0(2)
    x=x0
    d=-gradF(x)'
    
    m=0.3
    while (norm(d,2)>tol & k<=nmax) do
        // rho=Armijo(F,gradF,x,d,m)
        // rho=SectionDoree(F,x,d,tol)
        rho=Goldstein(F,gradF,x,d,0.3,0.7)
        x(1)= x(1)+rho*d(1)
        x(2)=x(2)+rho*d(2)
        d=-gradF(x)'
        k=k+1
        solPO(1,k)=x(1)
        solPO(2,k)=x(2)
    end    
    disp(k-1,'Nombre d itérations Pas Optimal=')
    disp(x,'solution')
    disp(F(x),'Valeur optimale')
endfunction

// gradient conjugué
//
function sol=GradConj(A,b,c,x0,tol)
    k=1
    x=x0
    sol(:,k)=x
    r=b-A*x
    d=r
    s=norm(r,2)^2
    while (s>tol) do
        rho=(r'*r)/(d'*(A*d))
        x=x+rho*d
        r=b-A*x
        u=norm(r,2)^2
        d=r+(u/s)*d
        s=u
        k=k+1
        sol(:,k)=x
    end
   disp(k-1,'nombre d itérations Gradient conjugué=')
   disp(x,'solution')
   disp(x'*A/2*x-b'*x+c,'Valeur optimale')
endfunction


