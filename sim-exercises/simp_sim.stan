parameters {
  real y[2];
}

model {
  y[1] ~ normal(10, 2);
  y[2] ~ normal(50,2);
}
