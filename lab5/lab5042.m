fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

TIMES1 = 20;
figure(1),clf,
axis([1 10 0 0.5]);
for tis1 = 1:TIMES1

    %Ntrn = round(N*rand(1));
    Ntrn = 400;
    [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

%     kn = 5;
%     TIMES2 = 10;
%     tt = 1:1:10;

%     kn = 2;
%     TIMES2 = 25;
%     tt = 1:1:25;
    
    kn = 1;
    TIMES2 = 10;
    tt = 1:1:10;
    
    Etrn = zeros(TIMES2,1);
    Etst = zeros(TIMES2,1);
    for tis2 = 1:TIMES2
        [yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,kn*tis2);
        [yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,kn*tis2);
        Etrn(tis2) = Etrh;
        Etst(tis2) = Etsth;
    end
% figure(TIMES+1),clf,
% bar(Etrn);
% figure(TIMES+2),clf,
% bar(Etst);
    
    plot(tt, Etrn, 'r', tt, Etst, 'b','LineWidth', 2), grid on,hold on;
%     axis([1 10 0 0.5]);
%     axis([1 25 0 0.5]);
    axis([1 10 0 0.5]);
    disp(tis1);
end
