function H = findStiffness(g)
    syms s

    edges = g.Edges;
    nonSprings = edges(edges.Type ~= 1, :);
    g = rmedge(g,nonSprings{:,'Name'}.');

    isolated_nodes = find(degree(g) == 0);
    g = rmnode(g,isolated_nodes);
    
    if height(g.Nodes(g.Nodes.Color==1,:)) ~= 2
        H = 0;
        return
    end


    K = sym(zeros(height(g.Nodes)));  
    kIndex = 1;

    
    
    for edgeIndex=1:height(g.Edges)
        
        
        EndNodes = g.Edges.EndNodes(edgeIndex,:);

        
        if g.Edges.Type(edgeIndex) == 1
            elementName = sym(strcat('k',string(kIndex)));
            kIndex = kIndex + 1;

            K(findnode(g,EndNodes{1}),findnode(g,EndNodes{1})) = K(findnode(g,EndNodes{1}),findnode(g,EndNodes{1})) + elementName;
            K(findnode(g,EndNodes{2}),findnode(g,EndNodes{2})) = K(findnode(g,EndNodes{2}),findnode(g,EndNodes{2})) + elementName;
            K(findnode(g,EndNodes{1}),findnode(g,EndNodes{2})) = K(findnode(g,EndNodes{1}),findnode(g,EndNodes{2})) + elementName;
            K(findnode(g,EndNodes{2}),findnode(g,EndNodes{1})) = K(findnode(g,EndNodes{2}),findnode(g,EndNodes{1})) + elementName;
            
        end

    end
    A = K/s;    

    tNodes = g.Nodes(g.Nodes.Color==1,'Name'); 
    source = findnode(g,tNodes.Name(2));
    target = findnode(g,tNodes.Name(1));
    

    A(:,source) = [];
    A(source,:) = [];

    
    B = inv(A);

    H = 1/expand(B(target, target));

    H = subs(H, s, 1);
end