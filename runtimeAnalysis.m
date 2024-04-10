function output = runtimeAnalysis()
tests = [2 2 2; 3 2 1; 4 1 1];
output = zeros(height(tests), 4);
cycles = 3;
for x=1:height(tests)

    runtimes= zeros(cycles,4);
    
    for i = 1:cycles
        [~, runtimes(i,:)] = main(tests(x, :));
    end
    output(x,:) = mean(runtimes, 1);
    
end
disp(output)