Post_Prob_Bayes = function(type = "one.sample", 
                           n, theta0 = NULL, delta = NULL, 
                           outcome = NULL, e = NULL, 
                           a = 0.5, b = 0.5, sig = 1,
                           Y_t = NULL, Y_c = NULL,
                           a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
                           q = 0.5, sim = 10000) {
  
  # --- Input Checks ---
  if (!(type %in% c("one.sample", "two.sample"))) {
    stop("Invalid 'type'. Choose either 'one.sample' or 'two.sample'.")
  }
  if (!is.numeric(n) || n <= 0) {
    stop("Please enter an integer n that is greater than 0.")
  }
  if (!is.double(q) || q <= 0 || q >= 1) {
    stop("Please enter a q that is a double between 0 and 1.")
  }
  
  # === ONE SAMPLE POSTERIOR ===
  if (type == "one.sample") {
    if (is.null(outcome) || !(outcome %in% c(1, 2))) {
      stop("Please enter a valid outcome type: 1 = binary, 2 = continuous.")
    }
    if (is.null(theta0)) stop("theta0 is required for one.sample.")
    
    prob <- switch(as.character(outcome),
                   "1" = {
                     if (is.null(e) || e < 0 || e > 1) {
                       stop("Please enter an evidence level 'e' between 0 and 1 for binary outcome.")
                     }
                     post_a <- a + floor(e * n)
                     post_b <- b + n - floor(e * n)
                     pbeta(theta0, post_a, post_b, lower.tail = FALSE)
                   },
                   "2" = {
                     if (is.null(e)) stop("Please provide effect size 'e' for continuous outcome.")
                     post_sig2 <- 1 / (1 / (b^2) + n / (sig^2))
                     post_mu <- post_sig2 * ((a / (b^2)) + ((n * e) / (sig^2)))
                     z_val <- (theta0 - post_mu) / sqrt(post_sig2)
                     pnorm(z_val, lower.tail = FALSE)
                   })
  }
  
  # === TWO SAMPLE POSTERIOR (EXTENDED) ===
  if (type == "two.sample") {
    if (is.null(Y_t) || is.null(Y_c) || is.null(delta)) {
      stop("For type = 'two.sample', you must provide Y_t, Y_c, and delta.")
    }
    if (is.null(outcome) || !(outcome %in% c(1, 2))) {
      stop("Please enter a valid outcome type: 1 = binary, 2 = continuous.")
    }
    
    prob <- switch(as.character(outcome),
                   "1" = {
                     if (is.null(e) || e < 0 || e > 1) {
                       stop("Please enter an evidence level 'e' between 0 and 1 for binary outcome.")
                     }
                     pt_post <- rbeta(sim, a1 + Y_t, b1 + n - Y_t)
                     pc_post <- rbeta(sim, a2 + Y_c, b2 + n - Y_c)
                     pd_post <- pt_post - pc_post
                     mean(pd_post > delta)
                   },
                   "2" = {
                     sig2_t <- sig^2 / n
                     sig2_c <- sig^2 / n
                     post_var <- 1 / (1 / (b1^2) + 1 / sig2_c) + 1 / (1 / (b2^2) + 1 / sig2_t)
                     mu_t <- (a2 / (b2^2) + Y_t / sig2_t) / (1 / (b2^2) + 1 / sig2_t)
                     mu_c <- (a1 / (b1^2) + Y_c / sig2_c) / (1 / (b1^2) + 1 / sig2_c)
                     diff_post <- rnorm(sim, mean = mu_t - mu_c, sd = sqrt(post_var))
                     mean(diff_post > delta)
                   })
  }
  
  # === Return Adjusted Posterior Probability ===
  if (q == 0.5) {
    return(prob)
  } else {
    A2Pm1 = (2 * q - 1) * prob
    return((q * prob) / (1 - q + A2Pm1))
  }
}

BESS_unified = function(theta0, c, e, type = "one.sample", 
                        outcome = NULL, a = NULL, b = NULL, sig = 1,
                        a1 = NULL, b1 = NULL, a2 = NULL, b2 = NULL,
                        q = 0.5, sim = 10000, n_min = 5, n_max = 100) {
  
  if (!(type %in% c("one.sample", "two.sample"))) stop("Type must be 'one.sample' or 'two.sample'.")
  
  if (type == "one.sample") {
    if (is.null(outcome)) stop("Please specify outcome type for one.sample (1 = binary, 2 = continuous).")
    if (!(outcome %in% c(1, 2))) stop("Only outcome = 1 (binary) and outcome = 2 (continuous) are supported.")
    
    if (outcome == 1) {
      result <- One_Arm_BESS(theta0 = theta0, c = c, e = e,
                             outcome = 1, a = a, b = b,
                             q = q, sig = sig, n_min = n_min, n_max = n_max)
    } else if (outcome == 2) {
      result <- One_Arm_Normal_Sample_Size(threshold = theta0, crit = c, 
                                           effect_size = e, prior_mean = a, prior_sd = b,
                                           min_n = n_min, max_n = n_max,
                                           quant = q, sigma = sig)
    }
    
    return(result)
  }
  
  # === TWO SAMPLE ===
  if (type == "two.sample") {
    if (is.null(outcome)) stop("Please specify outcome type for two.sample (1 = binary, 2 = continuous).")
    if (!(outcome %in% c(1, 2))) stop("Only outcome = 1 (binary) and outcome = 2 (continuous) are supported.")
    
    n_seq <- seq(n_min, n_max)
    
    if (outcome == 1) {
      # === Two-Arm Binary Sample Size ===
      xi_list <- yd_n_list <- y1_list <- y2_list <- c()
      ss <- yd_n <- NA
      
      yd_v_max <- floor(e * n_max)
      min_xi_max <- Two_Arm_Find_Min_Xi(yd_v_max, n_max, theta0, a1, b1, a2, b2, q, sim)
      
      if (min_xi_max$min_xi < c) {
        ss <- n_max
        yd_n <- yd_v_max
        return(list(n = ss, yd = yd_n, n_seq = n_seq, vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
      }
      
      for (n in n_seq) {
        yd_v <- floor(e * n)
        min_xi <- Two_Arm_Find_Min_Xi(yd_v, n, theta0, a1, b1, a2, b2, q, sim)
        
        if (min_xi$min_xi >= c && is.na(ss)) {
          ss <- n
          yd_n <- yd_v
          break
        }
        xi_list <- c(xi_list, min_xi$min_xi)
        yd_n_list <- c(yd_n_list, yd_v)
        y1_list <- c(y1_list, min_xi$y1)
        y2_list <- c(y2_list, min_xi$y2)
      }
      
      if (is.na(ss)) {
        ss <- n_max
        yd_n <- floor(e * ss)
      }
      
      return(list(n = ss, yd = yd_n, n_seq = n_seq, vec = xi_list,
                  yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
    }
    
    if (outcome == 2) {
      # === Two-Arm Continuous Sample Size (via simulation) ===
      prob_vec <- rep(NA, length(n_seq))
      
      for (i in seq_along(n_seq)) {
        n <- n_seq[i]
        sig2_t <- sig^2 / n
        sig2_c <- sig^2 / n
        
        post_var <- 1 / (1 / (b1^2) + 1 / sig2_c) + 1 / (1 / (b2^2) + 1 / sig2_t)
        mu_t <- (a2 / (b2^2) + e / sig2_t) / (1 / (b2^2) + 1 / sig2_t)
        mu_c <- (a1 / (b1^2) + 0 / sig2_c) / (1 / (b1^2) + 1 / sig2_c)
        
        diff_post <- rnorm(sim, mean = mu_t - mu_c, sd = sqrt(post_var))
        prob_vec[i] <- ifelse(q == 0.5, mean(diff_post > theta0),
                              {
                                raw <- mean(diff_post > theta0)
                                A2Pm1 <- (2 * q - 1) * raw
                                (q * raw) / (1 - q + A2Pm1)
                              })
      }
      
      if (prob_vec[1] >= c) return("Can lower n_min.")
      if (tail(prob_vec, 1) < c) return("Need to increase max sample size!")
      
      n_result <- n_seq[which(prob_vec >= c)[1]]
      return(list(n = n_result, n_seq = n_seq, vec = prob_vec))
    }
  }
}

BESS_SSR_Design = function(type = "two.sample",
                           theta_H = NULL, theta_L = NULL, theta_s,
                           c, c_s, n0,
                           outcome = NULL,
                           a = 0.5, b = 0.5, sig = 1,
                           a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
                           q = 0.5, n_min = 1, n_max = 200,
                           cap = FALSE, n_cap = 200) {
  
  if (!(type %in% c("one.sample", "two.sample"))) stop("type must be 'one.sample' or 'two.sample'")
  if (is.null(outcome) || !(outcome %in% c(1, 2, 3))) stop("Specify outcome: 1 = binary, 2 = continuous, 3 = count.")
  
  # Placeholders
  y_H <- y_L <- y_H_s <- y_L_s <- NULL
  y <- y_s <- NULL
  e_s <- pH1 <- pH1_s <- n_s <- bess_dec <- bess_int_dec <- NA
  
  ### === ONE SAMPLE DESIGN === ###
  if (type == "one.sample") {
    if (outcome == 1) y <- rbinom(n0, 1, theta_H)
    if (outcome == 2) y <- rnorm(n0, mean = theta_H, sd = sig)
    if (outcome == 3) y <- rpois(n0, lambda = theta_H)
    
    e_obs <- if (outcome == 3) sum(y) / n0 else mean(y)
    
    # Posterior probability for interim
    if (outcome == 3) {
      pH1 <- One_Arm_Count_Post_Prob(count = sum(y), n = n0, threshold = theta_s,
                                     a = a, b = b, quant = q)
    } else {
      pH1 <- Post_Prob_Bayes(type = "one.sample", n = n0, theta0 = theta_s,
                             outcome = outcome, e = e_obs,
                             a = a, b = b, sig = sig, q = q)
    }
    
    bess_int_dec <- ifelse(pH1 >= c, 1, ifelse(pH1 <= c_s, 0, 2))
    
    if (bess_int_dec == 2) {
      # Update prior
      if (outcome == 1) {
        a_ip <- a + sum(y)
        b_ip <- b + n0 - sum(y)
        post_mean <- a_ip / (a_ip + b_ip)
        e_s <- post_mean
        # Use binary BESS
        ss_result <- BESS_binary(margin = theta_s, threshold = c, delta = e_s,
                                 min_n = n_min, max_n = n_max,
                                 alpha1 = a_ip, beta1 = b_ip,
                                 prior_weight = 1, iterations = 10000)
        n_s <- ss_result$n
      } else if (outcome == 2) {
        a_ip <- mean(y)
        b_ip <- sig / sqrt(n0)
        post_mean <- a_ip
        e_s <- post_mean
        # Use continuous BESS
        ss_result <- BESS_continuous(margin = theta_s, threshold = c, delta = e_s,
                                     min_n = n_min, max_n = n_max,
                                     alpha = a_ip, beta = b_ip, sig = sig, q = q)
        n_s <- ss_result$n
      } else {
        a_ip <- a + sum(y)
        b_ip <- b + n0
        post_mean <- a_ip / b_ip
        e_s <- post_mean
        # Use count BESS
        ss_result <- One_Arm_Count_Sample_Size(threshold = theta_s, crit = c, effect_size = e_s,
                                               a = a_ip, b = b_ip, min_n = n_min, max_n = n_max, quant = q)
        n_s <- ss_result$n
      }
      if (cap && n_s > n_cap - n0) n_s <- n_cap - n0
      
      if (outcome == 1) y_s <- rbinom(n_s, 1, theta_H)
      if (outcome == 2) y_s <- rnorm(n_s, mean = theta_H, sd = sig)
      if (outcome == 3) y_s <- rpois(n_s, lambda = theta_H)
      
      if (outcome == 3) {
        pH1_s <- One_Arm_Count_Post_Prob(count = sum(y_s), n = n_s, threshold = theta_s,
                                         a = a_ip, b = b_ip, quant = q)
      } else {
        pH1_s <- Post_Prob_Bayes(type = "one.sample", n = n_s, theta0 = theta_s,
                                 outcome = outcome, e = if (outcome == 3) sum(y_s) / n_s else mean(y_s),
                                 a = a_ip, b = b_ip, sig = sig, q = q)
      }
      bess_dec <- ifelse(pH1_s >= c, 1, 0)
    }
    
    return(list(
      y_n0 = y, pH1_int = pH1, bess_int_dec = bess_int_dec,
      y_ns = y_s, e_s = e_s, n_s = n_s,
      pH1_s = pH1_s, bess_fin_dec = bess_dec
    ))
  }
  
  ### === TWO SAMPLE DESIGN === ###
  if (type == "two.sample") {
    if (outcome == 1) {
      y_H <- rbinom(n0, 1, theta_H)
      y_L <- rbinom(n0, 1, theta_L)
    } else if (outcome == 2) {
      y_H <- rnorm(n0, mean = theta_H, sd = sig)
      y_L <- rnorm(n0, mean = theta_L, sd = sig)
    } else {
      y_H <- rpois(n0, lambda = theta_H)
      y_L <- rpois(n0, lambda = theta_L)
    }
    
    e_obs <- if (outcome == 3) (sum(y_L) - sum(y_H)) / n0 else mean(y_L) - mean(y_H)
    
    # Posterior probability for interim
    if (outcome == 3) {
      pH1 <- Two_Arm_Count_Post_Prob(
        count_treat = sum(y_H), count_ctrl = sum(y_L), sample_size = n0,
        threshold = -theta_s,
        a_t = a2, b_t = b2, a_c = a1, b_c = b1, quant = q
      )
    } else {
      pH1 <- Post_Prob_Bayes(type = "two.sample", n = n0,
                             delta = -theta_s, Y_t = sum(y_H), Y_c = sum(y_L),
                             a1 = a1, b1 = b1, a2 = a2, b2 = b2,
                             q = q, sim = 10000)
    }
    
    bess_int_dec <- ifelse(pH1 >= c, 1, ifelse(pH1 <= c_s, 0, 2))
    
    if (bess_int_dec == 2) {
      if (outcome == 1) {
        a1_ip <- a1 + sum(y_L)
        b1_ip <- b1 + n0 - sum(y_L)
        a2_ip <- a2 + sum(y_H)
        b2_ip <- b2 + n0 - sum(y_H)
        post_mean_L <- a1_ip / (a1_ip + b1_ip)
        post_mean_H <- a2_ip / (a2_ip + b2_ip)
        e_s <- post_mean_L - post_mean_H
        ss_result <- Two_Arm_BESS_Binary(margin = -theta_s, threshold = c, delta = e_s,
                                         min_n = n_min, max_n = n_max,
                                         a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
        n_s <- ss_result$n
      } else if (outcome == 2) {
        post_mean_L <- mean(y_L)
        post_mean_H <- mean(y_H)
        a1_ip <- post_mean_L
        b1_ip <- sig / sqrt(n0)
        a2_ip <- post_mean_H
        b2_ip <- sig / sqrt(n0)
        e_s <- post_mean_L - post_mean_H
        ss_result <- Two_Arm_BESS_Continuous(margin = -theta_s, threshold = c, delta = e_s,
                                             min_n = n_min, max_n = n_max,
                                             a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
        n_s <- ss_result$n
      } else {
        # outcome == 3 (count)
        a1_ip <- a1 + sum(y_L)
        b1_ip <- b1 + n0
        a2_ip <- a2 + sum(y_H)
        b2_ip <- b2 + n0
        post_mean_L <- a1_ip / b1_ip
        post_mean_H <- a2_ip / b2_ip
        e_s <- post_mean_L - post_mean_H
        ss_result <- Two_Arm_Count_Sample_Size(
          threshold = -theta_s, crit = c, effect_size = e_s,
          a_t = a2_ip, b_t = b2_ip, a_c = a1_ip, b_c = b1_ip,
          min_n = n_min, max_n = n_max, quant = q
        )
        n_s <- ss_result$n
      }
      if (cap && n_s > n_cap - n0) n_s <- n_cap - n0
      
      if (outcome == 1) {
        y_H_s <- rbinom(n_s, 1, theta_H)
        y_L_s <- rbinom(n_s, 1, theta_L)
      } else if (outcome == 2) {
        y_H_s <- rnorm(n_s, mean = theta_H, sd = sig)
        y_L_s <- rnorm(n_s, mean = theta_L, sd = sig)
      } else {
        y_H_s <- rpois(n_s, lambda = theta_H)
        y_L_s <- rpois(n_s, lambda = theta_L)
      }
      
      if (outcome == 3) {
        pH1_s <- Two_Arm_Count_Post_Prob(
          count_treat = sum(y_H_s), count_ctrl = sum(y_L_s), sample_size = n_s,
          threshold = -theta_s, a_t = a2_ip, b_t = b2_ip, a_c = a1_ip, b_c = b1_ip, quant = q
        )
      } else {
        pH1_s <- Post_Prob_Bayes(type = "two.sample", n = n_s,
                                 delta = -theta_s, Y_t = sum(y_H_s), Y_c = sum(y_L_s),
                                 a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip,
                                 q = q, sim = 10000)
      }
      bess_dec <- ifelse(pH1_s >= c, 1, 0)
    }
    
    return(list(
      y_H_n0 = y_H, y_L_n0 = y_L, pH1_int = pH1, bess_int_dec = bess_int_dec,
      y_H_ns = y_H_s, y_L_ns = y_L_s, e_s = e_s, n_s = n_s,
      pH1_s = pH1_s, bess_fin_dec = bess_dec
    ))
  }
}

Count_Post_Prob = function(type = "one.sample",
                           threshold,
                           sample_size,
                           count_treat = NULL,
                           count_ctrl = NULL,
                           total_count = NULL,
                           a_t = 0.5, b_t = 0.5,
                           a_c = 0.5, b_c = 0.5,
                           quant = 0.5,
                           simulations = 10000) {
  
  if (!(type %in% c("one.sample", "two.sample"))) {
    stop("type must be 'one.sample' or 'two.sample'")
  }
  
  if (!is.numeric(sample_size) || sample_size <= 0) {
    stop("sample_size must be a positive number.")
  }
  
  if (!is.numeric(threshold)) {
    stop("threshold must be numeric.")
  }
  
  if (quant <= 0 || quant >= 1) {
    stop("quant must be between 0 and 1.")
  }
  
  # === One-Arm Posterior ===
  if (type == "one.sample") {
    if (is.null(total_count)) {
      stop("For one.sample, please provide total_count.")
    }
    
    shape_post <- a_t + total_count
    rate_post <- b_t + sample_size
    
    post_draws <- rgamma(simulations, shape = shape_post, rate = rate_post)
    post_prob <- mean(post_draws > threshold)
    
  } else {
    # === Two-Arm Posterior ===
    if (is.null(count_treat) || is.null(count_ctrl)) {
      stop("For two.sample, please provide count_treat and count_ctrl.")
    }
    
    shape_t <- a_t + count_treat
    rate_t <- b_t + sample_size
    post_t <- rgamma(simulations, shape_t, rate = rate_t)
    
    shape_c <- a_c + count_ctrl
    rate_c <- b_c + sample_size
    post_c <- rgamma(simulations, shape_c, rate = rate_c)
    
    diff <- post_t - post_c
    post_prob <- mean(diff > threshold)
  }
  
  if (quant == 0.5) {
    return(post_prob)
  } else {
    adjust <- (2 * quant - 1) * post_prob
    return((quant * post_prob) / (1 - quant + adjust))
  }
}

Count_Sample_Size = function(type = "one.sample",
                             threshold,
                             crit,
                             effect_size,
                             a_t = 0.5, b_t = 0.5,
                             a_c = 0.5, b_c = 0.5,
                             min_n = 5, max_n = 100,
                             quant = 0.5,
                             sim = 10000, s_reps = 1000) {
  
  if (!(type %in% c("one.sample", "two.sample"))) stop("type must be 'one.sample' or 'two.sample'.")
  if (!is.numeric(threshold) || !is.numeric(crit)) stop("threshold and crit must be numeric.")
  if (!is.numeric(effect_size) || effect_size <= 0) stop("effect_size must be a positive number.")
  
  n_seq <- seq(min_n, max_n)
  
  if (type == "one.sample") {
    prob_vec <- numeric(length(n_seq))
    count_vec <- numeric(length(n_seq))
    
    for (i in seq_along(n_seq)) {
      n <- n_seq[i]
      total_count <- floor(n * effect_size)
      prob_vec[i] <- Count_Post_Prob(type = "one.sample",
                                     threshold = threshold,
                                     sample_size = n,
                                     total_count = total_count,
                                     a_t = a_t, b_t = b_t,
                                     quant = quant,
                                     simulations = sim)
      count_vec[i] <- total_count
    }
    
    if (prob_vec[1] >= crit) return("Can lower min_n.")
    if (tail(prob_vec, 1) < crit) return("Need to increase max_n.")
    
    final_idx <- which(prob_vec >= crit)[1]
    return(list(n = n_seq[final_idx],
                yd = count_vec[final_idx],
                n_seq = n_seq,
                yd_vec = count_vec,
                prob_h1_vec = prob_vec))
  }
  
  if (type == "two.sample") {
    result <- Two_Arm_Gamma_Sample_Size(threshold = threshold,
                                        crit = crit,
                                        effect_size = effect_size,
                                        a_t = a_t, b_t = b_t,
                                        a_c = a_c, b_c = b_c,
                                        min_n = min_n, max_n = max_n,
                                        quant = quant,
                                        s_reps = s_reps, reps = sim)
    return(result)
  }
}