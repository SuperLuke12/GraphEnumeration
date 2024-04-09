function Gout = main(elementList)

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

disp(strcat('Step 1 done in ~', string(t1), 's'))

disp(strcat('Step 2 done in ~', string(t2), 's'))

tic
C = step_three(B, N);
disp(strcat('Step 3 done in ~', string(toc), 's'))

disp(C)
for i=1:length(C)
    graphGroup = C{i};
    for j=1:length(graphGroup)
        h = plot(graphGroup{j}, 'NodeLabel', graphGroup{j}.Nodes.Color);
        filename = strcat('mainStep3_Group', string(i),'graph', string(j),'.png');
        saveas(h, filename);
    end
end


tic
Gout = {};
tf_list = {};

% if length(C) > getenv('NUMBER_OF_PROCESSORS')
%
%     [~,I] = sort(cellfun(@length,C));
%     C = C(I);
%     temp = C(1:getenv('NUMBER_OF_PROCESSORS'));
%     temp2 = C(getenv('NUMBER_OF_PROCESSORS')+1:end);
%     numExtraGroups = getenv('NUMBER_OF_PROCESSORS') - length(C);
%
%
% end
[~,I] = sort(cellfun(@length,C));
C = C(I);

parfor group=1:length(C)
    [D, tfs] = step_four(C{group}, elementList);
    Gout = [Gout, D];
    tf_list = [tf_list, tfs];
end

disp(strcat('Step 4 done in ~', string(toc), 's'))

disp(append('Generated ', string(length(Gout)), ' networks'))

% tic
% step_five(tf_list, elementList);
% disp(strcat('Step 5 done in ~', string(toc), 's'))

% for i=1:length(Gout)
%     h = plot(Gout{i}, 'NodeLabel', Gout{i}.Nodes.Color, 'EdgeLabel',Gout{i}.Edges.Type);
%     filename = strcat('mainStep4_', string(i),'.png');
%     saveas(h, filename);
% end


end