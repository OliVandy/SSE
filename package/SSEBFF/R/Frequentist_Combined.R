Freq_Binary_theoretical = function(alpha, beta, theta1, theta0, type= "two.sample"){
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)              # Z-score for desired power
  if(type=="two.sample"){
    numerator = (z_alpha + z_beta)^2 * (theta1 * (1 - theta1) + theta0 * (1 - theta0))
    denominator = (theta1 - theta0)^2
    n = ceiling(numerator / denominator)  # Round up to nearest whole number
  }
  if(type=="one.sample"){
    numerator = (z_alpha + z_beta)^2 * theta1 * (1 - theta1)
    denominator = (theta1 - theta0)^2
    n = ceiling(numerator / denominator)  # Round up to nearest whole number
  }
  if(!(type %in% c("two.sample","one.sample"))){
    warning("Wrong value, please choose from one.sample or two.sample")
  }
  return(n)
}

t_test_sim_sample_size = function(alpha, beta, mu1, mu0, 
                                   sigma1 = 1, sigma0 = 1, 
                                   type = "two.sample", 
                                   nmin = 10, nmax = 5000, sims = 10000) {
  
  if (!(type %in% c("one.sample", "two.sample"))) {
    stop("Invalid 'type': must be 'one.sample' or 'two.sample'")
  }
  
  for (n in seq(nmin, nmax)) {
    
    if (type == "one.sample") {
      # Simulate one-sample t-test
      data_null = matrix(rnorm(sims * n, mean = mu0, sd = sigma1), nrow = sims)
      means_null = rowMeans(data_null)
      sds_null = apply(data_null, 1, sd)
      t_null = (means_null - mu0) / (sds_null / sqrt(n))
      t_alpha = qt(1 - alpha, df = n - 1)
      type1_error = mean(t_null > t_alpha)
      
      data_alt = matrix(rnorm(sims * n, mean = mu1, sd = sigma1), nrow = sims)
      means_alt = rowMeans(data_alt)
      sds_alt = apply(data_alt, 1, sd)
      t_alt = (means_alt - mu0) / (sds_alt / sqrt(n))
      type2_error = mean(t_alt < t_alpha)
      
    } else if (type == "two.sample") {
      # Simulate two-sample Welch t-test
      x0_null = matrix(rnorm(sims * n, mean = mu0, sd = sigma0), nrow = sims)
      x1_null = matrix(rnorm(sims * n, mean = mu0, sd = sigma1), nrow = sims)
      m0_null = rowMeans(x0_null)
      m1_null = rowMeans(x1_null)
      v0_null = apply(x0_null, 1, var)
      v1_null = apply(x1_null, 1, var)
      se_null = sqrt(v0_null / n + v1_null / n)
      t_null = (m1_null - m0_null) / se_null
      df_null = ( (v0_null/n + v1_null/n)^2 ) / 
        ( (v0_null^2) / (n^2 * (n - 1)) + (v1_null^2) / (n^2 * (n - 1)) )
      t_alpha = qt(1 - alpha, df = df_null)
      type1_error = mean(t_null > t_alpha)
      
      x0_alt = matrix(rnorm(sims * n, mean = mu0, sd = sigma0), nrow = sims)
      x1_alt = matrix(rnorm(sims * n, mean = mu1, sd = sigma1), nrow = sims)
      m0_alt = rowMeans(x0_alt)
      m1_alt = rowMeans(x1_alt)
      v0_alt = apply(x0_alt, 1, var)
      v1_alt = apply(x1_alt, 1, var)
      se_alt = sqrt(v0_alt / n + v1_alt / n)
      t_alt = (m1_alt - m0_alt) / se_alt
      df_alt = ( (v0_alt/n + v1_alt/n)^2 ) / 
        ( (v0_alt^2) / (n^2 * (n - 1)) + (v1_alt^2) / (n^2 * (n - 1)) )
      t_alpha_alt = qt(1 - alpha, df = df_alt)
      type2_error = mean(t_alt < t_alpha_alt)
    }
    
    if (type1_error <= alpha && type2_error <= beta) {
      return(n)
    }
  }
  
  return(NA)  # No valid sample size found
}