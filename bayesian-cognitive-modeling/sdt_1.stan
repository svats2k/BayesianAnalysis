data {
  int<lower=0> k; // Number of datasets
  int<lower=0> h[k]; // number of signal trial hits
  int<lower=0> s[k]; // number of signal trials
  int<lower=0> n[k]; // number of noise trials
  int<lower=0> f[k]; // number of false alarms
}

parameters {
  vector[k] d; // Discriminability
  vector[k] c; // biases
}

transformed parameters {
  real<lower=0, upper=1> thetah[k];
  real<lower=0, upper=1> thetaf[k];

  for (i in 1:k) {
    thetah[i] = Phi(d[i]/2 - c[i]);
    thetaf[i] = Phi(-d[i]/2 - c[i]);
  }
}

model {
  target += normal_lpdf(d | 0, inv_sqrt(0.5)); // prior
  target += normal_lpdf(c | 0, inv_sqrt(2));

  for (i in 1:k) {
    target += binomial_lpmf(h[i] | s[i], thetah[i]);
    target += binomial_lpmf(f[i] | n[i], thetaf[i]);
  }
}
