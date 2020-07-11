clear variables;
clc;

%% Data(var_5)

fi = 0.8;
lmb = -4.0;
fi=fi * pi/180; %deg to rad
lmb=lmb * pi/180; %deg to rad

fi1 = 6;
lmb1 = 60;
az1=-84.494;
fi1=fi1 * pi/180; %deg to rad
lmb1=lmb1 * pi/180; %deg to rad
cotA1 = cot(az1 * pi/180); 

fi2 = -2;
lmb2 = 50;
az2=85.1435;
fi2=fi2 * pi/180; %deg to rad
lmb2=lmb2 * pi/180; %deg to rad
cotA2 = cot(az2 * pi/180);

%% Calculation

qi  = [fi; lmb];
qs1 = [fi1; lmb1];
qs2 = [fi2; lmb2];
d = [cotA1; cotA2];

for i = 1:3
   
    cotA1 = tan(qs1(1))*cos(qi(1))/sin(qi(2)-qs1(2))-sin(qi(1))*cot(qi(2)-qs1(2));
    cotA2 = tan(qs2(1))*cos(qi(1))/sin(qi(2)-qs2(2))-sin(qi(1))*cot(qi(2)-qs2(2));
    dcot = [cotA1; cotA2];
    dif = d - dcot;
    
    dcotA_dfi = -tan(qs1(1))*sin(qi(1))/sin(qi(2)-qs1(2))-cos(qi(1))*cot(qi(2)-qs1(2));
    dcotA_dlmb = (sin(qi(1))-tan(qs1(1))*cos(qi(1))*cos(qi(2)-qs1(2)))/sin(qi(2)-qs1(2))/sin(qi(2)-qs1(2));
    
    vec_C_1 = [dcotA_dfi;  dcotA_dlmb];
    
    dcotA_dfi = -tan(qs2(1))*sin(qi(1))/sin(qi(2)-qs2(2))-cos(qi(1))*cot(qi(2)-qs2(2));
    dcotA_dlmb = (sin(qi(1))-tan(qs2(1))*cos(qi(1))*cos(qi(2)-qs2(2)))/sin(qi(2)-qs2(2))/sin(qi(2)-qs2(2));
    
    vec_C_2 = [dcotA_dfi; dcotA_dlmb];
    C = [vec_C_1'; vec_C_2'];
   
    qi = qi + C\dif;
    qi*180/pi %radian to degree
end















