function results = step_five(Gout, tf_list, elementList)


options = optimoptions('fmincon','Display','off');


lb = [100 * ones(1,elementList(1)), 0 * ones(1,elementList(2)), 0 * ones(1,elementList(3))];
ub = [120000 * ones(1,elementList(1)), 8000 * ones(1,elementList(2)), 500 * ones(1,elementList(3))];
x0 = [60000 * ones(1,elementList(1)), 2000 * ones(1,elementList(2)), 100 * ones(1,elementList(3))];

sz = [0 3];
varTypes = ["double","double","double"];
varNames = ["NetworkID","Performance","OptimalValues"];

results = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);




for graphIndex = 1:length(tf_list) %CHANGE TO PARFOR
        
        disp(strcat('Assessing graph number ', string(graphIndex), '/', string(length(tf_list))))

        
        stiffness = findStiffness(Gout{graphIndex});
        
        if stiffness ~= 0
            stiffnessFcn = matlabFunction(stiffness);
            

            nonlincon = @(x) stiffnessFcn(mat2cell(x,1,ones(1,length(x))))- 120000;
        end


        fun = @(x) calcJ3(tf_list(graphIndex), x);
    
        problem = createOptimProblem('fmincon', 'objective', fun,'x0',x0,'lb', lb,'ub', ub,'nonlcon',@nonlcon,'options',options);
        ms = MultiStart;
    
        [x,f] = run(ms,problem, 3);
        results = [results; cell2table({graphIndex, f,x}, "VariableNames",varNames)];

end
results = sortrows(results,"Performance");



end


function [c,ceq] = nonlcon(x)

ceq = nonlincon(mat2cell(x,1,ones(1,length(x))));
    c = 0;
    
end
