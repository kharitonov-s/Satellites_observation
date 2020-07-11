%Variant 3 

R=6300; 

%% approximate of object position 
nl=1; %northern latitude 
el=1; %eastern longitude 
q = [nl; el]; 

%% satellite 1 
sat1_x= 8720.96; 
sat1_y=-2174.38; 
sat1_z= 4383.71; 

%% satellite 2 
sat2_x= 9088.91; 
sat2_y= 2606.2; 
sat2_z=-3255.68; 

%% given distance 
givdis1= 5196.41; %given distence to 1st satellite 
givdis2= 5277.57; %given distance to 2nd satellite 

%% Object position calculation
 q=q*pi/180;
for i=1:3
    
  %  q=q*pi/180;
    x=R*cos(q(1))*cos(q(2));
    y=R*cos(q(1))*sin(q(2));
    z=R*sin(q(1));
    object=[x; y; z];
    
    ro=[sqrt((x-sat1_x)^2+(y-sat1_y)^2+(z-sat1_z)^2);
        sqrt((x-sat2_x)^2+(y-sat2_y)^2+(z-sat2_z)^2);]; %calculate distance
    
    deltad = [givdis1-ro(1);
        givdis2-ro(2);] ;
    
    
    %partial derevatives matrix
    B =[R/ro(1)*(sat1_x*cos(q(2))*sin(q(1))+sat1_y*sin(q(2))*sin(q(1))-sat1_z*cos(q(2))), ...
        R/ro(1)*cos(q(1))*(sat1_x*sin(q(2))-sat1_y*cos(q(2)));
        R/ro(2)*(sat2_x*cos(q(2))*sin(q(1))+sat2_y*sin(q(2))*sin(q(1))-sat2_z*cos(q(2))), ...
        R/ro(2)*cos(q(1))*(sat2_x*sin(q(2))-sat2_y*cos(q(2)));];
    
    deltaq = B\deltad;
    %q=q*180/pi
    q=q+deltaq;
    s = ['Approximation ', num2str(i) ,':'];
    disp(s)
    disp(q/pi*180) %object position in degrees 
    
end
%round(q/pi*180*100) / 100