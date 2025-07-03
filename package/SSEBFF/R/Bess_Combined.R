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
    if (is.null(outcome) || !(outcome %in% c(1,2,3))) {
      stop("Please enter a valid outcome type: 1 = binary, 2 = continuous, 3 = count.")
    }
    if (is.null(e) || e < 0 || e > 1) {
      stop("Please enter an evidence level 'e' between 0 and 1.")
    }
    if (is.null(theta0)) stop("theta0 is required for one.sample.")
    
    prob <- switch(as.character(outcome),
                   "1" = {
                     post_a <- a + floor(e * n)
                     post_b <- b + n - floor(e * n)
                     pbeta(theta0, post_a, post_b, lower.tail = FALSE)
                   },
                   "2" = {
                     post_sig2 <- 1 / (1 / (b^2) + n / (sig^2))
                     post_mu <- post_sig2 * ((a / (b^2)) + ((n * e) / (sig^2)))
                     z_val <- (theta0 - post_mu) / sqrt(post_sig2)
                     pnorm(z_val, lower.tail = FALSE)
                   },
                   "3" = {
                     post_a <- a + floor(e * n)
                     post_b <- b + n
                     pgamma(theta0, post_a, rate = post_b, lower.tail = FALSE)
                   })
  }
  
  # === TWO SAMPLE POSTERIOR (EXTENDED) ===
  if (type == "two.sample") {
    if (is.null(Y_t) || is.null(Y_c) || is.null(delta)) {
      stop("For type = 'two.sample', you must provide Y_t, Y_c, and delta.")
    }
    if (is.null(outcome) || !(outcome %in% c(1,2,3))) {
      stop("Please enter a valid outcome type: 1 = binary, 2 = continuous, 3 = count.")
    }
    
    prob <- switch(as.character(outcome),
                   "1" = {
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
                   },
                   "3" = {
                     pt_post <- rgamma(sim, shape = a2 + Y_t, rate = b2 + n)
                     pc_post <- rgamma(sim, shape = a1 + Y_c, rate = b1 + n)
                     pd_post <- pt_post - pc_post
                     mean(pd_post > delta)
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
  
  # Checks
  if (!(type %in% c("one.sample", "two.sample"))) stop("Type must be 'one.sample' or 'two.sample'")
  if (type == "one.sample" && is.null(outcome)) stop("Please specify outcome type for one.sample (1, 2, or 3)")
  
  n_seq = seq(n_min, n_max)
  
  if (type == "one.sample") {
    s_vec = rep(NA, length(n_seq))
    m_vec = if (outcome %in% c(1,3)) rep(NA, length(n_seq)) else NULL
    
    for (i in seq_along(n_seq)) {
      n = n_seq[i]
      s_vec[i] <- One_Arm_Post_Prob_H1(n, theta0, e, outcome, a, b, sig = sig, q = q)
      if (!is.null(m_vec)) m_vec[i] <- floor(n * e)
    }
    
    if (s_vec[1] >= c) return("Can lower n_min.")
    if (tail(s_vec, 1) < c) return("Need to increase max sample size!")
    
    n_result <- n_seq[which(s_vec >= c)[1]]
    return(list(n = n_result, n_seq = n_seq, vec = s_vec, m_vec = m_vec))
  }
  
  if (type == "two.sample") {
    xi_list <- yd_n_list <- y1_list <- y2_list <- c()
    ss = yd_n <- NA
    
    yd_v_max = floor(e * n_max)
    min_xi_max = Two_Arm_Find_Min_Xi(yd_v_max, n_max, theta0, a1, b1, a2, b2, q, sim)
    if (min_xi_max$min_xi < c) {
      return(list(n = n_max, yd = yd_v_max, n_seq = n_seq, vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
    }
    
    for (n in n_seq) {
      yd_v = floor(e * n)
      min_xi = Two_Arm_Find_Min_Xi(yd_v, n, theta0, a1, b1, a2, b2, q, sim)
      if (is.na(ss) && min_xi$min_xi >= c) {
        ss = n
        yd_n = yd_v
        break
      }
      xi_list = c(xi_list, min_xi$min_xi)
      yd_n_list = c(yd_n_list, yd_v)
      y1_list = c(y1_list, min_xi$y1)
      y2_list = c(y2_list, min_xi$y2)
    }
    
    if (is.na(ss)) {
      ss = n_max
      yd_n = floor(e * ss)
    }
    
    return(list(n = ss, yd = yd_n, n_seq = n_seq, vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
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
  
  # Outcome placeholders
  y_H <- y_L <- y_H_s <- y_L_s <- NULL
  y <- y_s <- NULL
  e_s <- pH1 <- pH1_s <- n_s <- bess_dec <- bess_int_dec <- NA
  
  ### === ONE SAMPLE DESIGN === ###
  if (type == "one.sample") {
    if (outcome == 1) y <- rbinom(n0, 1, theta_H)
    if (outcome == 2) y <- rnorm(n0, mean = theta_H, sd = sig)
    if (outcome == 3) y <- rpois(n0, lambda = theta_H)
    
    e_obs <- mean(y)
    
    pH1 <- Post_Prob_Bayes(type = "one.sample", n = n0, theta0 = theta_s,
                           outcome = outcome, e = e_obs,
                           a = a, b = b, sig = sig, q = q)
    
    bess_int_dec <- ifelse(pH1 >= c, 1, ifelse(pH1 <= c_s, 0, 2))
    
    if (bess_int_dec == 2) {
      # Update prior
      if (outcome == 1) {
        a_ip <- a + sum(y)
        b_ip <- b + n0 - sum(y)
        post_mean <- a_ip / (a_ip + b_ip)
      } else if (outcome == 2) {
        a_ip <- mean(y)
        b_ip <- sig / sqrt(n0)
        post_mean <- a_ip
      } else {
        a_ip <- a + sum(y)
        b_ip <- b + n0
        post_mean <- a_ip / b_ip
      }
      
      e_s <- post_mean
      
      ss_result <- BESS_binary(margin = theta_s, threshold = c, delta = e_s,
                               min_n = n_min, max_n = n_max,
                               alpha1 = a_ip, beta1 = b_ip,
                               prior_weight = 1, iterations = 10000)
      n_s <- ss_result$n
      if (cap && n_s > n_cap - n0) n_s <- n_cap - n0
      
      if (outcome == 1) y_s <- rbinom(n_s, 1, theta_H)
      if (outcome == 2) y_s <- rnorm(n_s, mean = theta_H, sd = sig)
      if (outcome == 3) y_s <- rpois(n_s, lambda = theta_H)
      
      pH1_s <- Post_Prob_Bayes(type = "one.sample", n = n_s, theta0 = theta_s,
                               outcome = outcome, e = mean(y_s),
                               a = a_ip, b = b_ip, sig = sig, q = q)
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
    
    e_obs <- mean(y_L) - mean(y_H)
    
    pH1 <- Post_Prob_Bayes(type = "two.sample", n = n0,
                           delta = -theta_s, Y_t = sum(y_H), Y_c = sum(y_L),
                           a1 = a1, b1 = b1, a2 = a2, b2 = b2,
                           q = q, sim = 10000)
    
    bess_int_dec <- ifelse(pH1 >= c, 1, ifelse(pH1 <= c_s, 0, 2))
    
    if (bess_int_dec == 2) {
      if (outcome == 1 || outcome == 3) {
        # Binary or count — use conjugate update
        a1_ip <- a1 + sum(y_L)
        b1_ip <- b1 + n0 - sum(y_L)
        a2_ip <- a2 + sum(y_H)
        b2_ip <- b2 + n0 - sum(y_H)
        
        post_mean_L <- if (outcome == 1) a1_ip / (a1_ip + b1_ip) else a1_ip / (b1 + n0)
        post_mean_H <- if (outcome == 1) a2_ip / (a2_ip + b2_ip) else a2_ip / (b2 + n0)
      } else {
        # Continuous — assume Normal-Normal
        post_mean_L <- mean(y_L)
        post_mean_H <- mean(y_H)
        a1_ip <- post_mean_L
        b1_ip <- sig / sqrt(n0)
        a2_ip <- post_mean_H
        b2_ip <- sig / sqrt(n0)
      }
      
      e_s <- post_mean_L - post_mean_H
      
      ss_result <- Two_Arm_BESS_Binary(margin = -theta_s, threshold = c, delta = e_s,
                                       min_n = n_min, max_n = n_max,
                                       a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
      n_s <- ss_result$n
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
      
      pH1_s <- Post_Prob_Bayes(type = "two.sample", n = n_s,
                               delta = -theta_s, Y_t = sum(y_H_s), Y_c = sum(y_L_s),
                               a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip,
                               q = q, sim = 10000)
      bess_dec <- ifelse(pH1_s >= c, 1, 0)
    }
    
    return(list(
      y_H_n0 = y_H, y_L_n0 = y_L, pH1_int = pH1, bess_int_dec = bess_int_dec,
      y_H_ns = y_H_s, y_L_ns = y_L_s, e_s = e_s, n_s = n_s,
      pH1_s = pH1_s, bess_fin_dec = bess_dec
    ))
  }
}