C1 = [2,1;1,2];
C2 = [2,1;1,2];
m1 = [0;2];
m2 = [1.7;2.5];

N = 200;

wF = inv(C1+C2)*(m1-m2);
xx = -6:0.1:6;
yy = xx*wF(2)/wF(1);

rocResolution = 50;
TIMES = 100;
c1NN = zeros(1,TIMES);
cEUC = zeros(1,TIMES);
cMAS = zeros(1,TIMES);
ckNN = zeros(1,TIMES);
ckmn = zeros(1,TIMES);
cFsh = zeros(1,TIMES);

for tis = 1:TIMES
    X1 = mvnrnd(m1, C1, N);
    X2 = mvnrnd(m2, C2, N);
    [ROC, acc, thRange] = lab3f1(N,X1,X2,wF,rocResolution);
    cFsh(tis) = max(acc);
    % knn
    X = [X1;X2];N1 = size(X1,1);N2 = size(X2,1);y = [ones(N1,1); -1*ones(N2,1)];
    d = zeros(N1+N2-1,1);nCorrect = 0;k = 7;
    for jtst = 1:(N1+N2)
        xtst = X(jtst,:);ytst = y(jtst);jtrn = setdiff(1:N1+N2, jtst);Xtrn = X(jtrn,:);ytrn = y(jtrn,1);
        x1max = max(Xtrn(:,1));x2max = max(Xtrn(:,2));x1min = min(Xtrn(:,1));x2min = min(Xtrn(:,2));
        for i = 1:(N1+N2-1)
            d(i) = (((Xtrn(i,1)-xtst(1))/(x1max-x1min))^2+((Xtrn(i,2)-xtst(2))/(x2max-x2min))^2)^(1/2);
        end
        dc = sort(d);
        i = 0;j = 0;p = 0; ne = 0;
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
    ckNN(tis) = nCorrect*100/(N1+N2);
    
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
    c1NN(tis) = nCorrect1*100/(N1+N2);

    %mkm k-mean
    s1 = zeros(1,2); s2 = zeros(1,2);
    s1(1) = (rand(1)*2 - 1);s1(2) = (rand(1)*2 - 1)+2;
    s2(1) = 0.25*(rand(1)*2 - 1)+1.75;s2(2) = 0.5*(rand(1)*2 - 1)+2.5;
    se1 = s1; se2 = s2;XE1 = zeros(N1+N2,2);XE2 = zeros(N1+N2,2);
    ye = [ones(N1,1); -1*ones(N2,1)];i1 = 1; i2 = 1;rt = 0;
    nCorrectmkm = 0;De1 = 0; De2 = 0;
    while rt<100
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
        i1 = 1; i2 = 1;rt = rt+1;
        XE1 = zeros(N1+N2,2);XE2 = zeros(N1+N2,2);
    end
    for j = 1:N1+N2
        if ye(j)*y(j)>0
            nCorrectmkm = nCorrectmkm+1;
        end
    end
    ckmn(tis) = nCorrectmkm*100/(N1+N2);

    %me Eucld
    y = [ones(N1,1); -1*ones(N2,1)];
    ye = 0;
    nCorrectme = 0;
    for jtst = 1:(N1+N2)
        xtst = X(jtst,:);
        ytst = y(jtst);
    
        dex1 = norm(xtst-m1');
        dex2 = norm(xtst-m2');
        if dex1<dex2
            ye = 1;
        else
            ye = -1;
        end

    
        if(ye*ytst>0)
            nCorrectme = nCorrectme + 1;
        end
    end

    cEUC(tis) = nCorrectme*100/(N1+N2);

    %mm mahal
    y = [ones(N1,1); -1*ones(N2,1)];
    ym = 0;
    nCorrectmm = 0;
    for jtst = 1:(N1+N2)
        xtst = X(jtst,:);
        ytst = y(jtst);
    
        dm1 = mahal(xtst,X1);
        dm2 = mahal(xtst,X2);
        if dm1<dm2
            ym = 1;
        else
            ym = -1;
        end

    
        if(ym*ytst>0)
            nCorrectmm = nCorrectmm + 1;
        end
    end
    cMAS(tis) = nCorrectmm*100/(N1+N2);

end

Xx = 1:1:100;
figure(1),clf,
plot(Xx,cFsh*100,'r', 'LineWidth', 2);grid on;hold on;
plot(Xx,c1NN,'g', 'LineWidth', 2);hold on;
plot(Xx,cEUC,'b', 'LineWidth', 2);hold on;
plot(Xx,cMAS,'y', 'LineWidth', 2);hold on;
plot(Xx,ckNN,'m', 'LineWidth', 2);hold on;
plot(Xx,ckmn,'k', 'LineWidth', 2);hold on;
xlabel('Fisher-red 1NN-green Edistance-blue Mdistance-yellow kNN-purple kmean-black', 'FontSize', 12);
axis([1 100 0 100]);
a_cFsh = sum(cFsh*100)/TIMES;
a_c1NN = sum(c1NN)/TIMES;
a_cEUC = sum(cEUC)/TIMES;
a_cMAS = sum(cMAS)/TIMES;
a_ckNN = sum(ckNN)/TIMES;
a_ckmn = sum(ckmn)/TIMES;
disp([a_cFsh a_c1NN a_cEUC a_cMAS a_ckNN a_ckmn]);