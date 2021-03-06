data {
  int N;
}

generated quantities {
  // simulate model configuration from the prior model
  real<lower=0> lambda = fabs(normal_rng(0, 6.44787));

  // simulate from this data
  int y[N];
  for (n in 1:N) y[n] = poisson_rng(lambda);
}
