C1 = [2,1;1,2];
C2 = [1.5,0;0,1.5];
m1 = [0;2];
m2 = [1.7;2.5];

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
figure(1),clf,
contour(xRange, yRange, P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on;
plot(m1(1),m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
plot(m2(1),m2(2), 'r*', 'LineWidth', 4);

N = 200;
X1 = mvnrnd(m1, C1, N);
X2 = mvnrnd(m2, C2, N);
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;hold on;
syms x y
f = [x-m1(1),y-m1(2)]*inv(C1)*[x-m1(1),y-m1(2)]'-[x-m2(1),y-m2(2)]*inv(C2)*[x-m2(1),y-m2(2)]';
h = ezplot(f, [-6 6] , [-6 6]);
axis([-6 5.5 -6 5.4]);
set(h,'Color','k','LineWidth',2);

% [xx,yy]=meshgrid(xRange,yRange);
% figure(2),clf,
% surf(xx,yy,P1);hold on;
% surf(xx,yy,P2);