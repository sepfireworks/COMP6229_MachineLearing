N = 100;
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
ii = randperm(N);

XS1 = [X1 ones(N,1)];
XS2 = [X2 ones(N,1)];
Xtrn1 = ones(N/2,3);
ytrn1 = ones(N/2,1);
Xtrn2 = ones(N/2,3);
ytrn2 = ones(N/2,1);

for j = 1: N/2
    Xtrn1(j) = XS1(ii(j));
end

% Xtrn1 = XS1(ii(1:N/2),:);
% ytrn1 = ones(N/2,1);
% 
% Xtrn2 = XS2(ii(1:N/2),:);
% ytrn2 = (-1)*ones(N/2,1);

for j = 1: N/2
    Xtrn2(j) = XS2(ii(j));
end

eta = 0.001;
for iter = 1 : 1000
    j = ceil(rand*N/2);
    if (ytrn1(j)*Xtrn1(j,:)*wd>0)
        wd = wd +eta*ytrn1(j)*Xtrn1(j,:)';
    end
    if (ytrn2(j)*Xtrn2(j,:)*wd>0)
        wd = wd +eta*ytrn2(j)*Xtrn2(j,:)';
    end
end


Xtst1 = ones(N/2,3);
ytst1 = ones(N/2,1);
Xtst2 = ones(N/2,3);
ytst2 = ones(N/2,1);

for j = N/2+1 : N
    Xtst1(j) = XS1(ii(j));
end

for j = N/2+1 : N
    Xtst2(j) = XS2(ii(j));
end


% yhts1=Xtst1*wd;
% yhts2=Xtst2*wd;
% 
% pe = (length(find(ytst1.*yhts1>0)) + length(find(ytst2.*yhts2>0)))/(N)*100;
% 
% 
% disp(pe)
% 
wp = 0;

for j = 1 : N/2
    if (ytst1(j)*Xtst1(j,:)*wd>0)
        wp = wp + 1;
    end
    if (ytst2(j)*Xtst2(j,:)*wd>0)
        wp = wp + 1;
    end
end


disp(wp)

xs = linspace(-6,6,20);
ys = (-1)*(wd(1)/wd(2))*xs - wd(3);

%plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o', x, y, 'r', xs, ys, 'k', 'LineWidth', 2);
plot(XS1(:,1),XS1(:,2),'mx',XS2(:,1),XS2(:,2),'o', x, y, 'r', xs, ys, 'k', 'LineWidth', 2);

