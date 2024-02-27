function [RE, TFCoeffs] = compareTFMatrix(TFMatrix, TF, C, bList, cList, kList)

    RE = 0;
    
    
    for i=1:height(bList)
        for x=1:height(cList)
            for y=1:height(kList)
                currentPerm = [bList(i,:), cList(x,:), kList(y,:)];
                
                %TFString = simplifyFraction(subs(TF, C, currentPerm));
                %disp(TFString)
                
                [n, d] = numden(simplifyFraction(subs(TF, C, currentPerm)));
                cn = zeros(1,4);
                cd = zeros(1,4);
                cn(1:length(coeffs(n))) = coeffs(n);
                cd(1:length(coeffs(d))) = coeffs(d);
                
                TFCoeffs = [cn, cd];
                
                
                %disp(ismember(TFMatrix, TFString, 'rows'))
                
                if any(ismember(TFMatrix, TFCoeffs, 'rows') == 1 )
                    %disp('TF exists')
                    RE = 1;
                    return
                end
            end
        end
    end
end