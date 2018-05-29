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
%X1 = X + kron(ones(N,1),m1);
%X2 = X + kron(ones(N,1),m2);
X1 = Xn + kron(ones(N,1),m1);
X2 = Xn + kron(ones(N,1),m2);
var_x1 = var(X1);
M1 = (mean(X1))';
var_x2 = var(X2);
M2 = (mean(X2))';
%plot(X(:,1),X(:,2),'c.',X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o');
%plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o');

X11 = [X1 ones(N,1)];
%plot(X1(:,1),X1(:,2),'mx',X11(:,1),X11(:,2),'o');

ii = randperm(N);
Xtr = X1(ii(1:N/2),:);
ytr = X1(ii(1:N/2),:);
Xts = X1(ii(N/2+1:N),:);
yts = X1(ii(N/2+1:N),:);

%plot(X1(:,1),X1(:,2),'mx',Xtr(:,1),Xtr(:,2),'o',ytr(:,1),ytr(:,2),'d');
%plot(X1(:,1),X1(:,2),'mx',Xtr(:,1),Xtr(:,2),'o',Xts(:,1),Xts(:,2),'d');

%w = randn(3,1);

w = 2*inv(C)*(m2-m1)';

b = m1*inv(C)*m1' - m2*inv(C)*m2';

k = -b/(w(1)/w(2));

x=linspace(-6,6,20);
y = k*x - b;

%plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o', x, y, 'r', 'LineWidth', 2);
%axis([-5 5 -5 5]); grid on;

wd = randn(3,1);

XS1 = [X1 ones(N,1)];
XS2 = [X2 ones(N,1)];

NN = N;

ii = randperm(NN);

Xtrn1 = XS1(ii(1:NN/4),:);
Xtrn2 = XS2(ii(NN/4+1:NN/2),:);

%ytrn1 = ones(N/2,1);

Xtst1 = XS1(ii(NN/2+1:NN*3/4),:);
Xtst2 = XS2(ii(NN*3/4+1:NN),:);

wd = randn(3,1);


eta = 0.000001;
for j = 1 : N/4
    if (Xtrn1(j,:)*wd >0)
        wd = wd + eta*Xtrn1(j,:)';
    end
end

for j = 1 : N/4
    if (Xtrn2(j,:)*wd <0)
        wd = wd + eta*Xtrn2(j,:)';
    end
end

wp = 0;

for j = 1 : N/4
    if (Xtst1(j,:)*wd >0)
        wp = wp + 1;
    end
end

for j = 1 : N/4
    if (Xtst2(j,:)*wd <0)
        wp = wp + 1;
    end
end
wpo = 0;
for j = 1 : N
    if (X2(j,1)*k + b) <X2(j,2) || (X1(j,1)*k + b) >X1(j,2)
        wpo = wpo + 1;
    end
end
xs=linspace(-6,6,20);
ys = (-1)*(wd(1)/wd(2))*xs - wd(3);

PE = 100*(wpo/N);
PercentageError = 100*(wp/N);

disp('original, training');
disp([PE,PercentageError]);

%plot(xs, ys, 'k', 'LineWidth', 2);

%plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o', x, y, 'r', xs, ys, 'k', 'LineWidth', 2);
plot(Xtst1(:,1),Xtst1(:,2),'mx',Xtst2(:,1),Xtst2(:,2),'o', x, y, 'r', xs, ys, 'k', 'LineWidth', 2);

%j = ceil(rand*N/4);
%for iter = 1 : N/4
    %j(iter) = ceil(rand*N/4);
    %disp(j)
%end

%io = linspace(0,250,250);

%plot(io,j);