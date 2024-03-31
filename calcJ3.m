function J3 = calcJ3(Y, params)

    
    kt = 150000;
    ks = 10000; % Added static spring
    mu = 35; 
    ms = 250;
    V = 25;
    roughness = 5*10^-7;
    
    syms s
    symbols = symvar(Y);
    symbols = flip(symbols(symbols~=s)); % Arranges symbols in order of KCB


    Y = Y + ks/s; % adds static stiffness spring in parrallel with the rest of the system
    H = subs((1/s) * (kt - kt*(kt/((mu*ms*s^4+mu*Y*s^3 + ms * Y * s^3)/(ms*s^2 + s*Y) + kt))), symbols, params);

    [n, d] = numden(H);
      
    n = double(coeffs(n, s, 'All'));
            
    d = double(coeffs(d, s, 'All'));

            
    sys = tf(n,d);
            
    J3 = 2 * pi * (V * roughness) ^ (1/2) * norm(sys);

end