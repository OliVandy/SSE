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

Freq_Count_Combined = function(alpha, beta, mu1, mu0, 
                               sig1 = 1, sig0 = 1, # dispersion parameter for gamma-poisson
                               type = "two.sample", 
                               nmin = 10, nmax = 5000, sims = 10000) {
  # t-test theoretical calculation (normal approximation)
  z_alpha = qnorm(1 - alpha)
  z_beta  = qnorm(1 - beta)
  if (type == "two.sample") {
    numerator = (z_alpha + z_beta)^2 * (mu1 + mu0)
    denominator = (mu1 - mu0)^2
    n_theory = ceiling(numerator / denominator)
  } else if (type == "one.sample") {
    numerator = (z_alpha + z_beta)^2 * mu0
    denominator = (mu1 - mu0)^2
    n_theory = ceiling(numerator / denominator)
  } else {
    warning("Wrong value, please choose from 'one.sample' or 'two.sample'")
    return(NULL)
  }
  
  # Simulation-based sample size estimation using Gamma-Poisson (Negative Binomial)
  for (n in seq(nmin, nmax)) {
    if (type == "one.sample") {
      # Null: mu = mu0; Alt: mu = mu1
      # Negative binomial: variance = mu + mu^2 / theta
      size0 = sig0
      prob0 = size0 / (size0 + mu0)
      size1 = sig1
      prob1 = size1 / (size1 + mu1)
      
      # Null: type I error
      counts_null = matrix(rnbinom(sims * n, size = size0, prob = prob0), nrow = sims)
      means_null = rowMeans(counts_null)
      sds_null = apply(counts_null, 1, sd)
      t_null = (means_null - mu0) / (sds_null / sqrt(n))
      t_alpha = qt(1 - alpha, df = n - 1)
      type1_error = mean(t_null > t_alpha)
      
      # Alt: type II error
      counts_alt = matrix(rnbinom(sims * n, size = size1, prob = prob1), nrow = sims)
      means_alt = rowMeans(counts_alt)
      sds_alt = apply(counts_alt, 1, sd)
      t_alt = (means_alt - mu0) / (sds_alt / sqrt(n))
      type2_error = mean(t_alt < t_alpha)
      
    } else if (type == "two.sample") {
      size0 = sig0
      prob0 = size0 / (size0 + mu0)
      size1 = sig1
      prob1 = size1 / (size1 + mu1)
      
      # Null
      x0_null = matrix(rnbinom(sims * n, size = size0, prob = prob0), nrow = sims)
      x1_null = matrix(rnbinom(sims * n, size = size0, prob = prob0), nrow = sims)
      m0_null = rowMeans(x0_null)
      m1_null = rowMeans(x1_null)
      v0_null = apply(x0_null, 1, var)
      v1_null = apply(x1_null, 1, var)
      se_null = sqrt(v0_null / n + v1_null / n)
      t_null = (m1_null - m0_null) / se_null
      t_alpha = qt(1 - alpha, df = n - 1)
      type1_error = mean(t_null > t_alpha)
      
      # Alt
      x0_alt = matrix(rnbinom(sims * n, size = size0, prob = prob0), nrow = sims)
      x1_alt = matrix(rnbinom(sims * n, size = size1, prob = prob1), nrow = sims)
      m0_alt = rowMeans(x0_alt)
      m1_alt = rowMeans(x1_alt)
      v0_alt = apply(x0_alt, 1, var)
      v1_alt = apply(x1_alt, 1, var)
      se_alt = sqrt(v0_alt / n + v1_alt / n)
      t_alt = (m1_alt - m0_alt) / se_alt
      t_alpha_alt = qt(1 - alpha, df = n - 1)
      type2_error = mean(t_alt < t_alpha_alt)
    }
    if (type1_error <= alpha && type2_error <= beta) {
      return(list(n_theory = n_theory, n_sim = n))
    }
  }
  return(list(n_theory = n_theory, n_sim = NA))
}