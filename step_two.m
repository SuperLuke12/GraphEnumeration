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


            for node = setdiff(1:Nv,C(j,:))


                g_copy = rmnode(g,string(C(j,2)));
                
                P = shortestpath(g_copy,string(C(j,1)),string(node));

                if isempty(P)
                    RE = 1;
                    continue
                end
                
                g_copy = rmnode(g,P(1:end-1));
                
                P = shortestpath(g_copy,string(node),string(C(j,2)));


                if isempty(P)
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