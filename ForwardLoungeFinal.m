clc
clear all
global l_shoulder l_hip l_elbow l_arm l_thigh l_leg l_body p_actual

(* Defining the points from the Frames
P0 : Neck
P1 : Right Shoulder
P2 : Right Elbow
P3 : Right Wrist
P4 : Left Shoulder
P5 : Left Elbow
P6 : Left Wrist
P7 : Right Hip
P8 : Right Knee
P9 : Right Ankle
P10 : Left Hip
P11 : Left Knee
P12 : Left Ankle *)

p0 = [ 938  896  938  941  938 ;
       1083  832  1083  838  1083 ;
       (1084-387)  (1084-567)  (1084-387)  (1084-560)  (1084-387)];

p1 = [ 846  795  846  831  846 ;
       1083  832  1083  838  1083 ;
       (1084-387)  (1084-567)  (1084-387)  (1084-560)  (1084-387)];

p2 = [ 798  758  798  778  798 ;
       1174  903  1174  910  1174 ;
       (1084-477)  (1084-649)  (1084-477)  (1084-663)  (1084-477)];

p3 = [ 859  829  859  858  859 ;
       1102  851  1102  838  1102 ;
       (1084-567)  (1084-742)  (1084-567)  (1084-733)  (1084-567)];

p4 = [ 1034  1009  1034  1051  1034 ;
       1083  832  1083  838  1083 ;
       (1084-387)  (1084-567)  (1084-387)  (1084-559)  (1084-387)];

p5 = [ 1070  1057  1070  1078  1070 ;
       1174  904  1174  910  1174 ;
       (1084-477)  (1084-648)  (1084-477)  (1084-660)  (1084-477)];

p6 = [ 1004  1001  1004  1036  1004 ;
       1102  850  1102  837  1102 ;
       (1084-567)  (1084-742)  (1084-567)  (1084-736)  (1084-567)];

p7 = [ 886  868  886  882  886 ;
       1109  851  1109  861  1109 ;
       (1084-646)  (1084-778)  (1084-646)  (1084-788)  (1084-646)];

p8 = [ 890  877  890  894  890 ;
       1112  712  1112  935  1112 ;
       (1084-761)  (1084-781)  (1084-761)  (1084-911)  (1084-761)];

p9 = [ 893  885  893  894  893 ;
       1125  795  1125  1102  1125 ;
       (1084-946)  (1084-921)  (1084-946)  (1084-912)  (1084-946)];

p10 = [ 979  961  979  989  979 ;
       1107  850  1107  859  1107 ;
       (1084-644)  (1084-778)  (1084-644)  (1084-787)  (1084-644)];

p11 = [ 977  971  977  965  977 ;
       1113  931  1113  698  1113 ;
       (1084-760)  (1084-930)  (1084-760)  (1084-789)  (1084-760)];

p12 = [ 971  971  971  956  971 ;
       1123  1102  1123  757  1123 ;
       (1084-946)  (1084-931)  (1084-946)  (1084-951)  (1084-946)];


(* Using the Measured Points to map to the Humanoid *)
thz = zeros(23,4);

for i=1:5
    l_shoulder = norm( p1(:,i)-p4(:,i) )/2;
    l_hip = norm( p7(:,i)-p10(:,i) )/2;
    l_elbow = norm( p1(:,i)-p2(:,i) );
    l_arm = norm( p2(:,i)-p3(:,i) );
    l_thigh = norm( p7(:,i)-p8(:,i) );
    l_leg = norm( p8(:,i)-p9(:,i) );
    l_body = norm( p0(2:3,i)-p10(2:3,i) );

    p_actual = [p0(:,i) p1(:,i) p2(:,i) p3(:,i) p4(:,i) p5(:,i) p6(:,i) p7(:,i) p8(:,i) p9(:,i) p10(:,i) p11(:,i) p12(:,i)];
    
    x0 = [0 0 0, 0, 0 0 0, 0, 0 0 0, 0, 0 0 0, 0, 0 0 0, 0, p0(:,i)']';

    thz(:,i) = lsqnonlin(@human2, x0);
    
end


(* Animation *)
N1 = 50;

for i = 2:1:5
    for j=1:N1
        clf;
        human1(thz(:,i-1)*(N1-j)/N1 + thz(:,i)*j/N1);
        campos([2000 2000 2000]);
        xlim([0 1500]); ylim([500 2500]); zlim([-500 1000]);
        view(38, 22);
        pause(0.02);
        
    end
end


(* Humanoid Function *)
function out1 = human2(thz)

global l_shoulder l_hip l_elbow l_arm l_thigh l_leg l_body p_actual

p0 = thz(21:23);

p1 = [0; -l_shoulder; 0];
p2 = [l_elbow; 0; 0];
p3 = [l_arm; 0; 0];

p4 = [0; l_shoulder; 0];
p5 = [l_elbow; 0; 0];
p6 = [l_arm; 0; 0];

p7 = [0; -l_hip; -l_body];
p8 = [l_thigh; 0; 0];
p9 = [l_leg; 0; 0];

p10 = [0; l_hip; -l_body];
p11 = [l_thigh; 0; 0];
p12 = [l_leg; 0; 0];


R_th1 = rotZ(thz(1))*rotY(thz(2))*rotX(thz(3));

p1_i = R_th1*p1 + p0;
p4_i = R_th1*p4 + p0;
p7_i = R_th1*p7 + p0;
p10_i = R_th1*p10 + p0;

R_th3 = rotZ(thz(5))*rotY(thz(6))*rotX(thz(7));
R_th4 = rotY(thz(8));
p2_i = R_th1*R_th3*p2 +p1_i;
p3_i = R_th1*R_th3*R_th4*p3 + p2_i;
R_th5 = rotZ(thz(9))*rotY(thz(10))*rotX(thz(11));
R_th6 = rotY(thz(12));
p5_i = R_th1*R_th5*p5 +p4_i;
p6_i = R_th1*R_th5*R_th6*p6 + p5_i;

R_th7 = rotZ(thz(13))*rotY(thz(14))*rotX(thz(15));
R_th8 = rotY(thz(16));
p8_i = R_th1*R_th7*p8 + p7_i;
p9_i = R_th1*R_th7*R_th8*p9 + p8_i;
R_th9 = rotZ(thz(17))*rotY(thz(18))*rotX(thz(19));
R_th10 = rotY(thz(20));
p11_i = R_th1*R_th9*p11 + p10_i;
p12_i = R_th1*R_th9*R_th10*p12 + p11_i;
%%
z0 = [p0 p1_i p2_i p3_i p4_i p5_i p6_i p7_i p8_i p9_i p10_i p11_i p12_i];

out1 = sum((z0-p_actual).^2,'all');

end



function [x,y,z] = point4plot(pa,pb)
vert1 = [pa,pb];
x = vert1(1,:);
y = vert1(2,:);
z = vert1(3,:);
end



function R1 = rotZ(theta)
R1 = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
end



function R1 = rotY(theta)
R1 = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
end



function R1 = rotX(theta)
R1 = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
end


function human1(thz)

global l_shoulder l_hip l_elbow l_arm l_thigh l_leg l_body 

p0 = thz(21:23);

p1 = [0; -l_shoulder; 0];     % right shoulder
p2 = [l_elbow; 0; 0];         % right elbow link
p3 = [l_arm; 0; 0];           % right arm link

p4 = [0; l_shoulder; 0];
p5 = [l_elbow; 0; 0];
p6 = [l_arm; 0; 0];

p7 = [0; -l_hip; -l_body];
p8 = [l_thigh; 0; 0];
p9 = [l_leg; 0; 0];

p10 = [0; l_hip; -l_body];
p11 = [l_thigh; 0; 0];
p12 = [l_leg; 0; 0];

R_th1 = rotZ(thz(1))*rotY(thz(2))*rotX(thz(3));

p1_i = R_th1*p1 + p0;
p4_i = R_th1*p4 + p0;
p7_i = R_th1*p7 + p0;
p10_i = R_th1*p10 + p0;

R_th3 = rotZ(thz(5))*rotY(thz(6))*rotX(thz(7));
R_th4 = rotY(thz(8));
p2_i = R_th1*R_th3*p2 +p1_i;
p3_i = R_th1*R_th3*R_th4*p3 + p2_i;
R_th5 = rotZ(thz(9))*rotY(thz(10))*rotX(thz(11));
R_th6 = rotY(thz(12));
p5_i = R_th1*R_th5*p5 +p4_i;
p6_i = R_th1*R_th5*R_th6*p6 + p5_i;

R_th7 = rotZ(thz(13))*rotY(thz(14))*rotX(thz(15));
R_th8 = rotY(thz(16));
p8_i = R_th1*R_th7*p8 + p7_i;
p9_i = R_th1*R_th7*R_th8*p9 + p8_i;
R_th9 = rotZ(thz(17))*rotY(thz(18))*rotX(thz(19));
R_th10 = rotY(thz(20));
p11_i = R_th1*R_th9*p11 + p10_i;
p12_i = R_th1*R_th9*R_th10*p12 + p11_i;

w1 = 3;

%torso
vert1 = [p1_i p4_i p7_i p10_i p1_i];
x = vert1(1,:);
y = vert1(2,:);
z = vert1(3,:);
patch(x,y,z,'b'); axis equal; hold on;

%right arm1
[x,y,z] = point4plot(p1_i,p2_i);
plot3(x,y,z,'r','LineWidth',w1);
%right arm2
[x,y,z] = point4plot(p3_i,p2_i);
plot3(x,y,z,'g','LineWidth',w1);
%left arm1
[x,y,z] = point4plot(p4_i,p5_i);
plot3(x,y,z,'r','LineWidth',w1);
%left arm2
[x,y,z] = point4plot(p6_i,p5_i);
plot3(x,y,z,'g','LineWidth',w1);
%right thigh
[x,y,z] = point4plot(p7_i,p8_i);
plot3(x,y,z,'r','LineWidth',w1);
%right leg
[x,y,z] = point4plot(p9_i,p8_i);
plot3(x,y,z,'g','LineWidth',w1);
%left thigh
[x,y,z] = point4plot(p10_i,p11_i);
plot3(x,y,z,'r','LineWidth',w1);
%left leg
[x,y,z] = point4plot(p12_i,p11_i);
plot3(x,y,z,'g','LineWidth',w1);
end
