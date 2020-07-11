%% Time
month=2; 
date=14;
hour=14;
min=11;
t_0=3; %Greenwich time zone shift

b=[0,31,28,31,30,31,30,31,31,30,31,30];
B=0;
for i=1:month
    B=B+b(i);
end
T = (mod(B+date-81,365))*1440+(hour-t_0)*60+min; %time in minutes

%% Satellites coordinates
sat=zeros(3,12);

% TRANZIT 
TR_tau= [40,10,100,80,50,110];
TR_omega= [30,60,120,210,270,330];
TR_omega=TR_omega*pi/180; %degree to radian
TR_R=7500;        %orbit radius-vector
TR_i=90;          %orbit inclination 
TR_i=TR_i*pi/180; %degree to radians
TR_angleV=3;      %angular velocity (degree/min)
TR_angleV=TR_angleV * pi/180; %degree to radian

% matrix A for transition from Equatorial coordinates to Greenwich
gamma = mod((0.25+72/(73*1440))*T,360);
gamma = gamma*pi/180;  %degree to radian
A = [cos(gamma), -sin(gamma), 0;  sin(gamma), cos(gamma), 0; 0, 0, 1;];

for i=1:length(TR_tau)
    u=TR_angleV * (T - TR_tau(i));
   GrCoord = A' * TR_R * [cos(u)*cos(TR_omega(i))-sin(TR_omega(i))*cos(TR_i)*sin(u); 
        sin(TR_omega(i))*cos(u)+cos(TR_omega(i))*cos(TR_i)*sin(u);
        sin(TR_i)*sin(u);]; %from Osculating coordinates to Greenwich
    sat(:,i)=GrCoord;
end

% GPS
GPS_tau= [30,100,70,0,150,120];
GPS_omega= [0,45,90,135,210,300];
GPS_omega=GPS_omega*pi/180; %degree to radian
GPS_R=15000;        %orbit radius-vector
GPS_i=60;          %orbit inclination 
GPS_i=GPS_i*pi/180; %degree to radians
GPS_angleV=2;      %angular velocity (degree/min)
GPS_angleV=GPS_angleV * pi/180; %degree to radian

for i=1:length(GPS_tau)
    u=GPS_angleV * (T - GPS_tau(i));
   GrCoord = A' * GPS_R * [cos(u)*cos(GPS_omega(i))-sin(GPS_omega(i))*cos(GPS_i)*sin(u); 
        sin(GPS_omega(i))*cos(u)+cos(GPS_omega(i))*cos(GPS_i)*sin(u);
        sin(GPS_i)*sin(u);];%from Osculating coordinates to Greenwich
    sat(:,i+6)=GrCoord;
end

%% Object coordinates

%coordinates from task2v3
s=0;   %nl. northern latitude
d=71;   %el. eastern longitude
r=6300; %Earth radius

s=s*pi/180; %degree to radians
d=d*pi/180; %degree to radians
x=r*cos(s)*cos(d);
y=r*cos(s)*sin(d);
z=r*sin(s);

q=[x;y;z];

%% Area of visibility
is_vis = false(1, 12);
scal_prod = zeros(1, 12);
for k=1:12
    %visability condition
   scal_prod(k) = (q' * (sat(:,k) - q));
            if (scal_prod(k) > 0)
                is_vis(k) = true; 
            else
                is_vis(k) = false;
            end
end
      

%% Output
fprintf('\nVisible satelites:\n');
fprintf('TRANZIT: ');
for k = 1:6
    if is_vis(k)
        fprintf(int2str(k));
        fprintf(' ');
    end
end
fprintf('\n');
fprintf('GPS:     ');
for k = 7:12
    if is_vis(k)
        fprintf(int2str(k-6));
        fprintf(' ');
    end
end
fprintf('\n');