function [RE, TFCoeffs] = compareTFMatrix(TFMatrix, TF, C, bList, cList, kList)

    RE = 0;

    
    for i=1:height(bList)
        for x=1:height(cList)
            for y=1:height(kList)
                

                cn = zeros(1,10);
                cd = zeros(1,10);

                [n, d] = numden(subs(TF, C, [bList(i,:), cList(x,:), kList(y,:)]));


                cn(1:length(coeffs(n))) = coeffs(n);
                cd(1:length(coeffs(d))) = coeffs(d);
                
                TFCoeffs = [cn, cd];

                
                if any(ismember(TFMatrix, TFCoeffs, 'rows') == 1)
                    RE = 1;
                    return
                end
            end
        end
    end
end