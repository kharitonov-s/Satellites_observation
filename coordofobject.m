%% coordinates of object in Greenwich system

s=0;   %nl. northern latitude
d=71;   %el. eastern longitude
r=6300; %Earth radius

s=s*pi/180; %degree to radians
d=d*pi/180; %degree to radians


x=r*cos(s)*cos(d);
y=r*cos(s)*sin(d);
z=r*sin(s);

object=[x;y;z];


%% time moment "t" (in minutes)

month=2; %february
date=14;
hour=14;
min=11;
t_0=3; %Greenwich time zone shift

b=[0,31,28,31,30,31,30,31,31,30,31,30];
B=0;
for i=1:month
    B=B+b(i);
end
 
t = (mod(B+date-81,365))*1440+(hour-t_0)*60+min;


%% TRANZIT 
TR_tau= [40,10,100,80,50,110];
TR_omega= [30,60,120,210,270,330];
TR_omega=TR_omega*pi/180; %degree to radian
TR_R=7500;        %orbit radius-vector
TR_i=90;          %orbit inclination 
TR_i=TR_i*pi/180; %degree to radians
TR_angleV=3;      %angular velocity (degree/min)
TR_angleV=TR_angleV * pi/180; %degree to radian

%% GPS
GPS_tau= [30,100,70,0,150,120];
GPS_omega= [0,45,90,135,210,300];
GPS_omega=GPS_omega*pi/180; %degree to radian
GPS_R=15000;        %orbit radius-vector
GPS_i=60;          %orbit inclination 
GPS_i=GPS_i*pi/180; %degree to radians
GPS_angleV=2;      %angular velocity (degree/min)
GPS_angleV=GPS_angleV * pi/180; %degree to radian
    
%% from Equatorial coordinates to Greenwich
gamma = mod((0.25+72/(73*1440))*t,360);
gamma = gamma*pi/180;  %degree to radian
A = [cos(gamma), -sin(gamma), 0;  sin(gamma), cos(gamma), 0; 0, 0, 1;];
%object=A*object;

%% TRANZIT satellites
for i=1:length(TR_tau)
    u=TR_angleV * (t - TR_tau(i));
   GrCoord = A' * TR_R * [cos(u)*cos(TR_omega(i))-sin(TR_omega(i))*cos(TR_i)*sin(u); 
        sin(TR_omega(i))*cos(u)+cos(TR_omega(i))*cos(TR_i)*sin(u);
        sin(TR_i)*sin(u);]; %from Osculating coordinates to Greenwich
 
dif=GrCoord-object; %vector from object to satellite

if dot(object,dif)>0 %visibility condition (dot - is scalar product)
    s = ['TRANZIT satellite ', num2str(i) ,' is in object visibility range.'];
    disp(s)
end
end

%% GPS satellites

for i=1:length(GPS_tau)
    u=GPS_angleV * (t - GPS_tau(i));
   GrCoord = A' * GPS_R * [cos(u)*cos(GPS_omega(i))-sin(GPS_omega(i))*cos(GPS_i)*sin(u); 
        sin(GPS_omega(i))*cos(u)+cos(GPS_omega(i))*cos(GPS_i)*sin(u);
        sin(GPS_i)*sin(u);];%from Osculating coordinates to Greenwich
   
dif=GrCoord-object; %vector from object to satellite

if dot(object,dif)>0   %visibility condition (dot - is scalar product)
    s = ['GPS satellite ', num2str(i) ,' is in object visibility range.'];
    disp(s)
end
end





