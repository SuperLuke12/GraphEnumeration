function [RE, TFCoeffs] = compareTFMatrix(TFMatrix, TF, C, bList, cList, kList)

    RE = 0;
    
    
    for i=1:height(bList)
        for x=1:height(cList)
            for y=1:height(kList)
                currentPerm = [bList(i,:), cList(x,:), kList(y,:)];
                
                %TFString = simplifyFraction(subs(TF, C, currentPerm));
                
                [n, d] = numden(simplifyFraction(subs(TF, C, currentPerm)));
                cn = zeros(1,10);
                cd = zeros(1,10);
                cn(1:length(coeffs(n))) = coeffs(n);
                cd(1:length(coeffs(d))) = coeffs(d);
                
                TFCoeffs = [cn, cd];

                
                if any(ismember(TFMatrix, TFCoeffs, 'rows') == 1 )

                    RE = 1;
                    return
                end
            end
        end
    end
end