%Variant 6
clear variables
%% Data
R=6300;
% object in sphere 
psi = 1 * pi / 180;  lyam = 1 * pi / 180;

q = [psi, lyam];
q0=q

% satellite coordinates
CO1 = [8720.96; -2174.38; 4383.71];
CO2 = [9088.91; 2606.2; -3255.68];

% satellite distance
dist = zeros(2, 2);
dist(:, 1) = [5328.95; 5126.68];
dist(:, 2) = [5200.3; 5269.41];

%% first approximate results
for i=1:3
    
    x=R*cos(q(1))*cos(q(2));
    y=R*cos(q(1))*sin(q(2));
    z=R*sin(q(1));
    object=[x; y; z];
    
    %calculate distance
    ro=[sqrt((x-CO1(1))^2+(y-CO1(2))^2+(z-CO1(3))^2);
        sqrt((x-CO2(1))^2+(y-CO2(2))^2+(z-CO2(3))^2);]; 
    
    deltad = [dist(1,1)-ro(1);
              dist(2,1)-ro(2);] 
    
    %partial derevatives matrix
    B =[R/ro(1)*(CO1(1)*cos(q(2))*sin(q(1))+CO1(2)*sin(q(2))*sin(q(1))-CO1(3)*cos(q(2))), ...
        R/ro(1)*cos(q(1))*(CO1(1)*sin(q(2))-CO1(2)*cos(q(2)));
        R/ro(2)*(CO2(1)*cos(q(2))*sin(q(1))+CO2(2)*sin(q(2))*sin(q(1))-CO2(3)*cos(q(2))), ...
        R/ro(2)*cos(q(1))*(CO2(1)*sin(q(2))-CO2(2)*cos(q(2)));]
    
    deltaq = B\deltad;
     q=q+deltaq;
end
q1=q(:,1);

%% second approximate results

for i=1:3
   
    x=R*cos(q(1))*cos(q(2));
    y=R*cos(q(1))*sin(q(2));
    z=R*sin(q(1));
    object=[x; y; z];
    
    %calculate distance
    ro=[sqrt((x-CO1(1))^2+(y-CO1(2))^2+(z-CO1(3))^2);
        sqrt((x-CO2(1))^2+(y-CO2(2))^2+(z-CO2(3))^2);]; 
    
    deltad = [dist(1,2)-ro(1);
              dist(2,2)-ro(2);] ;
    
    
    %partial derevatives matrix
    B =[R/ro(1)*(CO1(1)*cos(q(2))*sin(q(1))+CO1(2)*sin(q(2))*sin(q(1))-CO1(3)*cos(q(2))), ...
        R/ro(1)*cos(q(1))*(CO1(1)*sin(q(2))-CO1(2)*cos(q(2)));
        R/ro(2)*(CO2(1)*cos(q(2))*sin(q(1))+CO2(2)*sin(q(2))*sin(q(1))-CO2(3)*cos(q(2))), ...
        R/ro(2)*cos(q(1))*(CO2(1)*sin(q(2))-CO2(2)*cos(q(2)));];
    
    deltaq = B\deltad;
     q=q+deltaq;
end
q2=q(:,1);

%% Identity 

disp(['give coordinates:   [', num2str(q0(1) * 180 / pi), ', ', num2str(q0(2) * 180 / pi), ']']);
disp(['coordinates in moment t1:    [', num2str(q1(1) * 180 / pi), ', ', num2str(q1(2) * 180 / pi), ']']);
disp(['coordinates in moment t2:    [', num2str(q2(1) * 180 / pi), ', ', num2str(q2(2) * 180 / pi), ']']);
% transition matrix
S0 = [q0', q1];
S1 = [q1, q2];
F = S1 / S0;
disp('transition matrix:');
disp(F);