C1 = [2,1;1,2];
C2 = [2,1;1,2];
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
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;

wF = inv(C1+C2)*(m1-m2);
xx = -6:0.1:6;
yy = xx*wF(2)/wF(1);

wr = zeros(2,1);
wr(1) = rand(1)*2 - 1;wr(2) = rand(1)*2 - 1;
xr = -6:0.1:6;
yr = xr*wr(2)/wr(1);

wC = zeros(2,1);
wC(1) = m1(1)-m2(1); wC(2) = m1(2)-m2(2);
xc = -6:0.1:6;
yc = xc*wC(2)/wC(1);

plot(xx,yy,'r',xr,yr,'b', xc,yc,'g','LineWidth', 2);
rocResolution = 50;

[ROC, acc, thRange] = lab3f1(N,X1,X2,wF,rocResolution);
[ROCr, accr] = lab3f1(N,X1,X2,wr,rocResolution);
[ROCC, accC] = lab3f1(N,X1,X2,wC,rocResolution);

figure(3), clf,
plot(ROC(:,1), ROC(:,2), 'r', 'LineWidth', 2);
axis([0 100 0 100]);
grid on, hold on
plot(0:100, 0:100, 'b-');
grid on, hold on
plot(ROCr(:,1), ROCr(:,2), 'b', 'LineWidth', 2);
grid on, hold on
plot(ROCC(:,1), ROCC(:,2), 'g', 'LineWidth', 2);
xlabel('False Positive', 'FontSize', 16);
ylabel('True Positive', 'FontSize', 16);
title('Receiver Operating Characteristic Curve', 'FontSize', 20);


ax = linspace(1,rocResolution,rocResolution);
figure(4), clf,
plot(ax, acc, 'r', 'LineWidth', 2);
grid on, hold on
plot(ax, accr, 'b', 'LineWidth', 2);
grid on, hold on
plot(ax, accC, 'g', 'LineWidth', 2);
xlabel('Threshold', 'FontSize', 16);
ylabel('ACC', 'FontSize', 16);
title('ACC in 3 models', 'FontSize', 20);

auc = abs(trapz(ROC(:,1),ROC(:,2))/10000);
aucr = abs(trapz(ROCr(:,1),ROCr(:,2))/10000);
aucC = abs(trapz(ROCC(:,1),ROCC(:,2))/10000);
disp([auc aucr aucC]);
% knn
X = [X1;X2];
N1 = size(X1,1);
N2 = size(X2,1);
y = [ones(N1,1); -1*ones(N2,1)];
d = zeros(N1+N2-1,1);
nCorrect = 0;
k = 7;
for jtst = 1:(N1+N2)
    xtst = X(jtst,:);
    ytst = y(jtst);
    
    jtrn = setdiff(1:N1+N2, jtst);
    Xtrn = X(jtrn,:);
    ytrn = y(jtrn,1);
    x1max = max(Xtrn(:,1));
    x2max = max(Xtrn(:,2));
    x1min = min(Xtrn(:,1));
    x2min = min(Xtrn(:,2));
    
    for i = 1:(N1+N2-1)
        d(i) = (((Xtrn(i,1)-xtst(1))/(x1max-x1min))^2+((Xtrn(i,2)-xtst(2))/(x2max-x2min))^2)^(1/2);
    end
    dc = sort(d);
    i = 0;
    j = 0;
    p = 0; ne = 0;
    while (i<k)
        for j = 1 : (N1+N2)
            if (dc(i+1) == d(j))
                if (y(j)>0)
                    p = p + 1; i = i + 1;break;
                elseif y(j)<0
                    ne = ne + 1; i = i + 1;break;
                end
            end
        end
    end
    if p>ne
        ytrm = 1;
    else
        ytrm = -1;
    end
    
    if(ytrm*ytst>0)
        nCorrect = nCorrect + 1;
    end
end

pCorrect = nCorrect*100/(N1+N2);
%1 1NN
N1 = size(X1,1);
N2 = size(X2,1);
y = [ones(N1,1); -1*ones(N2,1)];
d = zeros(N1+N2-1,1);
nCorrect1 = 0;
for jtst = 1:(N1+N2)
    xtst = X(jtst,:);
    ytst = y(jtst);
    
    jtr = setdiff(1:N1+N2, jtst);
    Xtr = X(jtr,:);
    ytr = y(jtr,1);
    
    for i = 1:(N1+N2-1)
        d(i) = norm(Xtr(i,:)-xtst);
    end
    
    [imin] = find(d == min(d));
    
    if(ytr(imin(1))*ytst>0)
        nCorrect1 = nCorrect1 + 1;
    end
end

pCorrect1 = nCorrect1*100/(N1+N2);

%me k-mean
s1 = zeros(1,2); s2 = zeros(1,2);
s1(1) = (rand(1)*2 - 1);s1(2) = (rand(1)*2 - 1)+2;
s2(1) = 0.25*(rand(1)*2 - 1)+1.75;s2(2) = 0.5*(rand(1)*2 - 1)+2.5;

% s1(1) = 0.5*(rand(1)*2 - 1);s1(2) = 2+0.5*(rand(1)*2 - 1);
% s2(1) = 1.7+0.5*(rand(1)*2 - 1);s2(2) = 2.5+0.5*(rand(1)*2 - 1);

se1 = s1; se2 = s2;
XE1 = zeros(N1+N2,2);XE2 = zeros(N1+N2,2);
ye = [ones(N1,1); -1*ones(N2,1)];
i1 = 1; i2 = 1;
opop = 0;
ea = 0.0001;
nCorrectme = 0;
De1 = 0; De2 = 0;
while opop<5000
    Dep1 = De1; Dep2 = De2;
    De1 = 0; De2 = 0;
    for j = 1:N1+N2
        de1 = norm(X(j,:)-se1);
        de2 = norm(X(j,:)-se2);
        if de1<de2
            XE1(i1,:) = X(j,:); De1 = De1 + de1; i1 = i1 + 1;ye(j) = 1;
        else
            XE2(i2,:) = X(j,:); De2 = De2 + de2; i2 = i2 + 1;ye(j) = -1;
        end
    end
    NE1 = i1; NE2 = i2;
    sep1 = se1; sep2 = se2;
    se1(1) = sum(XE1(1:i1,1))/i1;se1(2) = sum(XE1(1:i1,2))/i1;
    se2(1) = sum(XE2(1:i2,1))/i2;se2(2) = sum(XE2(1:i2,2))/i2;
%     disp([sep1 sep2]);
    klj1 = De1-Dep1;klj2 = De2-Dep2;
%     disp([klj1 klj2]);
%     disp([De1 De2]);
%     if(abs(sep1(1)-se1(1))<ea)&&(abs(sep1(2)-se1(2))<ea)
%         if(abs(sep2(1)-se2(1))<ea)&&(abs(sep2(2)-se2(2))<ea)
%             break;
%         end
%     end
    i1 = 1; i2 = 1;
    XE1 = zeros(N1+N2,2);XE2 = zeros(N1+N2,2);
    opop = opop+1;
end
for j = 1:N1+N2
    if ye(j)*y(j)>0
        nCorrectme = nCorrectme+1;
    end
end
pCorrectme = nCorrectme*100/(N1+N2);

%mm mahal
y = [ones(N1,1); -1*ones(N2,1)];
ym = [ones(N1,1); -1*ones(N2,1)];
nCorrectmm = 0;
for jtst = 1:(N1+N2)
    xtst = X(jtst,:);
    ytst = y(jtst);
    
    for i = 1:(N1+N2-1)
        dm1 = mahal(xtst,X1);
        dm2 = mahal(xtst,X2);
        if dm1<dm2
            ym(i) = 1;
        else
            ym(i) = -1;
        end
    end
    
    if(ym(jtst)*ytst>0)
        nCorrectmm = nCorrectmm + 1;
    end
end

pCorrectmm = nCorrectmm*100/(N1+N2);

disp([ '   1NN','         mahal', '      kNN','      kmean', '      Fisher']);
disp([ pCorrect1 pCorrectmm pCorrect pCorrectme max(acc)]);
disp([se1 se2]);
disp([De1 De2]);
figure(1),
plot(se1, se2, 'k*');
disp(opop);

t = find(acc==max(acc));
Threshold = thRange(max(t));
xxx = -6:0.1:6;
yyy = xxx*(-1)*wF(1)/wF(2) + wF(1)*wF(1)/wF(2)*Threshold + wF(2)*Threshold;
figure(1),
plot(xxx,yyy,'k','LineWidth', 2);

xx3 = -2:0.1:2;
Z = 0:0.005:0.09;
[xx,yy]=meshgrid(xRange,yRange);
[x3,ZZ]=meshgrid(xx3,Z);
figure(2),clf,
surf(xx,yy,P1);hold on;
surf(xx,yy,P2);hold on;
y3 = x3*(-1)*wF(1)/wF(2) + wF(1)*wF(1)/wF(2)*Threshold + wF(2)*Threshold;
surf(x3,y3,ZZ);colormap winter;
shading interp;



