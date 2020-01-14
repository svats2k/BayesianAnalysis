// Retention With Full Individual Differences
data {
  int ns;
  int nt;
  int k[ns - 1,nt - 1];  // excluding missing values
  int t[nt];
  int n;
}
parameters {
  vector<lower=0,upper=1>[ns] alpha;
  vector<lower=0,upper=1>[ns] beta;
}
transformed parameters {
  matrix<lower=0,upper=1>[ns,nt] theta;

  // Retention Rate At Each Lag For Each Subject Decays Exponentially
  for (i in 1:ns)
    for (j in 1:nt)
      theta[i,j] = fmin(1.0, exp(-alpha[i] * t[j]) + beta[i]);
}
model {
  // Priors
  alpha ~ beta(1, 1);  // can be removed
  beta ~ beta(1, 1);  // can be removed

  // Observed Data
  for (i in 1:(ns - 1))
    for (j in 1:(nt - 1))
      k[i,j] ~ binomial(n, theta[i,j]);
}
generated quantities {
  int<lower=0,upper=n> predk[ns,nt];

  // Predicted Data
  for (i in 1:ns)
    for (j in 1:nt)
      predk[i,j] = binomial_rng(n, theta[i,j]);
}
