data {
  int<lower=1> N;
  real y[N];
  real x[N];
  int<lower=1> N_pred;
  real xpred[N_pred];
}

transformed data {
  real y_stn[N];
  real x_stn[N];

  real mu_x;
  real sd_x;
  real mu_y;
  real sd_y;
  mu_x = mean(x);
  sd_x = sd(x);
  mu_y = mean(y);
  sd_y = sd(y);

//   y_stn = (y - mu_y) / sd_y;
//   x_stn = (x - mu_x) / sd_x;

  for (n in 1:N) {
    y_stn[n] = (y[n] - mu_y)/sd_y;
    x_stn[n] = (x[n] - mu_x)/sd_x;
  }
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

model {
  real mu;
  target += normal_lpdf(a | 0, 1);
  target += normal_lpdf(b | 0, 1);
  target += exponential_lpdf(sigma | 1);
  for (n in 1:N) {
    mu = a + b * x_stn[n];
    target += normal_lpdf(y_stn[n] | mu, sigma);
  }

  // a ~ normal(0,1);
  // b ~ normal(0, 0.5);
  // sigma ~ exponential(1);
  // y_stn ~ normal(a + b*x_stn, sigma);

}

generated quantities {
  real yrep[N];
  real yrep_stn[N];

  for (n in 1:N) {
    yrep_stn[n] = normal_rng(a + b*x_stn[n], sigma);
    yrep[n] = yrep_stn[n] * sd_y + mu_y;
  }
}
