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