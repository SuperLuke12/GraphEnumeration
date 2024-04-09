function Gm = step_three(Gs, N)
Gm = {};
currentGroup = {};
prevNodeNum = height(Gs{1}.Nodes);


for i=1:length(Gs)
    g = Gs{i};
    Ne = numedges(g);

    if N-Ne == 0
        B = 'No extra edges';
    elseif Ne == 1
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

            if N-Ne ~=0

                makeEdgeBetweenNodes = g.Edges{B(j,x),:};
                g1 = addedge(g1, makeEdgeBetweenNodes{1}, makeEdgeBetweenNodes{2});

            end
        end

        for groupIndex=1:length(Gm)
            group = Gm{groupIndex};
            for graphIndex = 1:length(group)
                if isisomorphic(g1,group{graphIndex},'NodeVariables','Color') == 1
                    RE = 1;
                    break
                end
            end
        end

        for graphIndex = 1:length(currentGroup)
            if isisomorphic(g1,currentGroup{graphIndex},'NodeVariables','Color') == 1
                RE = 1;
                break
            end
        end

        if RE == 0
            
            thisGraphNumNodes = height(g.Nodes);
            
            if prevNodeNum == thisGraphNumNodes

                currentGroup{end + 1} = g1;
            else
                if length(currentGroup) > 0
                    Gm{end + 1} = currentGroup;
                end
                prevNodeNum = thisGraphNumNodes;
                currentGroup = {g1};
            end
        end
    end
end
Gm{end + 1} = currentGroup;

splitGroups = {};
for i=1:length(Gm)
    currentGroup = Gm{i};
    numPaths = [];
    for j=1:length(currentGroup)

        tNodes = currentGroup{j}.Nodes(currentGroup{j}.Nodes.Color==1,:);
        [~, edgePaths] = allpaths(currentGroup{j}, tNodes{1,1},tNodes{2,1});
        thisGraphNumPaths = length(edgePaths);
        numPaths = [numPaths, thisGraphNumPaths];
    end
    for j=min(numPaths):max(numPaths)
        newGroup = {currentGroup{numPaths==j}};
        splitGroups(end+1) = {newGroup};

    end
end
Gm = splitGroups;
end