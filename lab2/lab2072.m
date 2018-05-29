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
eta = 0.00001;
pe =  ones(5000,1);
Nt = ones(5000,1);
ll = 9999;
wm = rand(3,1);
for j = 1:5000
    Nt(j) = j;
end
for NN = 1:5000
    wd = randn(3,1);
    ii = randperm(N);

    XS1 = [X1 ones(N,1)];
    XS2 = [X2 ones(N,1)];
    Xtrn = ones(N,3);
    ytrn = ones(N,1);

    for j = 1: N/2
        Xtrn(j,:) = XS1(ii(j),:);
    end

    for j = 1 : N/2
        Xtrn(N/2 + j,:) = XS2(ii(j),:);
    end

    for j = 1 : N/2
        ytrn(j) = -1;
    end


    for iter = 1 : NN
        j = ceil(rand*N);
        if (ytrn(j)*Xtrn(j,:)*wd<0)
            wd = wd +eta*ytrn(j)*Xtrn(j,:)';
        end
    end

    Xtst = ones(N,3);

    for j = 1 : N/2
        Xtst(j,:) = XS1(ii(j+N/2),:);
    end

    for j = 1 : N/2
        Xtst(N/2+j,:) = XS2(ii(j+N/2),:);
    end

    ytst = ones(N,1);
    for j = 1 : N/2
        ytst(j) = -1;
    end

    MMM = ytst.*(Xtst*wd);
    wp = 0;
    for j = 1:N
        if MMM(j)<0
            wp = wp + 1;
        end
    end
    pe(NN) = 100*wp/N;
    if pe(NN)<ll
        wm(1) = wd(1);wm(2) = wd(2);wm(3) = wd(3);
        ll=pe(NN);
    end
end
avg = mean(pe);disp(avg);
subplot(1,2,1);plot(Nt,pe,'k', 'LineWidth', 1);
xs = linspace(-6,6,20);
ys = (-1)*(wm(1)/wm(2))*xs - wm(3);
subplot(1,2,2);plot(X1(:,1),X1(:,2),'mx',X2(:,1),X2(:,2),'o', x, y, 'r', xs, ys, 'k', 'LineWidth', 2);
