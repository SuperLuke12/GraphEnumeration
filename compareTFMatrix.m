function [RE, TFCoeffs] = compareTFMatrix(TFMatrix, TF, C, bList, cList, kList)

    RE = 0;

    
    for i=1:height(bList)
        for x=1:height(cList)
            for y=1:height(kList)
                cn = zeros(1,10);
                cd = zeros(1,10);
                %TFString = simplifyFraction(subs(TF, C, currentPerm));
                
<<<<<<< HEAD
                [n, d] = numden(simplifyFraction(subs(TF, C, currentPerm)));
                cn = zeros(1,10);
                cd = zeros(1,10);
=======
                %[n, d] = numden(simplifyFraction(subs(TF, C, [bList(i,:), cList(x,:), kList(y,:)])));
                [n, d] = numden(subs(TF, C, [bList(i,:), cList(x,:), kList(y,:)]));

>>>>>>> 8313c783c3d8e75be5aa7b45ebc16a187aa217ba
                cn(1:length(coeffs(n))) = coeffs(n);
                cd(1:length(coeffs(d))) = coeffs(d);
                
                TFCoeffs = [cn, cd];
<<<<<<< HEAD

                
                if any(ismember(TFMatrix, TFCoeffs, 'rows') == 1 )

=======
                %disp(TFCoeffs)
                
                
                %disp(ismember(TFMatrix, TFString, 'rows'))
                
                if any(ismember(TFMatrix, TFCoeffs, 'rows') == 1)
                    %disp('TF exists')
>>>>>>> 8313c783c3d8e75be5aa7b45ebc16a187aa217ba
                    RE = 1;
                    return
                end
            end
        end
    end
end