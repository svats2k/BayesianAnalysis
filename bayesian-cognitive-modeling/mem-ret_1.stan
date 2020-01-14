data {
  int n; // number of objects to remember
  int ns; // number of subjects
  int nt; // number of observation points
  int t[nt]; // time steps at which the memory retention was recorded
  int k[ns-1, nt-1]; // number of success counts
}

parameters {
  real<lower=0, upper=1> alpha; // rate of information decap with time
  real<lower=0, upper=1> beta; // baseline level of remembering
}

// retention for each person at each time period
transformed parameters {
  matrix<lower=0, upper=1>[ns, nt] theta;
  for (i in 1:ns) {
    for (j in 1:nt) {
      // theta[i,j] = fmin(0.9999999, exp(-alpha*t[j]) + beta);
      theta[i,j] = fmin(1, exp(-alpha*t[j]) + beta);
      // theta[i,j] = exp(-alpha*t[j]) + beta;
    }
  }
}

model {
  // target += beta_lpdf(alpha | 1,1);
  // target += beta_lpdf(beta | 1,1);

  for (i in 1:(ns-1)) {
    for (j in 1:(nt-1)) {
      target += binomial_lpmf(k[i,j] | n, theta[i,j]);
    }
  }
}

generated quantities {
  int<lower=0, upper=n> predk[ns, nt];

  // Predicted data
  for (i in 1:ns) {
    for (j in 1:nt) {
      predk[i, j] = binomial_rng(n, theta[i,j]);
    }
  }
}
