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

Two_Arm_Freq_theory = function(alpha, beta, theta1, theta0) {
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)              # Z-score for desired power
  numerator = (z_alpha + z_beta)^2 * (theta1 * (1 - theta1) + theta0 * (1 - theta0))
  denominator = (theta1 - theta0)^2
  n = ceiling(numerator / denominator)  # Round up to nearest whole number
  return(n)
}

Two_Arm_Freq_cont = function(alpha, beta, theta1, theta0, nmin = 10, nmax = 5000, sims = 10000) {
  z_alpha = qnorm(1 - alpha)
  for (n in seq(nmin, nmax)) {
    # Simulate trials under H0
    null_trials1 = rbinom(sims, n, theta0)  
    null_trials0 = rbinom(sims, n, theta0) 
    null_means1 = null_trials1 / n          
    null_means0 = null_trials0 / n          
    null_dif = null_means1 - null_means0  
    null_std = sqrt((null_means1 * (1 - null_means1) / n + (null_means0 * (1 - null_means0)) / n))  # Standard error
    z_null = null_dif / null_std           # Z-score under H0
    type1_error = mean(z_null > z_alpha)   # Type I error rate      
    
    # Simulate trials under H1 (alternative hypothesis: theta1 > theta0)
    alt_trials1 = rbinom(sims, n, theta1)  # Treatment arm under H1
    alt_trials0 = rbinom(sims, n, theta0)  # Control arm under H1
    alt_means1 = alt_trials1 / n           # Sample mean for treatment arm
    alt_means0 = alt_trials0 / n           # Sample mean for control arm
    alt_dif = alt_means1 - alt_means0      # Difference in means
    alt_std = sqrt((alt_means1 * (1 - alt_means1) / n + (alt_means0 * (1 - alt_means0)) / n))  # Standard error
    z_alt = alt_dif / alt_std             # Z-score under H1
    type2_error = mean(z_alt < z_alpha)   # Type II error rate
    
    # Check if both Type I and Type II error criteria are met
    if (type1_error <= alpha && type2_error <= beta) {
      return(n)  # Return the required sample size per arm
    }
  }
  
  # If no suitable sample size is found within the range
  return(paste("Sample size exceeds maximum limit (nmax =", nmax, ")"))
}