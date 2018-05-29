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

figure(1),clf,



plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;hold on;

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


% axis([-4 4 -4 4 0 1]);

xc=-1:0.01:5;
YYC = zeros(601,1);
YC = @(xc) fzero(@(yc) [xc-m1(1),yc-m1(2)]*inv(C1)*[xc-m1(1),yc-m1(2)]'-[xc-m2(1),yc-m2(2)]*inv(C2)*[xc-m2(1),yc-m2(2)]',1);
for i = 1:601
    YYC(i) = YC(-1+i*0.01);
end

figure(2),clf,
plot(xc,YYC);
axis([-6 5.5 -6 5.4]);grid on;hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tpos = 0;tneg = 0;fpos = 0;fneg = 0;

for i = 1:N1
    ii = round((X1(i,1)+1)/0.01);
    if (X1(i,1) > 5)
        fpos = fpos+1;
        continue;
    elseif (X1(i,1) < -0.5)
        tpos = tpos+1;
        continue;
    elseif X1(i,2)>YYC(ii)
        tpos = tpos + 1;
    else
        fpos = fpos+1;
    end
end
for i = 1:N2
    ii = round((X2(i,1)+1)/0.01);
    if (X2(i,1) > 5)
        tneg = tneg + 1;
        continue;
    elseif (X2(i,1) < -0.5)
        fneg = fneg + 1;
        continue;
    elseif X2(i,2)<YYC(ii)
        tneg = tneg + 1;
    else
        fneg = fneg + 1;
    end
end
acc_bys = (tpos + tneg)/(N1 + N2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = [X1;X2];
y1 = ones(N1,1);
y2 = (-1)*ones(N2,1);
y = [y1;y2];

[net1] = feedforwardnet(20);
[net1] = train(net1, X', y');
[output1] = net1(X');


class1 = zeros(N1,1);
class2 = zeros(N2,1);
tpos1 = 0;tneg1 = 0;
k = 1;
for i = 1:N1
    if output1(i)>0
        tpos1 = tpos1 + 1;
        class1(k) = i;k= k+1;
    end
end
k = 1;
for i = 1:N2
    if output1(i+N1)<0
        tneg1 = tneg1 + 1;
        class2(k) = i;k= k+1;
    end
end
class1(class1==0)=[]; 
class2(class2==0)=[];

class1s = zeros(length(class1),1);
class2s = zeros(length(class2),1);
xx = -4:0.1:6;
k = 1;ks = 0;
for i = 1:101
    mins = 99;
    for j = 1:length(class1)
        KKK = X1(class1(j),1);
        if (((i-1)*0.1-4)<KKK)&&((KKK)<((i*0.1-4)))
            if X1(class1(j),2)<mins
                mins = X1(class1(j),2);
                class1s(k) = class1(j);ks = 1;
            end
        end
    end
    if(ks ==1)
        k = k+1;ks=0;
    end
end
k = 1;ks = 0;s2 = 0;
for i = 1:101
    maxs = -99;
    for j = 1:length(class2)
        KKK = X2(class2(j),1);
        if (((i-1)*0.1-4)<KKK)&&((KKK)<((i*0.1-4)))
            if X2(class2(j),2)>maxs
                s2 = s2 + 1;
                maxs = X2(class2(j),2);
                class2s(k) = class2(j);ks = 1;
            end
        end
    end
    if(ks ==1)
        k = k+1;ks=0;
    end
end
class1s(class1s==0)=[]; 
class2s(class2s==0)=[];     
class1s = unique(class1s);
class2s = unique(class2s);
XaS1 = zeros(length(class1s),2);
for i = 1:length(class1s)
    XaS1(i,1) = X1(class1s(i),1);
    XaS1(i,2) = X1(class1s(i),2);
end
XaS2 = zeros(length(class2s),2);
for i = 1:length(class2s)
    XaS2(i,1) = X2(class2s(i),1);
    XaS2(i,2) = X2(class2s(i),2);
end
[a1,~] = size(XaS1);[a2,~] = size(XaS2);
XF1 = zeros(a1,2);XF2 = zeros(a2,2);
u1 = zeros(a1,1);u2 = zeros(a2,1);
ms = 0;
for i = 1:a1
    minf =100;minj = 1;
    for j = 1:a1
        for k = 1:i
            if j == u1(k)
                ms = 1;
                break;
            end
        end
        if ms == 1
            ms = 0;
            continue;
        end
        if minf>XaS1(j,1)
            minf = XaS1(j,1);
            minj = class1s(j);
            jx = j;
        end
    end
    XF1(i,1) = X1(minj,1);
    XF1(i,2) = X1(minj,2);
    u1(i) = jx;
end

ms = 0;
for i = 1:a2
    maxf =-100;maxj = 1;
    for j = 1:a2
        for k = 1:i
            if j == u2(k)
                ms = 1;
                break;
            end
        end
        if ms == 1
            ms = 0;
            continue;
        end
        if maxf<XaS2(j,1)
            maxf = XaS2(j,1);
            maxj = class2s(j);
            jx = j;
        end
    end
    XF2(i,1) = X2(maxj,1);
    XF2(i,2) = X2(maxj,2);
    u2(i) = jx;
end

% figure(1),
% plot(XF1(:,1),XF1(:,2),'m',XF2(:,1),XF2(:,2),'g','LineWidth',2);grid on;hold on;

figure(3),clf
plot(XaS1(:,1),XaS1(:,2),'md',XaS2(:,1),XaS2(:,2),'g+');grid on;hold on;
plot(XF1(:,1),XF1(:,2),'m',XF2(:,1),XF2(:,2),'g','LineWidth',2);grid on;hold on;
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;hold on;
axis([-6 5.5 -6 5.4]);grid on;hold on;

acc_nn1 = (tpos1 + tneg1)/(N1 + N2);

disp([acc_bys, acc_nn1]);