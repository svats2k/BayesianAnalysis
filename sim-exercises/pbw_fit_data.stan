data {
    int <lower=0> N; /// Number of observations
    int y[N];// Count at each observation
}

parameters {
  real<lower=0> lambda; // Poison intensity
}

model {
  target += normal_lpdf(lambda | 0, 6.44787); // Prior observation
  target += poisson_lmdf(y | lambda); // likelihood function
}
