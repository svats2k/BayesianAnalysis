// Simple mixture model

data {
  real<lower=0, upper=1> lambda;
  real<lower=0> sigma[2];
  real mu[2];
}

parameters {
  real y;
}

model {
  target += log_sum_exp(
    log(lambda) + normal_lpdf(y | mu[1], sigma[1]),
    log(1 - lambda) + normal_lpdf(y | mu[2], sigma[2])
  );
}
