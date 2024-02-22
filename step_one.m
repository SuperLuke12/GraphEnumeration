function G = step_one(Ne)

    G = {};
    
    for Nv = ceil(1/2+sqrt(1/4+2.*Ne)):Ne+1
        
        % Creates Complete graph with Nv vertices
    
        A = ones(Nv) - diag(ones(1,Nv));

        gc = graph(A~=0);


        B = nchoosek(1:Nv.*(Nv-1)/2,Ne);
    
    
        for j = 1:size(B,1)
            g = graph();
    
            for k = 1:Ne
                [sOut,tOut] = findedge(gc,B(j,k));
                g = addedge(g, sOut, tOut); 
            end

            g.Nodes.Name = string(1:height(g.Nodes)).';

            % Checking to see if whole graph is connected
            RE = not(all(conncomp(g) == 1));
            if RE
                continue
            end


            % Checking for isomorphic redundant graphs
            for i = 1:length(G)
                if isisomorphic(g, G{i})
                    RE = 1;
                    break
                end
            end
            
            if RE
                continue
            end
            
            G = [G; {g}];
            
        end
    end
end