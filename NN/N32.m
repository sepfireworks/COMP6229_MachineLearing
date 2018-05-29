[data,text]  = xlsread('FTSE 100 Historical Data.xlsx');
[a,~] = size(data);
dataxxx = data(2:a,1);
data0 = zeros(a-1,1);
for i=1:a-1
    data0(i) = dataxxx(a-i);
end

Vol0 = zeros(a-1,1);
for i = 1:a-1
    b = char(text(i+2,6));
    c = b(length(b));
    d = str2double(b(1:length(b)-1));
    if c == 'M'
        volu = d*((10)^(6));
    elseif c == 'B'
        volu = d*((10)^(9));
    end
    Vol0(i) = volu;
end
Vol = zeros(a-1,1);
for i=1:a-1
    Vol(i) = Vol0(a-i);
end


u = 20;N = a - 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1 = 20;
%[XS,sts] = lab5fSTD(data0);
XS1 = data0;

%%% 填充矩阵1 timeSeriesS 
timeSeries1 = zeros(N-p1+1,p1);
for i = 1:p1
    k = 1;
    for j = i:N-p1+i
        timeSeries1(k,i) = XS1(j);
        k = k+1;
    end
end

y1 = XS1(p1+1:N+1);
[net1] = feedforwardnet(20);
[net1] = train(net1, timeSeries1', y1');

%%% 使用神经网络预测500次，结果输入至outSeries2
outSeries1 = zeros(u,1);
for i = 1:u
    if i == 1
        Xn = XS1(N-p1+i:N+i-1);
    else
        Xn = [Xn(2:p1);nn_out1];
    end
    [nn_out1] = net1(Xn);
    outSeries1(i) = nn_out1;
end


% figure(1),clf
% plot(xxxx,nn_out,'y');

%%% 图5  将500次结果画出， 黄色 线性回归   绿色 神经网络
xi  = 1:1:u;
figure(1),clf
plot(xi,outSeries1(1:u),'b','LineWidth',4);
set(gca,'FontSize',14);
grid on; hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%[XS,sts] = lab5fSTD(data0);
XS2 = Vol;
p2 =20;
%%% 填充矩阵2 timeSeriesS 
timeSeries2 = zeros(N-p2+1,p2);

for i = 1:p2
    k = 1;
    for j = i:N-p2+i
        timeSeries2(k,i) = XS2(j);
        k = k+1;
    end
end

%%% 训练神经网络
y2 = XS2(p2+1:N+1);
[net2] = feedforwardnet(20);
[net2] = train(net2, timeSeries2', y2');

outSeries2 = zeros(u,1);
for i = 1:u
    if i == 1
        Xn = XS2(N-p1+i:N+i-1);
    else
        Xn = [Xn(2:p2);nn_out2];
    end
    [nn_out2] = net2(Xn);
    outSeries2(i) = nn_out2;
end
%%% 成交量预测图
figure(2),clf
plot(xi,outSeries2(1:u),'y','LineWidth',3);
set(gca,'FontSize',14);
grid on; hold on;

%%% 训练收盘价和成交量的关系
data_vol = [data0 Vol];
yx = data0;
[netx] = feedforwardnet(20);
[netx] = train(netx, data_vol', yx');

%%% 根据前面预测重新预测
outSeriesX = zeros(u,1);
for i = 1:u
    Xn = [outSeries1(i);outSeries2(i)];
    [nn_outx] = netx(Xn);
    outSeriesX(i) = nn_outx;
end

figure(1),
plot(xi,outSeriesX(1:u),'r','LineWidth',2);
set(gca,'FontSize',14);
grid on; hold on;
