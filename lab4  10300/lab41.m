fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);
p = p1-1;
Y = [housing_data(:,1:p) ones(N,1)];
for j=1:p
    Y(:,j)=Y(:,j)-mean(Y(:,j));
    Y(:,j)=Y(:,j)/std(Y(:,j));
end

f = housing_data(:,p1);
f = f - mean(f);
f = f/std(f);

w = inv(Y'*Y)*Y'*f;
fh = Y*w;
E = ((norm(Y*w-f))^2)/N;

TIMES = 500;
Etrn = zeros(TIMES,1);
Etst = zeros(TIMES,1);

nt = 500;
for tis = 1:TIMES

    ii = randperm(N);

    Ytrn = [housing_data(ii(1:nt),1:p) ones(nt,1)];
    for j=1:p
        Ytrn(:,j)=Ytrn(:,j)-mean(Ytrn(:,j));
        Ytrn(:,j)=Ytrn(:,j)/std(Ytrn(:,j));
    end
    ftrn = housing_data(ii(1:nt),p1);
    ftrn = ftrn - mean(ftrn);
    ftrn = ftrn/std(ftrn);
    wtrn = inv(Ytrn'*Ytrn)*Ytrn'*ftrn;

    Ytst = [housing_data(ii(nt + 1:N),1:p) ones(N-nt,1)];
    for j=1:p
        Ytst(:,j)=Ytst(:,j)-mean(Ytst(:,j));
        Ytst(:,j)=Ytst(:,j)/std(Ytst(:,j));
    end
    ftst = housing_data(ii(nt+1:N),p1);
    ftst = ftst - mean(ftst);
    ftst = ftst/std(ftst);
    wtst = inv(Ytst'*Ytst)*Ytst'*ftst;

    Etrn(tis) = ((norm(Ytst*wtrn-ftst))^2)/(N-nt);
    Etst(tis) = ((norm(Ytst*wtst-ftst))^2)/(N-nt);
end

Etrn=Etrn(~isnan(Etrn));
Etst=Etst(~isnan(Etst));
[ptrn,o] = size(Etrn); [ptst,o] = size(Etst);
avgE_trn = sum(Etrn)/ptrn;
avgE_tst = sum(Etst)/ptst;

% strn = 0; stst = 0;ptrn = 0; ptst = 0;
% for tis = 1:TIMES
%     if Etrn(tis)~= ISNAN
%         strn = strn + Etrn(tis);
%     else
%         ptrn = ptrn + 1;
%     end
% end
% for tis = 1:TIMES
%     if Etst(tis)~= ISNAN
%         stst = stst + Etst(tis);
%     else
%         ptst = ptst + 1;
%     end
% end
% avgE_trn = strn/(TIMES-ptrn);
% avgE_tst = stst/(TIMES-ptst);

Eorg = E*ones(ptst,1);
ttt = 1:1:ptst;
figure(1), clf,
plot(ttt, Eorg, 'k',ttt, Etrn, 'r',ttt, Etst, 'b', 'LineWidth', 2);
grid on;
xlabel('Times','FontSize', 14);
ylabel('Errors', 'FontSize', 14);
title('red-training blue-training nt=450', 'FontSize', 14);
axis([1 516 0 1])
disp(['trn         ' 'tst']);
disp([avgE_trn avgE_tst]);

