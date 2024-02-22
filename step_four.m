function Gn = step_four(Gm, W)
    
    % N is number of elements / edges
    N = length(W);
    
    % Gn is the list of all accepted network configurations
    % TFs is the list of all of their respective transfer functions
    Gn = {};
    TFs = {};
    
    % P represents a list of all possible ways of assigning element types
    % to the edges of the graph
    P = perms(W);

    % Iterates through each network topology
    for i = 1:length(Gm)
        
        % g is current network topology
        g = Gm{i};
        g.Edges.Type = zeros(N,1);
        
        % Iterates through all element type permutations
        for j = 1:length(P)
            
            g.Edges.Type = P(j,:).';

            RE = 0;

            % Checking for parrallel element redundancy
            
            % A is used to store the edge table as a matrix with format of
            % [Source Node, Target Node, Type] with N rows.
       
            A = zeros(N,3);
            A(:,3) = g.Edges{:,2};
            for l=1:height(g.Edges)
                % Temp is throwaway variable storing the source and target nodes of each element
                temp = g.Edges{l,1}; 
                A(l,[1,2]) = [str2double(cell2mat(temp(1))) str2double(cell2mat(temp(2)))];
                
            end

            % Comparison A with unique(A, 'rows') tells whether any edge
            % weights of the same type are repeated
            if not(isequal(A, unique(A,'rows')))
                RE = 1;
                continue
            end     
            
            % Checking for serial redundancy

            % Stores Terminal Nodes information
            tNodes = g.Nodes(g.Nodes.Color==1,:); 
            
            % Finds all the edge paths between the terimnal nodes
            [~, edgePaths] = allpaths(g, tNodes{1,1},tNodes{2,1});


            % Assigns Edges a name and generates a list of all pairs of
            % edges

            g.Edges.Name = transpose(1:N);
            edgeCombinations = nchoosek(1:N,2);
            
            % eCi is the index while iterating through edgeCombinations
            
            for eCi = 1:height(edgeCombinations)
                
                edge1 = edgeCombinations(eCi,1);
                edge2 = edgeCombinations(eCi,2);
                
                % Only compares edges that are of the same type
                if g.Edges.Type(edge1) == g.Edges.Type(edge2)
                    
                    edgesInSeries = false;
                    
                    % pI is the index while iterating through edgePaths
                    for pI = 1:height(edgePaths)
        
                        path = edgePaths{pI,:};
                        
                        % If one of either edge is not in the same path,
                        % these two edges are not in series
                        if xor(ismember(edge1,path), ismember(edge2,path))      
                            edgesInSeries = false;
                            break
                        
                        elseif and(ismember(edge1,path), ismember(edge2,path))
                            edgesInSeries = true;
                        end
                    end
                                
                    if edgesInSeries
                        RE = 1;
                        continue
                    end
                end
            end
            
            if RE == 0
                
                TF = findTF(g);
                
                

                for tfi=1:length(TFs)


                    
                        
                    if compareTF(TF, TFs{tfi})
                        RE = 1;
                        break
                    end
                    
                
                end
                
 
                
                if RE == 0
                
                    Gn{end+1} = g;
                    TFs{end+1} = TF;
                    
            
                end
                
            end
            
        end
        
    end
    
end
