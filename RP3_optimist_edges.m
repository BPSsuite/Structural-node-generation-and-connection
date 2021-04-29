%% Edge co-ordinate locations
clear all

%Ensure nodes appear at every 1 d.p value of x and z, e.g. 2.4, 2.5 etc.

% Luff

luff(:,3) = linspace(0.5,2.2,18) ;

% Head

% Peak point found from simultaneous eqns:

 n = 0 ;
 j = 1 ;
 for i = 1:100
     
     head(j,1) = n ;
     head(j,3) = 0.99024*n + 2.23 ;
     % Use rnd func to input all dy -> 0.1
     if i>1 && head(j,3) > rnd(head(j-1,3),1)
         
        head(j+1,:) = [n,0,head(j,3)] ;
        nz = round(head(j-1,3)+(head(j,3) - head(j-1,3))/2,1) ;
        head(j,:) = [(nz - 2.23)/0.99024, 0 , nz] ;
        j = j+1 ; 
     end
     
     if head(j,1) > 0.8 
         
         head(j,:) = [0.8811,0,3.1025] ;
         break ;         
     end
     n = n+0.1 ;
     j = j+1 ;
 end

% Leech top section

% Top batten from sim. eqs. (length 1m)

leecht(15,1) = 1.52 ;
leecht(15,3) = 2.3333 ;
j = 1 ;
n = 3.1 ;
for i = 1:100
    
    leecht(j,3) = n ;
    leecht(j,1) = (n-4.1633)/-1.20394 ;
    
    if i>1 && leecht(j,1) > rnd(leecht(j-1,1),1)
         
        leecht(j+1,:) = [leecht(j,1),0,n] ;
        nx = round(leecht(j-1,1)+(leecht(j,1) - leecht(j-1,1))/2,1) ;
        leecht(j,:) = [nx, 0 ,-nx*1.20394+4.1633 ] ;
        j = j+1 ; 
     end
     
     if leecht(j,1) > 1.5 
         
         leecht(j,:) = [1.52,0,2.3333] ;
         break ;         
     end
    
    j = j+1 ;
    n = n-0.1 ;
end


% Leech mid section

%peak -> bb = 1.9m?
%sits on locus from peak point
%normal from midpoint of leechmid is 1.7m to luff (x=0)
%negative reciprocal of gradient set at midpoint 

leechm(9,:) = [1.7644,0,1.4203] ; 

n = 2.3 ;
j = 1 ;
for i = 1:100
    
    
   leechm(j,1) = (n-8.01153)/-3.73568 ;
   leechm(j,3) = n ;
   
     if i>1 && leechm(j,1) > rnd(leechm(j-1,1),1)
         
        leechm(j+1,:) = [leechm(j,1),0,n] ;
        nx = round(leechm(j-1,1)+(leechm(j,1) - leechm(j-1,1))/2,1) ;
        leechm(j,:) = [nx, 0 ,-nx*3.73568+8.01153 ] ;
        j = j+1 ; 
     end
     
     if leechm(j,1) > 1.76 
         
         leechm(j,:) = [1.7644,0,1.4203] ;
         break ;         
     end
    
    j = j+1 ;
    n = n-0.1 ;
end

% Leech base section

for i = 5:14
    
    n = i/10 ;
    leechb(15-i,1) = (n-12.2744)/-6.15174 ;
    leechb(15-i,3) = n ;
    
end

% Foot

for i = 1:19
    
   n = i/10 ; 
   foot(20-i,3) = 0.01638*n^2 - 0.03135*n + 0.5 ; 
   foot(20-i,1) = n ;
   
end

edges = [luff ; head ; leecht ; leechm ; leechb ; foot] ;
hold on
axis equal
plot3(edges(:,1),edges(:,2),edges(:,3),'rx')
view(20,20) ;




