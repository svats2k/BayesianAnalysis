// Building a hierarchical model
data {
  int n; // number of objects to remember
  int ns; // number of subjects
  int nt; // number of observation points
  int t[nt]; // time steps at which the memory retention was recorded
  int k[ns-1, nt-1]; // number of success counts
}

parameters {
  vector<lower=0, upper=1>[ns] alpha; // rate of information decap with time
  vector<lower=0, upper=1>[ns] beta; // baseline level of remembering

  real<lower=0, upper=1> alphamu;
  real<lower=0, upper=1> betamu;
  real<lower=0> alphasigma;
  real<lower=0> betasigma;
}

// retention for each person at each time period
transformed parameters {
  matrix<lower=0, upper=1>[ns, nt] theta;
  for (i in 1:ns) {
    for (j in 1:nt) {
      theta[i, j] = fmin(1, exp(-alpha[i]*t[j]) + beta[i]);
    }
  }
}

model {

  // Hierarchical Priors
  target += beta_lpdf(alphamu | 1, 1);
  target += beta_lpdf(betamu | 1, 1);
  target += gamma_lpdf(alphasigma | 1e-3, 1e-3);
  target += gamma_lpdf(betasigma | 1e-3, 1e-3);

  // Priors
  for (i in 1:ns) {
    target += normal_lpdf(alpha[i] | alphamu, alphasigma);
    target += normal_lpdf(beta[i] | betamu, betasigma);
  }

  // The likelihood
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
