function [v,xI,epsi,Ainv,I,d,uI] = simplex(A,a,f,bornes,xI,epsi,Ainv,I)
//*********************************************************
// DESS ISN PETITE IMPLANTATION DE SIMPLEX
// BB, dimanche 26 octobre 2003
//*********************************************************
// soubroutine simplex.sci 
//*********************************************************
// en entree 3 utilisitions sont possibles
//    
// simplex(A,a,f) : 
// simplex(A,a,f,bornes) : 
// simplex(A,a,f,bornes,xI,epsi,Ainv)  
//   resout min (fx : Ax=a, x >= bornes[:,1], x <= bornes[:,2]) 
//   definir d'abord variable globale : si_pivotage in { 'mvp','bland','sep' }  
//                       mvp: most violating pricing (Dantzig)
//                       bland: pivotage de Bland
//                       sep: steepest edge pricing (Harris)           
//   epsi est un vecteur de longueur n comportant 
//         0 si la composante correspondante est en base
//         1 si la composante correspondante correspond a la borne inf
//        -1 si la composante correspondante correspond a la borne sup
//   si appel sans base etc: calcul en 2 phases
//            avec base realisable : simplex primal
//            avec base avec CSO :   simplex dual
//   Ainv est une matrice de type [m,m], 
//   I est un vecteur ligne a m coposants indicant les indices de ligne de Ainv 
//*********************************************************
// en sortie six utilisitions sont possibles
//
// v=simplex(...) ou [v]=simplex(...) ou simplex(...) :
//                       retourne la valeur optimale 
//     v = + infty : probleme impossible (avec averissement)
//     v = - infty : probleme non borne  (avec averissement)
//     (infty est une valiable globale a definir par l'utilisateur)
// [v,x]=simplex(...):
// [v,x,epsi,Ainv,I]=simplex(...):
// [v,x,epsi,Ainv,I,d]=simplex(...):
// [v,x,epsi,Ainv,I,d,uI]=simplex(...):
//            en option: x=x(1:n,1) solution optimale
//            en option: d=d(1,1:n) vecteur couts reduits 
//            en option: uI=uI(1,I) vecteur couts marginaux 
//*********************************************************
global si_max_iterations si_tolerance_test_0 si_pivotage si_details;
si_max_iterations=500;
si_tolerance_test_0=1/10^(12);
si_pivotage='mvp';
si_details=2;

[m,n]=size(A);
v=+%inf;
//si_tolerance_test_0=0.00000001
//si_details=2

// d'abord savoir quel mode d'invocation
[lhs,rhs]=argn(0);
if rhs==3 then
   // c'est un probleme sous forme standard
         bornes=[zeros(n,1),%inf*ones(n,1)];
end;         
if rhs<=4 then
   // c'est un probleme sans base initiale, demarrage de premiere phase 
   // testons d'abord les bornes
   if size(bornes)<>[n,2] then
      if size(bornes,1)==0 then 
         // c'est un probleme sous forme standard
         bornes=[zeros(n,1),%inf*ones(n,1)];
      elseif size(bornes,2)==1 then 
         // c'est un probleme sous forme standard
         bornes=[bornes,%inf*ones(n,1)];
      else
         disp('Problemes avec format des bornes');return;
      end;
   end;
   // ensuite on choisit epsi et x pour les premiers indices
   xI=zeros(n,1);epsi=zeros(n,1);
   for j=1:n
      if abs(bornes(j,1))<abs(bornes(j,2)) then
         xI(j)=bornes(j,1);epsi(j)=1;
      else
         xI(j)=bornes(j,2);epsi(j)=-1;
      end;
   end;
   // etendre les objets pour phase 1
   xI=[xI;a-A*xI]; epsi=[epsi;zeros(m,1)];
   A=[A,zeros(m,m)]; f_old=f; f=[zeros(1,m+n)]; 
   bornes=[bornes;zeros(m,2)]; 
   // mettre a jour diagonale de A, bornes  
   for j=1:m
      A(j,j+n)=1;
      if xI(j+n)>0 then
         f(j+n)=1;bornes(j+n,:)=[0,xI(j+n)];
      else
         f(j+n)=-1;bornes(j+n,:)=[xI(j+n),0];
      end;
   end;
   if si_details>=1 then write(%io(2),'Simplex Phase 1'); end;
   Ainv=A(:,n+1:n+m); I=[n+1:m+n];
   [v,xI,epsi,Ainv,I] = simplex(A,a,f,bornes,xI,epsi,Ainv,I);
   if v>0 then 
      if si_details>=1 then write(%io(2),'SIMPLEX phase 1: Polyedre vide');end;
      v=%inf; return;
   elseif sum(abs(epsi(n+1:m+n,1)))<m then
      disp('Problemes avec degenerescence en phase 1');return;
   end;
   // revenir aux donnees initiales 
   A=A(:,1:n);xI=xI(1:n);f=f_old;epsi=epsi(1:n);bornes=bornes(1:n,:);
end; 

//disp(size(A));disp(size(Ainv));disp(size(bornes));disp(size(xI));disp(size(epsi));disp(size(f));disp(I);

// avant de boucler on determine si simplex (dual=%f) ou duale (dual=%t)
 uI=f(I)*Ainv; 
 d=f-uI*A;
 // changement ana
 if min(d.*epsi')>=-si_tolerance_test_0 then
   // CSO vrai
   if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
     // solution optimale trouvee
     v=f*xI;
     if si_details==2 then
      disp(['d=',string(d)]);
      disp(['x=',string(xI')]);
      disp(['x=',string(xI')]);
      disp(['epsi=',string(epsi')]);
     end; 
     if si_details>=1 then write(%io(2),'SIMPLEX: Solution optimale en 0 iterations');end;
     return;     
   else
     // on veut seulement violer les bornes au niveau de I, par consequent,
     // on doit recalculer le point de base, et reverifier si le nouveau point est realisable
     b=a;
     for j=1:n
        if epsi(j)==1 then
           xI(j)=bornes(j,1);b=b-A(:,j)*xI(j);
        end;   
        if epsi(j)==-1 then
           xI(j)=bornes(j,2);b=b-A(:,j)*xI(j);
        end;   
     end;
     b=Ainv*b;xI(I)=b;
     if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
       // solution optimale trouvee
       v=f*xI;
       if si_details==2 then
        disp(['d=',string(d)]);
        disp(['x=',string(xI')]);
        disp(['epsi=',string(epsi')]);
       end; 
       if si_details>=1 then write(%io(2),'DUAL SIMPLEX: Solution optimale en 0 iterations');end;
       return;     
     end;
     dual=%t;
   end;
 else
   if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
        dual=%f;
   else
     // on doit recalculer le point de base, et reverifier si le nouveau point est realisable
     b=a;
     for j=1:n
        if epsi(j)==1 then
           xI(j)=bornes(j,1);b=b-A(:,j)*xI(j);
        end;   
        if epsi(j)==-1 then
           xI(j)=bornes(j,2);b=b-A(:,j)*xI(j);
        end;   
     end;
     b=Ainv*b;xI(I)=b;
     if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
        dual=%f;
     else
        if si_details==2 then
          disp(['d=',string(d)]);
          disp(['x=',string(xI')]);
          disp(['bornes inf=',string(bornes(:,1)')]);
          disp(['bornes sup=',string(bornes(:,2)')]);
          disp(['epsi=',string(epsi')]);
        end; 
        disp('SIMPLEX erreur: la base n''est ni optimale ni realisable');
        return;        
     end;
   end;   
 end;
//
//
// tout est pret pour demarrer simplex, on initialise les compteurs
si_compteur_iterations=0;
//
// et on boucle
disp(si_pivotage)
si_max_iterations=1000
while  si_compteur_iterations <= si_max_iterations
 si_compteur_iterations=si_compteur_iterations+1;
 if si_details==2 then disp('iteration no='+string(si_compteur_iterations));end;
 // verification numerique  
 erreur=norm(d(I),'inf')+norm(a-A*xI,'inf');
 if erreur > si_tolerance_test_0 then
       // recalculer inverse, point de base, cout reduits
       if si_details>=1 then write(%io(2),'SIMPLEX: Mise a jour inverse');end;
       Ainv=inv(A(:,I));
       b=a;
       for j=1:n 
          if abs(epsi(j))>0 then
             if epsi(j)==1 then xI(j)=bornes(j,1);else xI(j)=bornes(j,2);end; 
             b=b-A(:,j)*xI(j);
          end;
       end;
       b=Ainv(:,1:m)*b;
       for j=1:m, xI(I(j))=b(j);end;
       uI=f(I)*Ainv; d=f-uI*A;
 end;

 // recherche theta, TIs, r, s selon simplex ou simplex dual
 if ~dual then
    // simpex classique
    // recherche de s selon pivotage
    s=0; compare = %inf;
    if si_pivotage=='mvp' then
       for j=1:n
          if epsi(j)*d(j)<compare then 
             s=j; compare=epsi(s)*d(s);
          end;
       end;
    elseif si_pivotage=='bland' then
       j=0; compare = %inf;
       while compare >= 0 
         j=j+1; compare=epsi(j)*d(j);
       end;
       if compare<0 then s=j;end;
    end;
    if s==0 then 
       disp('SIMPLEX: problemes choix de s apres '+string(si_compteur_iterations)+' iterations.');return;
    end;
    TIs=Ainv*A(:,s);
    t=xI(I,1);
    // recherche de theta, r
    theta=bornes(s,2)-bornes(s,1);r=s;
    for j=1:m 
       rpot=I(j);
       if epsi(s)*TIs(j)>si_tolerance_test_0 then
          if theta>(xI(rpot)-bornes(rpot,1))/(epsi(s)*TIs(j)) then
              r=rpot;rligne=j;
              theta=(xI(rpot)-bornes(rpot,1))/(epsi(s)*TIs(j)); 
          end;
       elseif epsi(s)*TIs(j)<-si_tolerance_test_0 then 
          if theta>(xI(rpot)-bornes(rpot,2))/(epsi(s)*TIs(j)) then
              r=rpot;rligne=j;
              theta=(xI(rpot)-bornes(rpot,2))/(epsi(s)*TIs(j)); 
          end;
       end;
    end; 
    if theta==%inf then
       v=-%inf;
       if si_details>=1 then 
         write(%io(2),['SIMPLEX: probleme non borne apres '+string(si_compteur_iterations)+' iterations.']);
       end;  
       return;
    end;
 else
  // simplex dual
  // d'apres construction, r=s est impossible
    Iinv=zeros(n,1); for j=1:m, Iinv(I(j))=j;end;
    // recherche de r selon pivotage
    r=0; theta = 0;
    if si_pivotage=='mvp' then
       for k=1:m
          j=I(k);
          if xI(j)-bornes(j,1)<-abs(theta) then  
             r=j; theta=xI(r)-bornes(r,1);
          end;
          if bornes(j,2)-xI(j)<-abs(theta) then  
             r=j; theta=xI(r)-bornes(r,2);
          end;
       end;
    elseif si_pivotage=='bland' then
       k=0;
       while theta==0 
         k=k+1; j=I(k); 
         theta=min(0,xI(j)-bornes(j,1))+max(0,xI(j)-bornes(j,2));
       end;
       if theta<>0 then r=j;end;
    end;
    if r==0 then 
       disp('DUAL SIMPLEX: problemes choix de r apres '+string(si_compteur_iterations)+' iterations.');
       return;
    end;
    // recherche de s
    rligne=Iinv(r);
    TIr=Ainv(rligne,:)*A;
    s=0;compare=%inf;
    for j=1:n 
       if sign(theta)*epsi(j)*TIr(j)>si_tolerance_test_0 then
           if compare>abs(d(j)/TIr(j)) then 
              s=j;compare=abs(d(j)/TIr(j));
           end;
       end;
    end;
    if s==0 then
       v=+%inf;
       if si_details>=1 then 
         write(%io(2),['DUAL SIMPLEX: probleme impossible apres '+string(si_compteur_iterations)+' iterations.']);
       end;
       return;
    end;    
    // mise a jour theta
    theta=theta/(epsi(s)*TIr(s));
    // calcul TIs
    TIs=Ainv*A(:,s);
 end;

if si_details==2 then disp(['r=',string(r),'s=',string(s)]);end;
  
  
   // mise a jour de Ainv
 if r<>s then 
if si_details==2 then disp(['rligne=',string(rligne)]); end;
    Ainv(rligne,:)=Ainv(rligne,:)/TIs(rligne);
    for j=1:m
       if j <> rligne then
          for k=1:m
             Ainv(j,k)=Ainv(j,k)-TIs(j)*Ainv(rligne,k);
          end;
       end;
    end;
 end;
 // mise a jour de xI, I, epsi
 xI(s)=xI(s)+theta*epsi(s);
 for j=1:m
    xI(I(j))=xI(I(j))-epsi(s)*theta*TIs(j);
 end;
 if r==s then 
    epsi(s)=-epsi(s); 
    if epsi(s)==1 then xI(s)=bornes(s,1);else xI(s)=bornes(s,2);end;
 else
    if dual then
      if epsi(s)*TIs(rligne)<0 then 
       epsi(r)=1; xI(r)=bornes(r,1);
      else 
       epsi(r)=-1; xI(r)=bornes(r,2);
      end;
    else
      if epsi(s)*TIs(rligne)>0 then 
       epsi(r)=1; xI(r)=bornes(r,1);
      else 
       epsi(r)=-1; xI(r)=bornes(r,2);
      end;
    end;  
    epsi(s)=0;
    I(rligne)=s;
 end;
 // on oblige les variables en base "proches" aux bornes d'etre egal aux bornes
// for j=1:m
//   k=I(j);
//   if (bornes(k,1)>xI(k)) & (bornes(k,1)-si_tolerance_test_0<=xI(k)) then
//      xI(k)=bornes(k,1);
//   elseif  (bornes(k,2)<xI(k)) & (bornes(k,2)+si_tolerance_test_0>=xI(k)) then 
//      xI(k)=bornes(k,2);
//   end;   
// end;
 // mise a jour de d, uI
 uI=f(I)*Ainv; d=f-uI*A;
 
 if si_details==2 then
     disp(['d=',string(d)]);
     disp(['x=',string(xI')]);
//     disp(['theta=',string(theta)]);
     disp(['epsi=',string(epsi')]);
 end;
 // tester criteres d'arret
 if dual then
   if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
      // realisable, solution optimale trouvee
     if min(d.*epsi')>=-si_tolerance_test_0 then   
       v=f*xI;
       if si_details>=1 then 
         write(%io(2),['DUAL SIMPLEX: Solution optimale en '+string(si_compteur_iterations)+' iterations.']);
       end;
       return;
     else
       dual=%f;
       if si_details>=1 then 
         write(%io(2),['DUAL SIMPLEX: erreurs d''arrondi, passage a SIMPLEX apres '+string(si_compteur_iterations)+' iterations.']);
       end;  
     end;  
   end;
 else
   if min(d.*epsi')>=-si_tolerance_test_0 then
      // CSO vrai, solution optimale trouvee
     if (min(xI-bornes(:,1))>=-si_tolerance_test_0) & (min(bornes(:,2)-xI)>=-si_tolerance_test_0) then
       v=f*xI;
       if si_details>=1 then 
         write(%io(2),['SIMPLEX: Solution optimale en '+string(si_compteur_iterations)+' iterations.']);
       end;  
       return;
     else
       dual=%t;
       if si_details>=1 then 
         write(%io(2),['SIMPLEX: erreurs d''arrondi, passage a DUAL SIMPLEX apres '+string(si_compteur_iterations)+' iterations.']);
       end;  
     end;  
   end;
 end;
 if si_compteur_iterations == si_max_iterations then
    disp('SIMPLEX: nombre maximum d''iterations atteint'); 
 end;
end; 
endfunction;

function []=si_init(vari,value)
  global si_max_iterations si_tolerance_test_0 si_pivotage si_details si_bb_details si_bb_choix si_bb_sepa;
  [lhs,rhs]=argn(0);
  if rhs==0 then
       si_max_iterations=500;
       si_tolerance_test_0=10^(-13);
       si_pivotage='mvp';
       si_details=1;
       si_bb_details=1;   // %t, %f
       si_bb_choix='filo'; // fifo, filo, best  
       si_bb_sepa='mvp'; // mvp, bland, phb, peb
       write(%io(2),'Parametres SIMPLEX: si_max_iterations='+string(si_max_iterations));
       write(%io(2),'Parametres SIMPLEX: si_tolerance_test_0='+string(si_tolerance_test_0));  
       write(%io(2),'Parametres SIMPLEX: si_pivotage='+si_pivotage+' [mvp,bland]');  
       write(%io(2),'Parametres SIMPLEX: si_details='+string(si_details)+' [0,1,2]');  
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_details='+string(si_bb_details)+' [0,1,2]');  
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_choix='+si_bb_choix+' [fifo, filo, best]');  
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_sepa='+si_bb_sepa+' [mvp, bland, phb, peb, mvp_mod, bland_mod]');  
  else
    if vari=='si_max_iterations' then 
       si_max_iterations=value;
       write(%io(2),'Parametres SIMPLEX: si_max_iterations='+string(si_max_iterations));
    elseif vari=='si_tolerance_test_0' then
       si_tolerance_test_0=value;
       write(%io(2),'Parametres SIMPLEX: si_tolerance_test_0='+string(si_tolerance_test_0));  
    elseif vari=='si_pivotage' then
       si_pivotage=value;
       write(%io(2),'Parametres SIMPLEX: si_pivotage='+si_pivotage+' [mvp,bland]');  
    elseif vari=='si_details' then
       si_details=value;
       write(%io(2),'Parametres SIMPLEX: si_details='+string(si_details)+' [0,1,2]');  
    elseif vari=='si_bb_details' then
       si_bb_details=value;
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_details='+string(si_bb_details)+' [0,1,2]');  
    elseif vari=='si_bb_choix' then
       si_bb_choix=value;
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_choix='+si_bb_choix+' [fifo, filo, best]');  
    elseif vari=='si_bb_sepa' then
       si_bb_sepa=value;
       write(%io(2),'Parametres BB_SIMPLEX: si_bb_sepa='+si_bb_sepa+' [mvp, bland, phb, peb, mvp_mod, bland_mod]');  
    end;
  end;
endfunction;
