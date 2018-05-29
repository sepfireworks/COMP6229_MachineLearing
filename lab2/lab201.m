%plot([0 -4], [-3 0], 'b', 'LineWidth', 2);
%axis([-5 5 -5 5]); grid on;
X = [X ones(N,1)];

ii = randperm(N);
Xtr = X(ii(1:N/2),:);
ytr = X(ii(1:N/2),:);
Xts = X(ii(N/2+1:N),:);
yts = X(ii(N/2+1:N),:);

w = randn(3,1);

eta = 0.001;
for iter = 1 : 500
    j = ceil(rand*N/2);
    if( ytr(j)*Xtr(j,:)*w <0 )
        w = w + eta*ytr(j)*Xtr(j,:)';
    end
end

yhts = Xts*w;
disp([yts yhts])
PercentageError = 100*sun(find(yts .* yhts < 0))/Nts;