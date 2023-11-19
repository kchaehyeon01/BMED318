function filter = butterworthLPF(f, cutoff, n)
    cof = pi*cutoff;
    filter = 1./(1+((f/cof).^(2*n)));
end