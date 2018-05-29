C1 = [2,1;1,2];
C2 = [1,0;0,1];
m1 = [0;3];
m2 = [2;1];

numGrid = 50;
xRange = linspace(-6.0, 6.0, numGrid);
yRange = linspace(-6.0, 6.0, numGrid);
P1 = zeros(numGrid, numGrid);
P2 = P1;
for i = 1:numGrid
    for j = 1:numGrid
        x = [yRange(j) xRange(i)]';
        P1(i,j) = mvnpdf(x', m1', C1);
        P2(i,j) = mvnpdf(x', m2', C2);
    end
end
Pmax = max(max([P1 P2]));
N1 = 100; N2 = 100;
X1 = mvnrnd(m1, C1, N1);
X2 = mvnrnd(m2, C2, N2);

figure(1),clf
plot(X1(:,1),X1(:,2),'ko',X2(:,1),X2(:,2),'ro','LineWidth', 2);grid on;hold on;

contour(xRange, yRange, P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on;
plot(m1(1),m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
plot(m2(1),m2(2), 'r*', 'LineWidth', 4);



syms x y
f = [x-m1(1),y-m1(2)]*inv(C1)*[x-m1(1),y-m1(2)]'-[x-m2(1),y-m2(2)]*inv(C2)*[x-m2(1),y-m2(2)]';
h = ezplot(f, [-6 6] , [-6 6]);
axis([-6 5.5 -6 5.4]);
set(h,'Color','k','LineWidth',2);

% %bayes
% wb = 2*inv(C1)*(m2-m1);
% % bb = m1'*inv(C1)*m1 - m2'*inv(C1)*m2;
% bb = (-1)*(m1'*inv(C1)*m1 - m2'*inv(C1)*m2)/wb(2);
% % bb = (-1)*(m1'*inv(C1)*m1 - m2'*inv(C1)*m2);
% kb = (-1)*wb(1)/wb(2);
% 
% 
% xb=linspace(-6,6,20);
% yb = xb*kb + bb;
% figure(1),
% plot(xb,yb,'m','LineWidth', 2); 
% 
% w0 = m1'*inv(C1)*m1 - m2'*inv(C1)*m2;


%  draw Bayes boundary

PP1 = zeros(N1,N1);PP2 = zeros(N2,N2);
%xB=linspace(-6,6,N1);yB=linspace(-6,6,N1);
xB=linspace(-6,6,N1);yB=linspace(-6,6,N1);
for i = 1:N1
    for j = 1:N1
        G1 = ([xB(j);yB(i)]-m1)'*inv(C1)*([xB(j);yB(i)]-m1);
        G2 = ([xB(j);yB(i)]-m2)'*inv(C2)*([xB(j);yB(i)]-m2);
        PP1(i,j) = 1/(1 + (det(C1)/det(C2))^(1/2)*exp(1/2*(G1-G2)));
        %PP1(i,j) = 1/(1 + (det(C2)/det(C1))^(1/2)*exp(1/2*(G2-G1)));
    end
end
[XB1,YB1]=meshgrid(xB,yB);

for i = 1:N2
    for j = 1:N2
        G1 = ([xB(j);yB(i)]-m1)'*inv(C1)*([xB(j);yB(i)]-m1);
        G2 = ([xB(j);yB(i)]-m2)'*inv(C2)*([xB(j);yB(i)]-m2);
        PP2(i,j) = 1/(1 + (det(C2)/det(C1))^(1/2)*exp(1/2*(G2-G1)));
        %PP2(i,j) = 1/(1 + (det(C1)/det(C2))^(1/2)*exp(1/2*(G1-G2)));
    end
end
[XB2,YB2]=meshgrid(xB,yB);

surf(XB1,YB1,PP1);hold on;
surf(XB2,YB2,PP2);hold on;
colormap winter;shading interp;







