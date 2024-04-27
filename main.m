function [Gout, runtime, performanceTable] = main(elementList)
runtime = zeros(1,4);

% Order of elements is K C B
N = sum(elementList);
t1 = 0.0;
t2 = 0.0;

A = {};
B = {};
parfor i=1:N
    tic
    temp = step_one(i);
    A = [A; temp];
    t1 = t1 + toc;

    tic
    B = [B, step_two(temp)];
    t2 = t2 + toc;
end
runtime(1,1) = t1;
runtime(1,2) = t2;
disp(strcat('Step 1 done in ~', string(t1), 's'))

disp(strcat('Step 2 done in ~', string(t2), 's'))

tic
C = step_three(B, N);
t3 = toc;
runtime(1,3) = t3;
disp(strcat('Step 3 done in ~', string(t3), 's'))

% for i=1:length(C)
%     graphGroup = C{i};
%     for j=1:length(graphGroup)
%         h = plot(graphGroup{j}, 'NodeLabel', graphGroup{j}.Nodes.Color);
%         filename = strcat('mainStep3_Group', string(i),'graph', string(j),'.png');
%         saveas(h, filename);
%     end
% end

tic
Gout = {};
tf_list = {};


[~,I] = sort(cellfun(@length,C));
C = C(I);

parfor group=1:length(C)
    [D, tfs] = step_four(C{group}, elementList);
    Gout = [Gout, D];
    tf_list = [tf_list, tfs];
end
t4 = toc;
runtime(1,4) = t4;

disp(strcat('Step 4 done in ~', string(t4), 's'))

disp(append('Generated ', string(length(Gout)), ' networks'))

tic
ks = 120000;
performanceTable = step_five(Gout, tf_list, elementList, ks);
disp(strcat('Step 5 done in ~', string(toc), 's'))

bestResults = performanceTable(performanceTable.Performance <= 1.001 * performanceTable{1,"Performance"}, :);
disp(bestResults)
for row = 1:size(bestResults,1)
    
    filename = strcat('J3_ks=',string(ks), '_elemNums=',string(sum(elementList)),'_f(x)=',string(bestResults{row,"Performance"})  , '_elements=', string(elementList(1)), string(elementList(2)), string(elementList(3)), '_',string(row),'I',string(height(bestResults)));

    writetable(bestResults(row,:),strcat(filename, '.txt'));

    network = Gout{bestResults{row,"NetworkID"}};
    h = plot(network, 'NodeLabel', network.Nodes.Color, 'EdgeLabel',strcat('Type:',string(network.Edges.Type), '-Name:',string(network.Edges.Name)));
    saveas(h, strcat(filename, '.png'));
end
% for i=1:length(Gout)
%     h = plot(Gout{i}, 'NodeLabel', Gout{i}.Nodes.Color, 'EdgeLabel',strcat(string(Gout{i}.Edges.Type), ':', string(Gout{i}.Edges.Name)));
%     filename = strcat('mainStep4_', string(i),'.png');
%     saveas(h, filename);
% end

end