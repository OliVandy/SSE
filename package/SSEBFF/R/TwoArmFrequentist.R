Two_Arm_Freq_theory = function(alpha, beta, theta1, theta0) {
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)              # Z-score for desired power
  numerator = (z_alpha + z_beta)^2 * (theta1 * (1 - theta1) + theta0 * (1 - theta0))
  denominator = (theta1 - theta0)^2
  n = ceiling(numerator / denominator)  # Round up to nearest whole number
  return(n)
}

Two_Arm_t_test_sim = function(alpha, beta, mu1, mu0, sigma1 = 1, sigma0 = 1, 
                               nmin = 10, nmax = 5000, sims = 10000) {
  for (n in seq(nmin, nmax)) {
    # Simulate H0: mu1 == mu0
    x0_null = matrix(rnorm(sims * n, mean = mu0, sd = sigma0), nrow = sims)
    x1_null = matrix(rnorm(sims * n, mean = mu0, sd = sigma1), nrow = sims)
    
    mean0_null = rowMeans(x0_null)
    mean1_null = rowMeans(x1_null)
    var0_null = apply(x0_null, 1, var)
    var1_null = apply(x1_null, 1, var)
    
    se_null = sqrt(var0_null / n + var1_null / n)
    t_null = (mean1_null - mean0_null) / se_null
    
    df_null = ( (var0_null/n + var1_null/n)^2 ) / 
      ( (var0_null^2) / (n^2 * (n - 1)) + (var1_null^2) / (n^2 * (n - 1)) )
    
    t_alpha = qt(1 - alpha, df = df_null)
    type1_error = mean(t_null > t_alpha)
    
    # Simulate H1: mu1 > mu0
    x0_alt = matrix(rnorm(sims * n, mean = mu0, sd = sigma0), nrow = sims)
    x1_alt = matrix(rnorm(sims * n, mean = mu1, sd = sigma1), nrow = sims)
    
    mean0_alt = rowMeans(x0_alt)
    mean1_alt = rowMeans(x1_alt)
    var0_alt = apply(x0_alt, 1, var)
    var1_alt = apply(x1_alt, 1, var)
    
    se_alt = sqrt(var0_alt / n + var1_alt / n)
    t_alt = (mean1_alt - mean0_alt) / se_alt
    
    df_alt = ( (var0_alt/n + var1_alt/n)^2 ) / 
      ( (var0_alt^2) / (n^2 * (n - 1)) + (var1_alt^2) / (n^2 * (n - 1)) )
    
    t_alpha_alt = qt(1 - alpha, df = df_alt)
    type2_error = mean(t_alt < t_alpha_alt)
    
    if (type1_error <= alpha && type2_error <= beta) {
      return(n)
    }
  }
  return(NA)  # if no suitable n is found
}