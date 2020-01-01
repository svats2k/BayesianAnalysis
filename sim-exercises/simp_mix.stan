// This is a simple stan model to generate data points from a mixture distribution
// depending on probability value, we can draw from a N(20, 5) vs N(200, 5) distribution

parameters {
  real y;
}

transformed parameters {
  real lamda = 0.5;
}

model {
  target += log_mix(
    lamda,
    normal_lpdf(y | -2, 0.1),
    normal_lpdf(y | 2, 0.1)
  );
}
