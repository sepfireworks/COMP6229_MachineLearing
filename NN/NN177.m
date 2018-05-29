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
u = 100;TIMES = 100;
acc_nn = zeros(TIMES,1);
avg_acc = zeros(u-1,1);
X = [X1;X2];
y1 = ones(N1,1);
y2 = (-1)*ones(N2,1);
y = [y1;y2];
for i = 2:u
    for tis = 1:TIMES
        [net] = feedforwardnet(i);
        [net] = train(net, X', y');
        [output] = net(X');
        tpos_nn = 0;tneg_nn = 0;
        for j = 1:N1
            if output(j)>0
                tpos_nn = tpos_nn + 1;
            end
        end
        for j = 1:N2
            if output(j+N1)<0
                tneg_nn = tneg_nn + 1;
            end
        end
        acc_nn(tis) = (tpos_nn + tneg_nn)/(N1 + N2);
    end
    avg_acc(i-1) = sum(acc_nn)/TIMES;
end
uii = 2:1:u;
figure(3),clf,
plot(uii,avg_acc,'b','LineWidth',2);