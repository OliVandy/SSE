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
      stop("Please enter a valid outcome type: 1 = binary, 2 = continuous, 3 = count-data.")
    }
    if (is.null(e) || e < 0 || e > 1) {
      stop("Please enter an evidence level 'e' between 0 and 1.")
    }
    if (is.null(theta0)) stop("theta0 is required for one.sample.")
    
    # Call posterior core
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
                   }
    )
  }
  
  # === TWO SAMPLE POSTERIOR ===
  if (type == "two.sample") {
    if (is.null(Y_t) || is.null(Y_c) || is.null(delta)) {
      stop("For type = 'two.sample', you must provide Y_t, Y_c, and delta.")
    }
    
    pt_post <- rbeta(sim, a1 + Y_t, b1 + n - Y_t)
    pc_post <- rbeta(sim, a2 + Y_c, b2 + n - Y_c)
    pd_post <- pt_post - pc_post
    prob <- mean(pd_post > delta)
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