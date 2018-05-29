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

[net2] = feedforwardnet(40);
[net2] = train(net2, X', y');
[output2] = net2(X');

tpos1 = 0;tneg1 = 0;
for i = 1:N1
    if output1(i)>0
        tpos1 = tpos1 + 1;
    end
end
for i = 1:N2
    if output1(i+N1)<0
        tneg1 = tneg1 + 1;
    end
end
acc_nn1 = (tpos1 + tneg1)/(N1 + N2);

tpos2 = 0;tneg2 = 0;
for i = 1:N1
    if output2(i)>0
        tpos2 = tpos2 + 1;
    end
end
for i = 1:N2
    if output2(i+N1)<0
        tneg2 = tneg2 + 1;
    end
end
acc_nn2 = (tpos2 + tneg2)/(N1 + N2);

disp([acc_bys, acc_nn1, acc_nn2]);

figure(3),clf,
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;hold on;
