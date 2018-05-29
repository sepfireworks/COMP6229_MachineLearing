fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

TIMES1 = 20;
figure(1),clf,
axis([1 10 0 0.5]);
for tis1 = 1:TIMES1

    %Ntrn = round(N*rand(1));
    %Ntrn = 258;
    Ntrn = 400;
    [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);
    
    kn = 1;
    TIMES2 = 20;
    tt = 1:1:20;
    
    Etrn = zeros(TIMES2,1);
    Etst = zeros(TIMES2,1);
    for tis2 = 1:TIMES2
        [yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,kn*tis2);
        [yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,kn*tis2);
        Etrn(tis2) = Etrh;
        Etst(tis2) = Etsth;
    end

    
    plot(tt, Etrn, 'r', tt, Etst, 'b','LineWidth', 2), grid on,hold on;
    axis([1 10 0 0.5]);
    disp(tis1);
end