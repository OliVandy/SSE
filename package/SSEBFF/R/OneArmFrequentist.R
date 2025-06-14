One_Arm_Freq_theory = function(alpha, beta, theta, theta_star) {
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)         # Z-score for desired power
  numerator = (z_alpha + z_beta)^2 * theta * (1 - theta)
  denominator = (theta - theta_star)^2
  n = ceiling(numerator / denominator)  # Round up to nearest whole number
  return(n)
}

One_Arm_t_test_sim = function(alpha, beta, theta, theta_star, sigma = 1, nmin = 10, nmax = 5000, sims = 10000) {
  t_alpha = qt(1 - alpha, df = nmin - 1)  # conservative df guess for early threshold
  
  for (n in seq(nmin, nmax)) {
    df = n - 1
    t_alpha = qt(1 - alpha, df = df)
    
    # Simulate under H0
    null_data = matrix(rnorm(n * sims, mean = theta_star, sd = sigma), nrow = sims)
    null_means = rowMeans(null_data)
    null_sds = apply(null_data, 1, sd)
    t_null = (null_means - theta_star) / (null_sds / sqrt(n))
    type1_error = mean(t_null > t_alpha)
    
    # Simulate under H1
    alt_data = matrix(rnorm(n * sims, mean = theta, sd = sigma), nrow = sims)
    alt_means = rowMeans(alt_data)
    alt_sds = apply(alt_data, 1, sd)
    t_alt = (alt_means - theta_star) / (alt_sds / sqrt(n))
    type2_error = mean(t_alt < t_alpha)
    
    if (type1_error <= alpha && type2_error <= beta) {
      return(n)
    }
  }
  return(NA)  # in case no n satisfies the condition
}