function Gs = step_two(G)
    Gs = {};

    for i = 1:length(G)

        g = G{i};
        Nv = numnodes(g);
        C = nchoosek(1:Nv, 2); % C stores all terminal combinations


        for j = 1:height(C)

            RE = 0;
            g.Nodes.Color = zeros(Nv,1); % Colors all nodes as non-terminals

            g.Nodes.Color(C(j,:)) = [1,1]; % Colors terminal nodes as terminals
            

            % Cycles through all the non-terminal nodes
            for node = setdiff(1:Nv,C(j,:))

                
                % Creates a copy of the graph with a terminal node removed
                g_copy = rmnode(g,string(C(j,2)));
                
                % Finds all path from node to the other terminal node
                P = allpaths(g_copy,string(C(j,1)),string(node));

                % If it is not possible to traverse from node to terminal,
                % redundant
                if isempty(P)
                    RE = 1;
                    continue
                end

                canTraverse = 0;

                % Cycles through all paths from node to terminal
                for pathIndex=1:height(P)
                    
                    path = P{pathIndex};


                    % Creates new graph copy with nodes in path removed 
                    g_copy = rmnode(g,path(1:end-1));
                
                    % Checks if the Node can traverse to the other terminal node
                    if ~isempty(shortestpath(g_copy,string(node),string(C(j,2))))
                        canTraverse = 1;
                    end
                end
                
                % If all nodes can traverse to both nodes, graph not
                % redundant
                if canTraverse == 0
                    RE = 1;
                end
            end
            
            for x = 1:length(Gs)
                if isomorphism(g,Gs{x},'NodeVariables','Color')
                    
                    RE = 1;
                end
            end
            if RE ~= 1
                Gs{end + 1} = g;
            end
        end
    end
end