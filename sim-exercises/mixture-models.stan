/*
Testing out cummulative and softmax operation

data {
  vector[3] x;
}

generated quantities {
  vector[3] y_cumm;
  vector[3] y_smax;
  y_cumm = cumulative_sum(x);
  y_smax = softmax(x);
}
*/

/*
data {
  int<lower=1> N;
}

generated quantities {
  simplex[3] theta = [0.5, 0.3, 0.2]';
  int y[N];
  for (n in 1:N) {
    y[n] = categorical_rng(theta);  
  }
}
*/

/*
data {
  int<lower=1> N_params;
  vector[N_params] alpha;
  int<lower=1> num_samples;
}

generated quantities {
  matrix[num_samples] theta = dirichlet_rng(rep_vector(alpha, num_samples));
}
*/

 data {
   real<lower = 0> alpha;
   int<lower = 1> num_param_dims;
   int<lower=0> num_dist_draws_per_pgrp;
   int<lower=1> num_simplex_per_dist;
   int<lower=1> num_draws_from_simplex;
   real mu[num_param_dims];
   real<lower=0> sigma[num_param_dims];
 }
 
 transformed data {
   int num_final_rows = num_dist_draws_per_pgrp*num_simplex_per_dist;
 }
 
 generated quantities {
   matrix[num_dist_draws_per_pgrp, num_param_dims] theta_mat;
   int final_samples[num_dist_draws_per_pgrp, num_draws_from_simplex];
   matrix[num_dist_draws_per_pgrp, num_draws_from_simplex] sim_samples;

   int l_idx;
   int r_idx;
   
   // Generating the distributions
   for (i in 1:num_dist_draws_per_pgrp) {
     theta_mat[i] = dirichlet_rng(rep_vector(alpha, num_param_dims))';
   }
   
   // Generating (Indicator) samples for the distributions
   for (i in 1:num_dist_draws_per_pgrp) {
     for (j in 1:num_draws_from_simplex) {
       final_samples[i,j] = categorical_rng(theta_mat[i]');
     }
   }
   
   // Drawing from a gaussian family
   for (i in 1:num_dist_draws_per_pgrp) {
     for (j in 1:num_draws_from_simplex) {
       sim_samples[i,j] = normal_rng(mu[final_samples[i,j]], sigma[final_samples[i,j]]);
     }
   }
 }
 