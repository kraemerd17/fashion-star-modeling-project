% Legend:
% TWS: Tailored Wool Slacks
% CAS: Cashmere Sweater
% SB:  Silk Blouse
% SC:  Silk Camisole
% TS:  Tailored Skirt
% 
% WB:  Wool Blazer
% VP:  Velvet Pants
% CS:  Cotton Sweater
% CM:  Cotton Miniskirt
% VS:  Velvet shirt
% BB:  Button-down Blouse
% 
% W:   Wool
% A:   Acetate
% CA:  Cashmere
% S:   Silk
% R:   Rayon
% V:   Velvet
% C:   Cotton

% Sunk costs
sunkcosts = 860000 + 3 * 1200000;

% Revenue weights
%                   TWS CAS  SB  SC  TS  WB  VP  CS CM  VS  BB
revenue_weights  = [300 450 180 120 270 320 350 130 75 200 120];
labor_weights    = [160 150  80  60 120 140 175  60 40 160  90];
material_weights = [9 * 3 + 1.5 * 2      ...
                    60 * 1.5             ...
                    13 * 1.5             ...
                    13 * 0.5             ...
                    2.25 * 2 + 1.5 * 1.5 ...
                    9 * 2.5 + 1.5 * 1.5  ...
                    12 * 3 + 1.5 * 2     ...
                    2.5 * 1.5            ...
                    2.5 * 0.5            ...
                    12 * 1.5             ...
                    2.25 * 1.5];

net_profit_weights = revenue_weights - labor_weights - material_weights;

%  TWS, CAS,  SB,  SC,  TS,  WB,  VP,  CS,  CM,  VS,  BB;

A = [ 0,   0,   0,   0,   0,   0,   1,   0,   0,   0,   0; %5500
      0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   0; %6000
      0,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0; %4000
      0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   0; %12000
      0,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0; %15000
      0,   0,   0,   0,  -1,   0,   0,   0,   0,   0,   0; %-2800
      0,   0,   0,   0,   0,  -1,   0,   0,   0,   0,   0; %-(5000*0.6)
      0,   0,   0,   0,   0,   1,   0,   0,   0,   0,   0; %5000
     -1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0; %-(7000*0.6)
      1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0; %7000
      3,   0,   0,   0,   0, 2.5,   0,   0,   0,   0,   0; %45000
      2,   0,   0,   0, 1.5, 1.5,   0,   0,   2,   0,   0; %28000
      0, 1.5,   0,   0,   0,   0,   0,   0,   0,   0,   0; %9000
      0,   0, 1.5, 0.5,   0,   0,   0,   0,   0,   0,   0; %18000
      0,   0,   0,   0,   2,   0,   0,   0,   0,   0, 1.5; %30000
      0,   0,   0,   0,   0,   0,   3,   0,   0, 1.5,   0; %20000
      0,   0,   0,   0,   0,   0,   0, 1.5, 0.5,   0,   0; %30000
      0,   0,   1,  -1,   0,   0,   0,   0,   0,   0,   0; %0
      0,   0,   0,   0,   0,   0,   0,   1,  -1,   0,   0; %0
 ];
   
constraints = [5500, 6000,  4000, 12000, 15000, -2800, -3000,  5000, -4200, ...
               7000, 45000, 28000,  9000, 18000, 30000, 20000, 30000, 0, 0];

lower_bounds = zeros(1,length(net_profit_weights));
%upper_bounds = 100000 * ones(1, length(net_profit_weights));
upper_bounds = [];

bundle  = linprog(-net_profit_weights, A, constraints, ...
                  [], [], lower_bounds, upper_bounds, []);

result = [constraints; (A * bundle).'];

assert(all(result(1,:) >= result(2,:)))

profit = dot(net_profit_weights, bundle) - sunkcosts;
