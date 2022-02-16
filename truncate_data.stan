//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//


data {
  int<lower=0> N_obs;
  int<lower=0> N_cens;
  int<lower=0> K;  // Number of predictors
  matrix[N_obs, K] X_obs; // Observed predictor matrix
  matrix[N_cens, K] X_cens; // Censored predictor matrix
  real y_obs[N_obs];
  real<lower=max(y_obs)> U;
}
parameters {
  real<lower=U> y_cens[N_cens];
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  y_obs ~ normal(X_obs * beta, sigma);
  y_cens ~ normal(X_cens * beta, sigma);
}

