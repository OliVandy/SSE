Post_Prob_Bayes = function(type = "one.sample", 
                            n, theta0 = NULL, delta = NULL, 
                            outcome = NULL, e = NULL, a = 0.5, b = 0.5, sig = 1,
                            Y_t = NULL, Y_c = NULL,
                            a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
                            q = 0.5, sim = 10000) {
  
  if (!(type %in% c("one.sample", "two.sample"))) {
    stop("Invalid 'type'. Choose either 'one.sample' or 'two.sample'")
  }
  
  if (type == "one.sample") {
    if (is.null(outcome)) stop("Please specify 'outcome' type: 1 (binary), 2 (continuous), or 3 (count)")
    if (is.null(e) || is.null(theta0)) stop("Please provide 'e' and 'theta0'")
    
    if (outcome == 1) {
      post_a = a + floor(e * n)
      post_b = b + n - floor(e * n)
      return(pbeta(theta0, post_a, post_b, lower.tail = FALSE))
      
    } else if (outcome == 2) {
      post_sig2 = 1 / (1 / (b^2) + n / (sig^2))
      post_mu = post_sig2 * ((a / (b^2)) + ((n * e) / (sig^2)))
      z_val = (theta0 - post_mu) / sqrt(post_sig2)
      return(pnorm(z_val, lower.tail = FALSE))
      
    } else if (outcome == 3) {
      post_a = a + floor(e * n)
      post_b = b + n
      return(pgamma(theta0, post_a, rate = post_b, lower.tail = FALSE))
      
    } else {
      stop("Invalid outcome type. Use 1 = binary, 2 = continuous, 3 = count.")
    }
    
  } else if (type == "two.sample") {
    if (is.null(Y_t) || is.null(Y_c) || is.null(delta)) {
      stop("For 'two.sample', provide 'Y_t', 'Y_c', and 'delta'")
    }
    
    pt_pa = a1 + Y_t
    pt_pb = b1 + n - Y_t
    pt_post = rbeta(sim, pt_pa, pt_pb)
    
    pc_pa = a2 + Y_c
    pc_pb = b2 + n - Y_c
    pc_post = rbeta(sim, pc_pa, pc_pb)
    
    pd_post = pt_post - pc_post
    post_prob = mean(pd_post > delta)
    
    if (q == 0.5) {
      return(post_prob)
    } else {
      A2Pm1 = (2 * q - 1) * post_prob
      result = (q * post_prob) / (1 - q + A2Pm1)
      return(result)
    }
  }
}