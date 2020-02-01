data {
  int<lower=1> N;
}

transformed data {
  real y[N];
  for (i in 1:N) y[i] = normal_rng(20, 5);
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  for (n in 1:N) target += normal_lpdf(y[n] | mu, sigma);
}

generated quantities {
  real yrep[N];
  for (n in 1:N) yrep[n] = normal_rng(mu, sigma);
}
