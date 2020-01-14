data {
  int<lower=0> N;
  int<lower=0, upper=1> obs_data[N];
}

parameters {
  real<lower=0, upper=1> lambda;
}

model {
  target += beta_lpdf(lambda | 1,1);
  for (n in 1:N) {
    target += bernoulli_lpmf(obs_data[n] | lambda);
    // obs_data[n] ~ bernoulli_logit(lambda);
  }
}
