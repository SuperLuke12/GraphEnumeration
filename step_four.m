function [Gn, tf_list] = step_four(Gm, elementList)
    % Defining symbol s to represent laplace complex parameter
    syms s
        
    kList = sym([strcat('k',string(1:elementList(1)))]);
    cList = sym([strcat('c',string(1:elementList(2)))]);
    bList = sym([strcat('b',string(1:elementList(3)))]);
    C = [kList, cList, bList];
   
    parameterNums = randperm(100,sum(elementList));

    paramPerms = [];
               
    kList = perms(parameterNums(1:elementList(1)));          
    cList = perms(parameterNums(elementList(1)+(1:elementList(2))));         
    bList = perms(parameterNums(elementList(1)+elementList(2)+(1:elementList(3))));
    
    for kIndex=1:height(kList)             
        for cIndex=1:height(cList)         
            for bIndex=1:height(bList)
                 paramPerms(end+1, :) = [kList(kIndex,:), cList(cIndex,:), bList(bIndex,:)] ;     
            end         
        end
    end



    % N is number of elements / edges
    N = sum(elementList);
    
    % Gn is the list of all accepted network configurations
    % TFs is the list of all of their respective transfer functions
    Gn = {};

    tf_list = sym([]);

    nCoeffMatrix = zeros(0,1);
    dCoeffMatrix = zeros(0,1);

    numPaths = [];
    numNodes = [];
    numParrallel = [];

    % P represents a list of all possible ways of assigning element types
    % to the edges of the graph

    W = [ones(1, elementList(1)), 2*ones(1, elementList(2)), 3*ones(1, elementList(3))];

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

               % Storing details about current graph
               thisGraphNumPaths = length(edgePaths);
               thisGraphNumNodes = height(g.Nodes);
               thisGraphNumParrallel = height(A(:,[1 2]))-height(unique(A(:,[1 2]), 'rows'));

               %% Indexes valid graphs to compare
               validNumPaths = numPaths == thisGraphNumPaths;
               validNumNodes = numNodes == thisGraphNumNodes;
               validNumParrallel = numParrallel == thisGraphNumParrallel;

               validGraphs = validNumNodes & validNumPaths & validNumParrallel;

               for paramIndex=1:height(paramPerms)
                   [n, d] = numden(subs(TF, C, paramPerms(paramIndex,:)));
                           
                   nCoeffs = coeffs(n);       
                   dCoeffs = coeffs(d);
 
                   if length(nCoeffs) > width(nCoeffMatrix) || length(dCoeffs) > width(dCoeffMatrix)

                       break
                   else     
                       nCoeffs = [nCoeffs zeros(1, width(nCoeffMatrix)-length(nCoeffs))];     
                       dCoeffs = [dCoeffs zeros(1, width(dCoeffMatrix)-length(dCoeffs))];
                   end         
                   if any(ismember(nCoeffMatrix(validGraphs,:), nCoeffs, 'rows') == 1 & ismember(dCoeffMatrix(validGraphs,:), dCoeffs, 'rows') == 1)    
                       RE = 1; 
                   end
               end

               if RE == 0 
                    
                    Gn{end+1} = g;
                                               
                    if length(nCoeffs) > width(nCoeffMatrix)

                        nCoeffMatrix = [nCoeffMatrix zeros(height(nCoeffMatrix), length(nCoeffs)-width(nCoeffMatrix)) ];   
                    end

                    if length(dCoeffs) > width(dCoeffMatrix)           
                        dCoeffMatrix = [dCoeffMatrix zeros(height(dCoeffMatrix), length(dCoeffs)-width(dCoeffMatrix))];   
                    end


                    nCoeffMatrix(end+1,1:length(nCoeffs)) = nCoeffs;
                    dCoeffMatrix(end+1,1:length(dCoeffs)) = dCoeffs;

                    tf_list(end+1) = TF;

                    numPaths = [numPaths; thisGraphNumPaths];
                    numNodes = [numNodes; thisGraphNumNodes];
                    numParrallel = [numParrallel; thisGraphNumParrallel];

               end
            end 
        end
    end
end
