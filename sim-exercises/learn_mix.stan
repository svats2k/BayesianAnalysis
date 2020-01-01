// Learning a 2 gaussian mixture distribution

data {
  int<lower=2> N;
  real y[N];
}

parameters {
  real mu[2];
  real<lower=0> sigma[2];
  real<lower=0, upper=1> theta;
}

model {
  target += normal_lpdf(mu | 0,5);
  target += normal_lpdf(sigma | 0, 5);
  target += beta_lpdf(theta | 2,2);
  for(n in 1:N) {
    target += log_mix(
      theta,
      normal_lpdf(y[n] | mu[1], sigma[1]),
      normal_lpdf(y[n] | mu[2], sigma[2])
    );
  }
}
