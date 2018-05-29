N = 10000;
X=randn(N,2);
var_x = var(X);
M = mean(X);
C = [2,1;1,2];
a = chol(C);
Xn =  X*a;
var_xn = var(Xn);
Mn = mean(Xn);
m1 = [0 2];
m2 = [1.5 0];
X1 = Xn + kron(ones(N,1),m1);
X2 = Xn + kron(ones(N,1),m2);
var_x1 = var(X1);
M1 = (mean(X1))';
var_x2 = var(X2);
M2 = (mean(X2))';
%plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o');

w = 2*inv(C)*(m2-m1)';

b = m1*inv(C)*m1' - m2*inv(C)*m2';

k = -b/(w(1)/w(2));

x=linspace(-6,6,20);

y = k*x - b;




plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o', x, y, 'r', 'LineWidth', 2);

