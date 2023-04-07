%fc float-fixpoint
y=[0.05 0.15 0.25 0.35 0.45 0.55 0.65];
x=-log((exp(y)-1))
fix_x = abs((2^3)*x);
fix_pointx=round(fix_x)
