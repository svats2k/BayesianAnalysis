parameters {
  int <lower=0, upper=1> y ;
}

model {
  y ~ bernoulli(0.6);
}
