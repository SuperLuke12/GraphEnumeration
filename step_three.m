function Gm = step_three(Gs, N)
    Gm = {};
    for i=1:length(Gs)
        g = Gs{i};
        Ne = numedges(g);
        if Ne == 1
            B = ones(1,N-Ne);     
        else   
            B = nmultichoosek(1:Ne, N-Ne);    
        end
       


        % Goes through all permutations of edge indexes to make parallel
        for j = 1:height(B)
            RE = 0;
            g1 = g;
            
            % Goes through all edge indexes in a single permutation
            for x=1:width(B(j,:))

                
                makeEdgeBetweenNodes = g.Edges{B(j,x),:};
                
                
                g1 = addedge(g1, makeEdgeBetweenNodes{1}, makeEdgeBetweenNodes{2});
            
            end

            for k=1:length(Gm)
                
                if isisomorphic(g1,Gm{k},'NodeVariables','Color') == 1
                    
                    RE = 1; 

                    break
                end
            end
            
            if RE == 0

                Gm{end + 1} = g1;

            end
        
        end
                
        if height(B) == 0
            Gm{end + 1} = g;       
        end
    end
end