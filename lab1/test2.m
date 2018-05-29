x = rand(1000,1);
subplot(2,1,1);hist(x,80);
[nn,xx] = hist(x);
subplot(2,1,2);bar(nn);