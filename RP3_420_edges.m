%% Edge co-ordinate locations
clear all

%Ensure nodes appear at every 1 d.p value of x and z, e.g. 2.4, 2.5 etc.

% luff bottom sec.
luffbz = 3.8 ;
dz = 0 ;
luffb=[] ;
luffb(1,1)=0 ;
luffb(1,3)=3.848;

for i = 2:24
    luffbz = luffbz-dz ;
    luffb(i,3)=luffbz ;
    luffb(i,1) = (0.01348*(luffbz^2))-(0.10375*luffbz)+0.1996 ;
    dz = 0.1;
end

% luff top sec.
lufftz = 6.2 ;
dz = 0 ;
lufft=[] ;
lufft(1,1)= 0.072 ;
lufft(1,3)= 6.26 ;

for i = 2:25
    lufftz = lufftz-dz ;
    lufft(i,3)=lufftz ;
    lufft(i,1) = (0.01238*(lufftz^2))-(0.09525*lufftz)+0.18325 ;
    dz = 0.1;
end

% foot fore sec.

footforex = 0.1 ;
dx = 0 ;
footfore=[] ;
footfore(1,1)=0.072 ;
footfore(1,3)=1.537 ;
i=2 ;
j=1.5 ;
for n = 1:100
    footforex = footforex+dx ;
    footfore(i,1)=footforex ;
    footfore(i,3) = (0.09857*(footforex^2))-(0.27837*footforex)+1.55653 ;

    if footfore(i,1)>=1.412 
        footfore(i,:)=[] ;
        break
    end
    
    if footfore(i,3)<j
       footfore(i,3)=j ;
       footfore(i,1)= (0.27837-sqrt((0.27837^2)-(4*0.09857*(1.55653-j))))...
           /(2*0.09857) ;
       j=j-0.1 ;
       i=i+1 ;
       footfore(i,1)=footforex ;
       footfore(i,3) = (0.09857*(footforex^2))-(0.27837*footforex)+1.55653 ;
    end

    dx = 0.1;
    i=i+1 ;
end
    
% foot aft sec.

footaftx = 1.5 ;
dx = 0 ;
footaft=[] ;
footaft(1,1)=1.412 ;
footaft(1,3)=1.36 ;
i=2 ;
j=1.4;
for n = 1:100
    footaftx = footaftx+dx ;
    footaft(i,1)=footaftx ;
    footaft(i,3) = (0.13968*(footaftx^2))-(0.39446*footaftx)+1.63849 ;
    
      
    if footaft(i,3)>j
        footaft(i,3)=j ;
        footaft(i,1)=(0.39446+sqrt((0.39446^2)-(4*0.13968*(1.63849-j))))...
           /(2*0.13968) ;
       j=j+0.1 ;
       i=i+1 ;
       footaft(i,1)=footaftx ;
       footaft(i,3) = (0.13968*(footaftx^2))-(0.39446*footaftx)+1.63849 ;
    end
    
    if footaft(i,1)>=2.462 
        footaft(i,:)=[] ;
        break
    end
    dx = 0.1 ;
    i=i+1 ;
end
    
% head
head = [0.184,0,6.26;0.1,0,6.26] ;

% head -> top batten
headtopbattenz = 5.3 ;
dz = 0 ;
headtopbatten = [] ;
headtopbatten(1,1)=0.886 ;
headtopbatten(1,3)=5.279 ;
i=2 ;
j=0.8 ;
for n = 1:100
    headtopbattenz = headtopbattenz + dz ;
    headtopbatten(i,3) = headtopbattenz ;
    headtopbatten(i,1) = (headtopbattenz-6.51699)/(-1.39667) ;
    
    if headtopbatten(i,1)<=0.184
         headtopbatten(i,:)=[] ;
         break
    end
    
    if headtopbatten(i,1)<j
        headtopbatten(i,1)=j ;
        headtopbatten(i,3)=(-1.39667*j)+6.51699 ;
        j=j-0.1 ;
        i=i+1 ;
        headtopbatten(i,3) = headtopbattenz ;
        headtopbatten(i,1) = (headtopbattenz-6.51699)/(-1.39667) ;
    end

    dz = 0.1 ;
    i=i+1 ;
end

% half height -> tb
halftopbattenz = 3.9 ;
dz = 0 ;
halftopbatten = [] ;
halftopbatten(1,1)=1.625 ;
halftopbatten(1,3)=3.81 ;
i=2 ;
j=1.6 ;
for n = 1:100
    halftopbattenz = halftopbattenz + dz ;
    halftopbatten(i,3) = halftopbattenz ;
    halftopbatten(i,1) = (halftopbattenz-7.04021)/(-1.98782) ;
    
     if halftopbatten(i,1)<=0.886
        halftopbatten(i,:)=[] ;
        break
     end
    
    if halftopbatten(i,1)<j
        halftopbatten(i,1)=j ;
        halftopbatten(i,3)=(-1.98782*j)+7.04021 ;
        j=j-0.1 ;
        i=i+1 ;
        halftopbatten(i,3) = halftopbattenz ;
        halftopbatten(i,1) = (halftopbattenz-7.04021)/(-1.98782) ;
    end
   
    dz = 0.1 ;
    i=i+1 ;
end

% 1st batten -> half height
firstbattenhalfz = 2.6 ;
dz = 0 ;
firstbattenhalf = [] ;
firstbattenhalf(1,1)=2.062 ;
firstbattenhalf(1,3)=2.585 ;
i=2 ;
j=2 ;
for n = 1:100
    firstbattenhalfz = firstbattenhalfz + dz ;
    firstbattenhalf(i,3) = firstbattenhalfz ;
    firstbattenhalf(i,1) = (firstbattenhalfz-8.36521)/(-2.8032) ;
    
    if firstbattenhalf(i,1)<=1.625
        firstbattenhalf(i,:)=[] ;
        break
    end
    
    if firstbattenhalf(i,1)<j
        firstbattenhalf(i,1)=j ;
        firstbattenhalf(i,3)=(-2.8032*j)+8.36521 ;
        j=j-0.1 ;
        i=i+1 ;
        firstbattenhalf(i,3) = firstbattenhalfz ;
        firstbattenhalf(i,1) = (firstbattenhalfz-8.36521)/(-2.8032) ;
    end
    
    dz = 0.1 ;
    i=i+1 ;
end

% clew -> 1st batten
clewfirstbattenz = 1.6 ;
dz = 0 ;
clewfirstbatten = [] ;
clewfirstbatten(1,1)=2.462 ;
clewfirstbatten(1,3)=1.514 ;
i=2 ;
j=2.4;

for n = 1:100
    clewfirstbattenz = clewfirstbattenz + dz ;
    clewfirstbatten(i,3) = clewfirstbattenz ;
    clewfirstbatten(i,1) = (clewfirstbattenz-8.10596)/(-2.6775) ;
    
    if clewfirstbatten(i,1)<=2.062 
        clewfirstbatten(i,:)=[] ;
        break
    end
    
    if clewfirstbatten(i,1)<j
        clewfirstbatten(i,1)=j ;
        clewfirstbatten(i,3)=(-2.6775*j)+8.10596 ;
        j=j-0.1 ;
        i=i+1 ;
        clewfirstbatten(i,3) = clewfirstbattenz ;
        clewfirstbatten(i,1) = (clewfirstbattenz-8.10596)/(-2.6775) ;
    end
    dz = 0.1 ;
    i=i+1 ;
end

%% Matrix of edge co-ordinates

edges = [clewfirstbatten;firstbattenhalf;halftopbatten;headtopbatten; ...
    head;lufft;luffb;footfore;footaft] ;

plot3(edges(:,1),edges(:,2),edges(:,3),'rx')
view(20,20) ;
axis equal