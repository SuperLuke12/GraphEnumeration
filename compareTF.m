function output = compareTF(TF1, TF2)

    output = 0;

    TF1 = expand(TF1);
    TF2 = expand(TF2);


    if TF1 == TF2
        output = 1;
        return
    end

    syms s
    
    C = symvar(TF1);
    C = C(C~=s);
    T = unique([C symvar(TF2)]);
    T = T(T~=s);

    P = perms(randperm(100,length(C)));


    tf2 = subs(TF2, T, P(1,:));

    for i= 1:height(P)

        tf1 = subs(TF1, C, P(i,:));
        
        if tf1 == tf2
            output = 1;
            
            return
        end

    end

end