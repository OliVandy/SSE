One_Arm_Freq_theory <- function(alpha, beta, theta, theta_star) {
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)         # Z-score for desired power
  numerator = (z_alpha + z_beta)^2 * theta * (1 - theta)
  denominator = (theta - theta_star)^2
  n = ceiling(numerator / denominator)  # Round up to nearest whole number
  return(n)
}

One_Arm_Freq_cont = function(alpha, beta, theta, theta_star, nmin = 10, nmax = 5000, sims = 10000) {
  z_alpha = qnorm(1 - alpha)
  z_beta = qnorm(beta)
  for (n in seq(nmin, nmax)) {
    # Simulate trials under H0 (null hypothesis)
    null_trials = rbinom(sims, n, theta_star)
    null_means = null_trials / n #phat
    null_std = sqrt(null_means * (1 - null_means) / n)
    z_null = (null_means - theta_star) / null_std
    type1_error = mean(z_null > z_alpha) # Type I error rate
    
    # Simulate trials under H1 (alternative hypothesis)
    alt_trials = rbinom(sims, n, theta)#generates 10000 samples of n trials with success rate theta
    alt_means = alt_trials / n
    alt_std = sqrt(alt_means * (1 - alt_means) / n)
    z_alt = (alt_means - theta_star) / alt_std
    type2_error = mean(z_alt < z_alpha)
    
    
    # Check if both Type I and Type II error criteria are met
    if (type1_error <= alpha && type2_error <= beta) {
      return(n) 
    }
  }
}