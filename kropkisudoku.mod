param m >= 1, integer, default 3;
param n := m*m;
set N := 1..n;  #insieme di indici
param max_double = floor (n/2), integer;
set O := 1..max_double;
set L := 1..n-1;

# quantità il cui valore è noto a priori
param P{N,N} default 0, integer, >= 0, <= n;  #numeri da inserire nelle caselle 
param C{N,N,N,N} default 0, <=1;
param B{N,N,N,N} default 0, <=1;

# z[i,j,k] = 1 if digit k is in row i and column j
var z{N,N,N} binary;

# dummy objective
minimize obj: 0;

# fisso la posizione dei numeri noti a priori
subject to fixed{i in N, j in N: P[i,j] <> 0}:
    z[i,j,P[i,j]] = 1;
    
# un solo numero per ogni casella 
subject to unique{i in N, j in N}: 
	sum{k in N} z[i,j,k] = 1;
	
subject to consec{i in N, j in N, h in N, k in N: B[i,j,h,k] == 1}:
	sum{l in L} z[i,j,l]*z[h,k,l+1] + sum{l in L} z[i,j,l+1]*z[h,k,l]>= 1;

subject to double{i in N, j in N, h in N, k in N: C[i,j,h,k] == 1}: 
	sum{o in O} z[i,j,2*o]*z[h,k,o] + sum{o in O} z[i,j,o]*z[h,k,2*o] >= 1;
	
# un solo numero k per ogni colonna
subject to col_sum{j in N, k in N}: 
    sum{i in N} z[i,j,k] = 1;

# un solo numero k per ogni riga
subject to row_sum{i in N, k in N}: 
    sum{j in N} z[i,j,k] = 1;

# un solo numero k per ogni sottoquadrato
subject to sqr_sum{r in 0..m-1, d in 0..m-1, k in N}:
	sum{p in 1..m, q in 1..m} z[m*r+p,m*d+q,k] = 1;
      

	      





