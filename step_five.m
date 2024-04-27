function results = step_five(Gout, tf_list, elementList, ks)

% ks is static stiffness of over all system constraint


options = optimoptions('fmincon','Display','off');


lb = [100 * ones(1,elementList(1)), 0 * ones(1,elementList(2)), 0 * ones(1,elementList(3))];
ub = [120000 * ones(1,elementList(1)), 8000 * ones(1,elementList(2)), 500 * ones(1,elementList(3))];
x0 = [60000 * ones(1,elementList(1)), 2000 * ones(1,elementList(2)), 100 * ones(1,elementList(3))];

sz = [0 3];
varTypes = ["double","double","double"];
varNames = ["NetworkID","Performance","OptimalValues"];

results = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);




parfor graphIndex = 1:length(tf_list) %CHANGE TO PARFOR
        
        disp(strcat('Assessing graph number ', string(graphIndex), '/', string(length(tf_list))))

        
        stiffness = findStiffness(Gout{graphIndex});
        disp(stiffness)
        if stiffness ~= 0
            % Finds index of all springs used within passive stiffness eqn
            springsUsed = string(symvar(stiffness));
            springsUsed = str2double(erase(springsUsed,'k'));
            
            %Creates anonymous fcn from stiffness expression
            stiffnessFcn = matlabFunction(stiffness);
            
            %Creates anonymous fcn
            nonlcon = @(x) generalnonlcon(x, stiffnessFcn,springsUsed ,ks);

            fun = @(x) calcJ3(tf_list(graphIndex), x);
        
            try
                problem = createOptimProblem('fmincon', 'objective', fun,'x0',x0,'lb', lb,'ub', ub,'nonlcon',nonlcon,'options',options);
                
                ms = MultiStart;
                
                [x,f] = run(ms,problem, 3);
                results = [results; cell2table({graphIndex, f,x}, "VariableNames",varNames)];
            catch
                disp('H2 norm unstable')
            end
        
        else
            results = [results; cell2table({graphIndex, 999999999, zeros(1, sum(elementList))}, "VariableNames",varNames)];
        end
end
results = sortrows(results,"Performance");
disp(results)
end

% General Non-linear constraint that is adapted to each stiffness fcn
function [c,ceq] = generalnonlcon(x,stiffnessFcn, springsUsed, ks)
    % ks is the static stiffness of over all system
    args = num2cell(x);
    ceq = stiffnessFcn(args{springsUsed}) - ks;
    c = [];
    
end
