function step_five(tf_list, elementList)


options = optimoptions('fmincon','Display','off');


lb = [10000 * ones(1,elementList(1)), 0 * ones(1,elementList(2)), 0 * ones(1,elementList(3))];
ub = [120000 * ones(1,elementList(1)), 8000 * ones(1,elementList(2)), 500 * ones(1,elementList(3))];
x0 = [60000 * ones(1,elementList(1)), 2000 * ones(1,elementList(2)), 100 * ones(1,elementList(3))];

sz = [0 3];
varTypes = ["double","double","double"];
varNames = ["Network","Performance","OptimalValues"];

results = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
disp(results)

parfor graphIndex = 1:length(tf_list)

    fun = @(x) calcJ3(tf_list(graphIndex), x);

    problem = createOptimProblem('fmincon', 'objective', fun,'x0',x0,'lb', lb,'ub', ub,'options',options);
    ms = MultiStart;
    [x,f] = run(ms,problem,3);
    results = [results; cell2table({graphIndex, f,x}, "VariableNames",varNames)];

end
disp(results)

end

