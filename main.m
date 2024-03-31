function Gout = main(elementList)

    % Order of elements is K C B
    N = sum(elementList);
    
    tic
    A = {};
    for i=1:N
        A = [A; step_one(i)];
    end
    disp(strcat('Step 1 done in ~', string(toc), 's'))

    tic
    B = step_two(A);
    disp(strcat('Step 2 done in ~', string(toc), 's'))

    tic
    C = step_three(B, N);
    disp(strcat('Step 3 done in ~', string(toc), 's'))
    
    tic
    [D, tf_list] = step_four(C, elementList);
    disp(strcat('Step 4 done in ~', string(toc), 's'))
    
    tic
    step_five(tf_list, elementList);
    disp(strcat('Step 5 done in ~', string(toc), 's'))
    
    Gout = D;

    for i=1:length(Gout)
        h = plot(Gout{i}, 'NodeLabel', Gout{i}.Nodes.Color, 'EdgeLabel',Gout{i}.Edges.Type);
        filename = strcat('mainStep4_', string(i),'.png');
        saveas(h, filename);
    end

    
end