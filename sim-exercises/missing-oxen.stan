data {
    int N_children; // number of children
    int tea[N_children]; // [0,0] observed drinking tea
    int s[N_children]; // [0, 1, -1] stabled ox
}

parameters {
    real<lower=0, upper=1> p_drink;
    real<lower=0, upper=1> p_cheat;
    real<lower=0, upper=1> sigma;
}

model {
    // priors
    target += beta_lpdf(p_cheat | 2, 2);
    target += beta_lpdf(p_drink | 2,2);
    target += beta_lpdf(sigma | 2,2);

    // p_cheat ~ beta(2,2);
    // p_drink ~ beta(2,2);
    // sigma ~ beta(2,2);

    for (i in 1:N_children) {
        if (s[i] == -1) {
            // un-observed ox
            // log(sigma*bernoulli(tea[i]|p_drink) + (1-sigma)*bernoulli(tea[i]|p_cheat))
            // Averaging over our ignorance
            target += log_mix(
                sigma,
                bernoulli_lpmf(tea[i] | p_drink),
                bernoulli_lpmf(tea[i] | p_cheat));
        } else {
            // ox observed
            tea[i] ~ bernoulli(s[i]*p_drink + (1-s[i])*p_cheat);
            s[i] ~ bernoulli(sigma);
        }
    }
}

generated quantities{
    vector[N_children] s_impute;
}

