function rand_out = rand_unif(a,b,nrows,ncols)

if exist('nrows', 'var') && exist('ncols', 'var')
    rand_out = (b-a)*rand(nrows,ncols) + a;
else
    rand_out = (b-a)*rand() + a;
end
end