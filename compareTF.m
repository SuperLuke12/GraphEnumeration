function output = compareTF(TF1, TF2, C, bList, cList, kList)

    output = 0;

    if TF1 == TF2
        output = 1;
        return
    end

    tf2 = subs(TF2, C, [bList(1,:), cList(1,:), kList(1,:)]);
    
    for i=1:height(bList)
        for x=1:height(cList)
            for y=1:height(kList)
                currentPerm = [bList(i,:), cList(x,:), kList(y,:)];
                tf1 = subs(TF1, C, currentPerm);
                
                [n, d] = numden(simplifyFraction(tf1));
                cn = coeffs(n);
                cd = coeffs(d);
                
                cnc = ones(1,max(length(cn),length(cd)));
                cdc = ones(1,max(length(cn),length(cd)));

                cnc(1:length(cn)) = cn;
                cdc(1:length(cd)) = cd;


                if length(cnc.\cdc) > 4
                    disp('theory invalid')
                end
                %T = (n/cn(end))/(d/cd(end));
                %disp(T);
                if tf1 == tf2
                    output = 1;
                    
                    return
                end
            end
        end
    end
end