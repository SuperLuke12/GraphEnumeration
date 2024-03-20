J3List = [];
optimalC = [];
optimalB = [];

syms s k c b
Y = k/s + c + b*s;


fun = @(x) calcJ3(Y,[1 1 1], [x(1) x(2) x(3)]);
x0 = [0.5, 0.5, 0.5];

[xOptimal, fvalOptimal] = fminsearch(fun, x0);

disp(xOptimal);


kList = 10000:10000:120000;

for kVal = kList
    fun = @(x) calcJ3([kVal x(1) x(2)]);
    x0 = [2000, 100];

    [x, fval] = fminsearch(fun, x0);

    disp(x);

    J3List(end+1) = fval;
    optimalC(end+1) = x(1);
    optimalB(end+1) = x(2);
end

tiledlayout(2,2)

ax1 = nexttile;
plot(ax1, kList, J3List)
hold on 
plot(ax1, xOptimal(1), fvalOptimal, '.', 'Color',[1.0 0 0])
hold off
xlabel('Static stiffness') 
ylabel('J3') 
ylim([350 700])

ax2 = nexttile;
plot(ax2, kList, optimalC)
hold on 
plot(ax2, xOptimal(1), xOptimal(2), '.', 'Color',[1.0 0 0])
hold off
xlabel('Static stiffness') 
ylabel('Optimal C value') 
ylim([1000 7000])

ax3 = nexttile;
plot(ax3, kList, optimalB)
hold on 
plot(ax3, xOptimal(1), xOptimal(3), '.', 'Color',[1.0 0 0])
hold off

xlabel('Static stiffness') 
ylabel('Optimal B value') 
ylim([0 600])




