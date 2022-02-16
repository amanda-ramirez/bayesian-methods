library(rethinking)
library(rstan)


data <- read.table("~/Documents/GitHub/bayesian-methods/Affair_data.txt",header=T)

#colnames(data) <- c("maritalhappiness","age","noyearsmarried","children","degreereligious","education","X1","occupation","husbandsoccupation","y", "X2", "X3")
summary(data)

# function that gives the density of normal distribution
# for given mean and sd, scaled to be on a count metric
# for the histogram: count = density * sample size * bin width

hist(data$y)
# on define number of bins:
hist(data$y, breaks = 2)
# one can use the same options for naming labels:
hist(data$y, xlab=  'y', ylab='Freq', main='Histogram of cheating')




# truncating --------------------------------------------------------------

y <- model.response(model.frame(y~marital.happiness + age + no.years.married,data))
X <- model.matrix(y~marital.happiness + age + no.years.married, data)

U = 5
X_cens = subset(X, y > U)
X_obs = subset(X,y < U)
y_obs = subset(y,y < U)

K <- ncol(X)

stan_output <-stan(file = "~/Documents/GitHub/bayesian-methods/truncate_data.stan",
                   data= list(
                     N_obs = nrow(X_obs),
                     N_cens = nrow(X_cens),
                     K = K,
                     X_obs = X_obs,
                     
                     X_cens = X_cens,
                     y_obs = y_obs, 
                     U=U
                   ),
                   iter = 100, 
                   warmup = 50,
                   chains = 2) 

summary(stan_output)



