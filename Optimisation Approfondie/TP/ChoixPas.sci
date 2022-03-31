// Méthodes de recherche linéaire
//

// section dorée
function pas=SectionDoree(phi,x,di,tol)
    // calcul de T
    T=1
    while (phi(x+T*di)< phi(x))
        T=2*T
    end
    alpha=(sqrt(5)-1)/2
    a=0;b=T;c=alpha*a+(1-alpha)*b;d=a+b-c
    while (abs(b-a)>2*tol) do
        if (phi(x+c*di)<phi(x+d*di)) then
            b=d;d=c;c=a+b-d
        else
            a=c;c=d;d=a+b-c
        end
    end
    pas=(a+b)/2
endfunction

// règle d'Armijo
//
function pas=Armijo(phi,gradphi,x,d,m)
    t=1
    z=gradphi(x)*d
    while (phi(x+t*d)>=phi(x)+m*t*z) do
        t=-1/2*t^2*z/(phi(x+t*d)-phi(x)-t*z)
    end
    pas=t
endfunction

// règle de Goldstein
//
function pas=Goldstein(phi,gradphi,x,d,m1,m2)
    amin=0;amax=40
    test=%f
    z=gradphi(x)*d
    while (~test) do
        rho=(amin+amax)/2
        g=phi(x+rho*d)
        if (g<=phi(x)+m1*rho*z) then
            if (g>=phi(x)+m2*rho*z) then
                test=%t
            else
                amin=rho
            end
        else
            amax=rho
        end
    end
    pas=rho
endfunction
