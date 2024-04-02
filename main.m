function Gout = main(elementList)

    % Order of elements is K C B
    N = sum(elementList);
    

    t1 = 0.0;
    t2 = 0.0;

    A = {};
    B = {};
    for i=1:N
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
    
    tic
    [D, tf_list] = step_four(C, elementList);
    disp(strcat('Step 4 done in ~', string(toc), 's'))
    
    disp(append('Generated ', string(length(D)), ' networks'))
    % tic
    % step_five(tf_list, elementList);
    % disp(strcat('Step 5 done in ~', string(toc), 's'))
    % 
    Gout = D;

    % for i=1:length(Gout)
    %     h = plot(Gout{i}, 'NodeLabel', Gout{i}.Nodes.Color, 'EdgeLabel',Gout{i}.Edges.Type);
    %     filename = strcat('mainStep4_', string(i),'.png');
    %     saveas(h, filename);
    % end

    
end