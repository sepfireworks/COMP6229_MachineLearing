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

%%% ÃÓ≥‰æÿ’Û1 timeSeriesS 
timeSeries1 = zeros(N-p1+1,p1);
for i = 1:p1
    k = 1;
    for j = i:N-p1+i
        timeSeries1(k,i) = XS1(j);
        k = k+1;
    end
end

%%% Õº5 
xi  = 1:1:u;


%[XS,sts] = lab5fSTD(data0);
XS2 = Vol;
p2 =20;
%%% ÃÓ≥‰æÿ’Û2 timeSeriesS 
timeSeries2 = zeros(N-p2+1,p2);

for i = 1:p2
    k = 1;
    for j = i:N-p2+i
        timeSeries2(k,i) = XS2(j);
        k = k+1;
    end
end
%%% ////////////////////

y1n = XS1(p1+1:N+1);
y2n = XS2(p2+1:N+1);
yn = [y1n y2n];
timeSeriesN = [timeSeries1 timeSeries2];
[netn] = feedforwardnet(20);
[netn] = train(netn, timeSeriesN', yn');

outSeriesN = zeros(u,2);
for i = 1:u
    if i == 1
        Xn = [XS1(N-p1+1+i:N+i);XS2(N-p2+1+i:N+i)];
    else
        Xn = [Xn(2:p1);nn_out(1);Xn(p1+2:p1+p2);nn_out(2)];
    end
    [nn_out] = netn(Xn);
    outSeriesN(i,1) = nn_out(1);
    outSeriesN(i,2) = nn_out(2);
end

figure(1),clf
plot(xi,outSeriesN(:,1),'g','LineWidth',2);
grid on; hold on;
set(gca,'FontSize',14);
figure(2),clf
plot(xi,outSeriesN(:,2),'k','LineWidth',2);
grid on; hold on;
set(gca,'FontSize',14);
