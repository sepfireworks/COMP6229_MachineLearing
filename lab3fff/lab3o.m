% figure(7),clf
clear all;

m1 = [0 2]';
m2 = [1.7 2.5]';


C1 = [2 1; 1 2];
C2 = C1;


w = inv(C1)*(m1-m2);
w0 = 0.5*(m2'*inv(C2)*m2 - m1'*inv(C1)*m1 );

x1 = -10:0.1:10;
x2 = -10:0.1:10;
[a,b] = size(x1);


for i = 1:b
    for j = 1:b
        X(1,1) = x1(1,i); 
        X(2,1) = x2(1,j);
        Y(j,i) = 1 / (1+ exp (-1 * (w' * X + w0)));
    end
end
%------
figure(1);
hold on;
W = 2*inv(C1)*(m2-m1);
B = (m1' * inv(C1) * m1 - m2' * inv(C1) *m2);
u = x1;
v = -(W(1)/W(2))*u-(B/W(2));
plot(u,v,'k','LineWidth',2);
grid on;
%------
surf(x1,x2,Y);    %
axis([-10 10 -10 10]);


w = inv(C2)*(m2-m1);
w0 = 0.5*  (m1'*inv(C1)*m1 - m2'*inv(C2)*m2 );

x1 = -10:0.1:10;
x2 = -10:0.1:10;
[a,b] = size(x1);


for i = 1:b
    for j = 1:b
        X(1,1) = x1(1,i); 
        X(2,1) = x2(1,j);
        Y(j,i) = 1 / (1+ exp (-1 * (w' * X + w0)));
    end
end

hold on;
W = inv(C1)*(m2-m1);
B = 0.5*(m1' * inv(C1) * m1 - m2' * inv(C1) *m2);
% u = x1;
% v = -(W(1)/W(2))*u-(B/W(2));
% plot(u,v,'k','LineWidth',2);
% grid on;
% surf(x1,x2,Y);  %
% hold on;

xxs = -2:0.1:2;
Zs = 0.02:0.01:1;
[xs,ZS]=meshgrid(xxs,Zs);
ys = xs*(-(W(1)/W(2))) -(B/W(2));
% ys = xs*(-1)*wF(1)/wF(2) + wF(1)*wF(1)/wF(2)*Threshold + wF(2)*Threshold;
surf(xs,ys,ZS);
colormap winter;shading interp;