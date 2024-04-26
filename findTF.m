function H = findTF(g)
    syms s
    
    N = height(g.Edges);
    
    M = sym(zeros(height(g.Nodes)));
    K = sym(zeros(height(g.Nodes)));
    C = sym(zeros(height(g.Nodes)));

    
    kIndex = 1;
    cIndex = 1;
    bIndex = 1;
    
    
    for edgeIndex=1:height(g.Edges)
        
        
        EndNodes = g.Edges.EndNodes(edgeIndex,:);

        
        if g.Edges.Type(edgeIndex) == 1
            elementName = sym(strcat('k',string(kIndex)));
            kIndex = kIndex + 1;

            K(str2double(EndNodes{1}),str2double(EndNodes{1})) = K(str2double(EndNodes{1}),str2double(EndNodes{1})) + elementName;
            K(str2double(EndNodes{2}),str2double(EndNodes{2})) = K(str2double(EndNodes{2}),str2double(EndNodes{2})) + elementName;
            K(str2double(EndNodes{1}),str2double(EndNodes{2})) = K(str2double(EndNodes{1}),str2double(EndNodes{2})) - elementName;
            K(str2double(EndNodes{2}),str2double(EndNodes{1})) = K(str2double(EndNodes{2}),str2double(EndNodes{1})) - elementName;
            
        elseif g.Edges.Type(edgeIndex) == 2       
                
            elementName = sym(strcat('c',string(cIndex)));
            cIndex = cIndex + 1;

            C(str2double(EndNodes{1}),str2double(EndNodes{1})) = C(str2double(EndNodes{1}),str2double(EndNodes{1})) + elementName;
            C(str2double(EndNodes{2}),str2double(EndNodes{2})) = C(str2double(EndNodes{2}),str2double(EndNodes{2})) + elementName;
            C(str2double(EndNodes{1}),str2double(EndNodes{2})) = C(str2double(EndNodes{1}),str2double(EndNodes{2})) - elementName;
            C(str2double(EndNodes{2}),str2double(EndNodes{1})) = C(str2double(EndNodes{2}),str2double(EndNodes{1})) - elementName;
            
        elseif g.Edges.Type(edgeIndex) == 3 
            elementName = sym(strcat('b',string(bIndex)));
            bIndex = bIndex + 1;

            M(str2double(EndNodes{1}),str2double(EndNodes{1})) = M(str2double(EndNodes{1}),str2double(EndNodes{1})) + elementName;
            M(str2double(EndNodes{2}),str2double(EndNodes{2})) = M(str2double(EndNodes{2}),str2double(EndNodes{2})) + elementName;
            M(str2double(EndNodes{1}),str2double(EndNodes{2})) = M(str2double(EndNodes{1}),str2double(EndNodes{2})) - elementName;
            M(str2double(EndNodes{2}),str2double(EndNodes{1})) = M(str2double(EndNodes{2}),str2double(EndNodes{1})) - elementName;

        end

    end
    A = M.*s + C + K/s;    

    tNodes = g.Nodes(g.Nodes.Color==1,'Name'); 
    source = str2double(tNodes.Name(2));
    target = str2double(tNodes.Name(1));
    

    A(:,source) = [];
    A(source,:) = [];

    
    B = inv(A);

    H = 1/expand(B(target, target));
end