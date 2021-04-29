%% Extract and plot edge coordinates
clear all
close all
% Call sail edge file
RP3_optimist_edges

hold on
axis equal
%Plot edges
plot3(edges(:,1),edges(:,2),edges(:,3),'r-x') 

view(20,20) ;


%% Gridpoints within the sail

%Find pairs of constant x/z and plot points between them

j=1 ;
i= round(min(edges(:,3)),1);
while i <= max(edges(:,3))

linez=find(abs(edges(:,3)-i)<0.0001) ; %Positions of z coords in edge matrix

coordz(1,:)=edges(linez(:,1),1) ; %Coords of the points found above

    if coordz(1,1)<coordz(1,2) %Sort the points by x value
         low = coordz(1,1) ;
         high = coordz(1,2) ;
    end
    if coordz(1,1)>coordz(1,2)
         low = coordz(1,2) ;
         high = coordz(1,1) ; 
    end
    
for k=0:0.1:round(max(edges(:,1)),1)
        
   if k>low && k<high %->If a point sits between the found edge points:
        fill(j,1)=k ;
        fill(j,3)=i ;
        j=j+1 ;
   end  
   
end
i=i+0.1 ;

end
plot3(fill(:,1),fill(:,2),fill(:,3),'rx')


%% Forming edges between nodes

%Generate Nodelist for edges between points & connections between edges 
%called Edge 1&2, UDLR
%Columns: 1-node ID, 2:4-pos. vector, 5:6-E1 magnitude/connected node ID, 
%7:8-E2, 9:10-U, 11:12-D,13:14-L,15:16-R
%'edges' array starts at clew and moves up the leech and around (CCW) - 153
%points

n = 1 ;
for i = 1:size(edges,(1))+size(fill,(1))

    %If in edges, find nearest 2 edges and nearest horizontal/vertical fill
    %If in fill, find 4 fills points, if no fill on one side, find edge
    %Nodelist NL has - Node ID, Edge 1,Edge 2,U,D,L,R w/ mag. for each
    
    if i <= size(edges,(1))
        j = i+1 ; 
        k = i-1 ;
        if i == size(edges,(1))
           j = 1 ; %To connect first and last edge 
        end
        
        if i == 1
            k = size(edges,(1)) ; %To connect first and last edge
        end
        
        %Edge 1 preceeds current node and edge 2 follows
        edge1v(i,:) = edges(i,:)-edges(k,:) ;
        edge2v(i,:) = edges(i,:)-edges(j,:) ;
        NL(i,2:4) = edges(i,:) ; 
        NL(i,5) = sqrt((edge1v(i,1)^2)+(edge1v(i,2)^2)+(edge1v(i,3)^2)) ;
        NL(i,6) = k ;
        NL(i,7) = sqrt((edge2v(i,1)^2)+(edge2v(i,2)^2)+(edge2v(i,3)^2)) ;
        NL(i,8) = j ;
    

        
    end
    %Filling U and D columns:
    if i>size(edges,(1))
        NL(i,2:4) = fill(n,:) ;
        %Find smallest change in z with no change in x, and vice versa
        Uops = find(abs(fill(n,1)-fill(:,1))<0.0001 &...
            (fill(:,3)>fill(n,3))) ;
        
        Uempty = isempty(Uops) ;
        
        if Uempty == 1 %When no fill value found search 'edges' matrix
            
             Uops = find(abs(fill(n,1)-edges(:,1))<0.0001 &...
                 (edges(:,3)>fill(n,3))) ;
             
             Uempty = isempty(Uops) ;
             
             if Uempty ==1 %If no node exists directly above, find nearest
                                                   
               Uops = find(abs(fill(n,1)-edges(:,1))<0.09 &...
               (edges(:,3)>fill(n,3))) ;
                                      
             end
             
             Uxmin = min(abs(edges(Uops,1)-fill(n,1))) ; %smallest x change
             Uxo = find(abs(edges(Uops,1)-fill(n,1))==Uxmin) ; %location of
             %node with smallest change in 'edges'
             Uv(i,:) = edges(Uops(Uxo),:)-fill(n,:) ; %Vector to node
             NL(i,10) = Uops(Uxo) ; %Node ID
             %Fill D matrix
             NL(Uops(Uxo),11) = sqrt((Uv(i,1)^2)+(Uv(i,2)^2)...
             +(Uv(i,3)^2)) ;
             NL(Uops(Uxo),12) = i ;
                     
        else
            Uzmin = min(abs(fill(Uops,3)-fill(n,3))) ; %Min change in z 
            %when node is directly above in 'fill' matrix
            Uxo = find(abs(fill(Uops,3)-fill(n,3))==Uzmin) ;
            Uv(i,:) = fill(Uops(Uxo),:)-fill(n,:) ;
            NL(i,10) = size(edges,(1))+Uops(Uxo) ;
            %Fill D matrix
            NL(NL(i,10),11) = sqrt((Uv(i,1)^2)+(Uv(i,2)^2)...
            +(Uv(i,3)^2)) ;
            NL(NL(i,10),12) = i ;
        
            %Uops is the possible values above, Ux/zmin gives value of min
            %x or z displacement, Uxo finds position in Uops for that value
            %,Uv finds vector to the given Uops value
        end
        
        NL(i,9) = sqrt((Uv(i,1)^2)+(Uv(i,2)^2)...
        +(Uv(i,3)^2)) ; %U magnitude
        
        %Find D entry for nodes above edge nodes
        if NL(i,12) == 0
           
           Dops = find(abs(fill(n,1)-edges(:,1))<0.0001 &...
                 (edges(:,3)<fill(n,3))) ; 
           Dempty = isempty(Dops) ;
             
             if Dempty ==1 %If no node exists directly above, find nearest
                                                   
               Dops = find(abs(fill(n,1)-edges(:,1))<0.09 &...
               (edges(:,3)<fill(n,3))) ;
           
             end
             
             Dxmin = min(abs(edges(Dops,1)-fill(n,1))) ; %smallest x change
             Dxo = find(abs(edges(Dops,1)-fill(n,1))==Dxmin) ; %location of
             %node with smallest change in 'edges'
             Dv(i,:) = edges(Dops(Dxo),:)-fill(n,:) ; %Vector to node
             NL(i,11) = sqrt((Dv(i,1)^2)+(Dv(i,2)^2)...
            +(Dv(i,3)^2)) ;
             NL(i,12) = Dops(Dxo) ; %Node ID
             %Fill U matrix
             NL(Dops(Dxo),9) = NL(i,11);
             NL(Dops(Dxo),10) = i ;
        end
        
        %Repeat process for L,R matrices
        
        Lops = find(abs(fill(n,3)-fill(:,3))<0.0001 &...
            (fill(:,1)<fill(n,1))) ;
        
        Lempty = isempty(Lops) ;
        
        if Lempty == 1 %When no fill value found search 'edges' matrix
            
             Lops = find(abs(fill(n,3)-edges(:,3))<0.0001 &...
                 (edges(:,1)<fill(n,1))) ;
             
             Lempty = isempty(Lops) ;
             
             if Lempty ==1 %If no node exists directly beside, find nearest
                                                   
               Lops = find(abs(fill(n,3)-edges(:,3))<0.09 &...
               (edges(:,1)<fill(n,1))) ;
                                      
             end
             
             Lzmin = min(abs(edges(Lops,3)-fill(n,3))) ; %smallest z change
             Lzo = find(abs(edges(Lops,3)-fill(n,3))==Lzmin) ; %location of
             %node with smallest change in 'edges'
             Lv(i,:) = edges(Lops(Lzo),:)-fill(n,:) ; %Vector to node
             NL(i,14) = Lops(Lzo) ; %Node ID
             %Fill R matrix
             NL(Lops(Lzo),15) = sqrt((Lv(i,1)^2)+(Lv(i,2)^2)...
             +(Lv(i,3)^2)) ;
             NL(Lops(Lzo),16) = i ;
                     
        else
            Lxmin = min(abs(fill(Lops,1)-fill(n,1))) ; %Min change in x 
            %when node is directly beside in 'fill' matrix
            Lxo = find(abs(fill(Lops,1)-fill(n,1))==Lxmin) ;
            Lv(i,:) = fill(Lops(Lxo),:)-fill(n,:) ;
            NL(i,14) = size(edges,(1))+Lops(Lxo) ;
            %Fill R matrix
            NL(NL(i,14),15) = sqrt((Lv(i,1)^2)+(Lv(i,2)^2)...
            +(Lv(i,3)^2)) ;
            NL(NL(i,14),16) = i ;
        
        end
        
        NL(i,13) = sqrt((Lv(i,1)^2)+(Lv(i,2)^2)...
        +(Lv(i,3)^2)) ; %L magnitude
        
        %Find R entry for nodes beside edge nodes
        if NL(i,16) == 0
           
           Rops = find(abs(fill(n,3)-edges(:,3))<0.0001 &...
                 (edges(:,1)>fill(n,1))) ; 
           Rempty = isempty(Rops) ;
             
             if Rempty ==1 %If no node exists directly beside, find nearest
                                                   
               Rops = find(abs(fill(n,3)-edges(:,3))<0.09 &...
               (edges(:,1)>fill(n,1))) ;
           
             end
             
             Rzmin = min(abs(edges(Rops,3)-fill(n,3))) ; %smallest z change
             Rzo = find(abs(edges(Rops,3)-fill(n,3))==Rzmin) ; %location of
             %node with smallest change in 'edges'
             Rv(i,:) = edges(Rops(Rzo),:)-fill(n,:) ; %Vector to node
             NL(i,15) = sqrt((Rv(i,1)^2)+(Rv(i,2)^2)...
            +(Rv(i,3)^2)) ;
             NL(i,16) = Rops(Rzo) ; %Node ID
             %Fill U matrix
             NL(Rops(Rzo),13) = NL(i,15);
             NL(Rops(Rzo),14) = i ;
        end
        
        n = n+1 ;
    end
    NL(i,1) = i ;
    
end
    
%% Plotting edges

% Create Matrices for vectors E1,U,L (E2,D,R are equal and opposite) called
% VV,HV,EV (V/H/E Vector). Also plot the corresponding lines for inspection

for i = 1:size(NL,(1))
    
    if NL(i,6) == 0 
      EV(i,:) = 0 ;
    else
      EVplot(1,:) = NL(i,2:4) ;
      EVplot(2,:) = NL(NL(i,6),2:4) ;
      EV(i,:) = EVplot(1,:)-EVplot(2,:) ;
      plot3(EVplot(:,1),EVplot(:,2),EVplot(:,3),'b-')
    end
    
    if NL(i,10) == 0   
      VV(i,1:3) = 0 ;    
    else        
      VVplot(1,:) = NL(i,2:4) ;
      VVplot(2,:) = NL(NL(i,10),2:4) ;
      VV(i,:) = VVplot(1,:)-VVplot(2,:) ;
      plot3(VVplot(:,1),VVplot(:,2),VVplot(:,3),'b-')
    end
    
     if NL(i,14) == 0   
      HV(i,1:3) = 0 ;    
    else        
      HVplot(1,:) = NL(i,2:4) ;
      HVplot(2,:) = NL(NL(i,14),2:4) ;
      HV(i,:) = HVplot(1,:)-HVplot(2,:) ; 
      plot3(HVplot(:,1),HVplot(:,2),HVplot(:,3),'b-')
     end     
    
     EVmag(i,1)=sqrt(EV(i,1)^2+EV(i,2)^2+EV(i,3)^2) ; 
     HVmag(i,1)=sqrt(HV(i,1)^2+HV(i,2)^2+HV(i,3)^2) ;
     VVmag(i,1)=sqrt(VV(i,1)^2+VV(i,2)^2+VV(i,3)^2) ; 
    
end

%Convert NL to a table for quick reading

NLTable = array2table(NL,'VariableNames',{'ID','x-pos','y-pos','z-pos', ...
    'E1 mag','E1 ID','E2 mag','E2 ID','U mag','U ID','D mag','D ID', ...
    'L mag','L ID','R mag','R ID'}) ;










    
    
    
