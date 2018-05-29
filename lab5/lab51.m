fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

[Y,w,y] = lab5fstd(N,p1,housing_data);
yh = Y*w;
El = ((norm(Y*w-y))^2)/N;

[yhl,Enl] = lab5fnl(N,Y,y,50);

disp([ '   El','         Enl']);
disp([El Enl]);
uu = -3:0.1:3;
jj = -3:0.1:3;
figure(1),clf,
plot( y, yh ,'rx', 'LineWidth', 2), grid on,hold on;
plot( uu, jj ,'k', 'LineWidth', 2), grid on,hold on;
title('Linear Regression', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);
axis([-3 3 -3 3]);

figure(2),clf,
plot(y, yhl, 'mo','LineWidth', 2), grid on,hold on;
plot( uu, jj ,'k', 'LineWidth', 2), grid on,hold on;
title('RBF Prediction', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);
axis([-3 3 -3 3]);