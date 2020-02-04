// Working through the tutorial http://nowave.it/pages/bayesian-changepoint-detection-with-r-and-stan.html

// data is just a time series of observations
data {
  int<lower=1> N;
  real D[N];
}

parameters {
  real mu1;
  real mu2;
  
  real<lower=0> sigma1;
  real<lower=0> sigma2;
}

// Next we need to mariginalize the discrete parameter, which models on which day (tau) the transition happened.
// here we are processing the parameters before calulating the posterior.
transformed parameters {
  vector[N] log_p;
  real mu;
  real sigma;
  log_p = rep_vector(-log(N),N);
  // log_p = rep_vector(0,N);
  for (tau in 1:N) {
    for (n in 1:N) {
      mu = n < tau ? mu1 : mu2;
      sigma = n < tau ? sigma1 : sigma2;
      log_p[tau] = log_p[tau] + normal_lpdf(D[n] | mu, sigma);
    }
  }
}

model {
  target += normal_lpdf(mu1 | 0, 100);
  target += normal_lpdf(mu2 | 0, 100);
  
  target += normal_lpdf(sigma1 | 0, 100);
  target += normal_lpdf(sigma2 | 0, 100);
    
  target += log_sum_exp(log_p);
}

generated quantities {
  int<lower=1, upper=N> tau;
  simplex[N] sp;
  sp = softmax(log_p);
  tau = categorical_rng(sp);
}