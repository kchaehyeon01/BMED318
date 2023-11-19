function omat = func1(imat)
  omat = zeros(size(imat));
  meanval = mean(imat, 'all');
  larger_idx = find(imat >= meanval);
  omat(larger_idx) = imat(larger_idx);
end