function Gout = main(elementList)

    N = length(elementList);

    A = {};
    for i=1:N
        A = [A; step_one(i)];
    end
    
    disp('Step 1 done')
    B = step_two(A);
    disp('Step 2 done')
    C = step_three(B, N);
    disp('Step 3 done')
    D = step_four(C, elementList);
    disp('Step 4 done')
    Gout = D;


    for i=1:length(Gout)
        h = plot(Gout{i}, 'NodeLabel', Gout{i}.Nodes.Color, 'EdgeLabel',Gout{i}.Edges.Type);
        filename = strcat('mainStep4_', string(i),'.png');
        saveas(h, filename);
    end
    
end