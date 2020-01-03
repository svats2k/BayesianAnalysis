data {
  real<lower=0, upper=1> theta;
  int<lower=1> N; 
}

generated quantities {
  vector[N] y;
  for (i in 1:N) {
    y[i] = bernoulli_rng(theta);
  }
  // int y[N] = bernoulli_rng(theta);
}
