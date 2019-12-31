data {
  int<lower=1> N;
  int<lower=1> max_trials;
  int num_success[N];
}

parameters {
  real<lower=0, upper=1> p;
} 

model {
  p ~ beta(1,1);
  num_success ~ binomial(max_trials, p) ;
}
