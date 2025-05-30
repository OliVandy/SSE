One_Arm_Post_Prob_Theta = function(n, theta0, e, outcome, a, b, sig = 1){
  if(outcome == 1){       # Binary outcome
    # Posterior hyperparameters
    post_a = a + floor(e*n)
    post_b = b + n - floor(e*n)
    # Pr(theta > theta0)
    return(pbeta(theta0, post_a, post_b, lower.tail = F))
  }else if(outcome == 2){ # Continuous outcome
    # Posterior hyperparameters
    post_sig2 = 1/(1/(b^2) + n/(sig^2))
    post_mu = post_sig2*((a/(b^2)) + ((n*e)/(sig^2)))
    # z value
    z_val = (theta0-post_mu)/sqrt(post_sig2)
    # Pr(Z > z_val)
    return(pnorm(z_val, lower.tail = F))
  }else{                  # Count-data outcome
    # Posterior hyperparameters
    post_a = a + floor(e*n)
    post_b = b + n
    # Pr(theta > theta0)
    return(pgamma(theta0, post_a, rate = post_b, lower.tail = F))
  }
}

One_Arm_Post_Prob_H1 = function(n, theta0, e, outcome, a, b, sig = 1, q = 0.5){
  # Check if n is interger
  if(n < 0){
    return("Please enter an interger that is greater than 0.")
  }
  # Check if e is within 0 and 1
  if(e < 0 || e > 1){
    return("Please enter an evidence that is between 0 and 1.")
  }
  # Check if outcome is 1, 2, or 3
  if(!(outcome %in% c(1,2,3))){
    return("Please enter a valid outcome type, 1 = binary, 2 = continuous, and 3 = count-data.")
  }
  # Check if q is a probability between 0 and 1
  if(q <= 0 || q >= 1 || !is.double(q)){
    return("Please enter a q that is between 0 and 1.")
  }
  
  prob <- One_Arm_Post_Prob_Theta(n, theta0, e, outcome, a, b, sig = sig)
  if(q == 0.5){
    return(prob)
  }else{
    A2Pm1 = (2*q-1)*prob
    result = (q*prob)/(1 - q + A2Pm1)
    return(result)
  }
}

One_Arm_BESS = function(theta0, c, e, outcome, a, b, q = 0.5, sig = 1, n_min = 5, n_max = 100){
  if(n_min <= 0 || n_max < n_min || !is.double(n_min) || !is.double(n_max)){
    return("Please enter valid min and max values.")
  }
  # Check if outcome is 1, 2, or 3
  if(!(outcome %in% c(1,2,3))){
    return("Please enter a valid outcome type, 1 = binary, 2 = continuous, and 3 = count-data.")
  }
  
  n_seq = seq(n_min, n_max)
  s_vec = rep(NA, length(n_seq))
  if(outcome %in% c(1,3)){
    m_vec = rep(NA, length(n_seq))
  }
  cnt = 1
  for(n in n_seq){
    #print(n)
    s_vec[cnt] = One_Arm_Post_Prob_H1(n, theta0, e, outcome, a, b, sig = sig, q = q)
    #print(s_vec)
    if(outcome %in% c(1,3)){
      m_vec[cnt] = floor(n*e)
    }
    cnt = cnt + 1
  }
  if(s_vec[1] >= c){
    return("Can lower n_min.")
  }
  if(s_vec[length(s_vec)] < c){
    return("Need to increase max sample size!")
  }
  n_result = n_seq[which(s_vec >= c)[1]]
  if(outcome %in% c(1,3)){
    return(list(n = n_result, n_seq = n_seq, vec = s_vec, m_vec = m_vec))
  }else{
    return(list(n = n_result, n_seq = n_seq, vec = s_vec))
  }
}

One_Arm_Normal_Post_Prob = function(sample_size, threshold, effect_size, prior_mean, prior_sd, sigma, quant = 0.5) {
  variance = 1 / ((1 / (prior_sd^2)) + (sample_size / (sigma^2)))
  post_mean = variance * (prior_mean / (prior_sd^2) + (sample_size * effect_size) / (sigma^2))
  z_val = (threshold - post_mean) / sqrt(variance)
  prob = 1 - pnorm(z_val)
  if (quant == 0.5) {
    return(prob)
  } else {
    adjust = (2 * quant - 1) * prob
    res = (quant * prob) / (1 - quant + adjust)
    return(res)
  }
}

One_Arm_Normal_Sample_Size = function(threshold, crit, effect_size, prior_mean, prior_sd, min_n = 5, max_n = 100, quant = 0.5, sigma = 1) {
  n_vals = seq(min_n, max_n)
  prob_vals = rep(NA, length(n_vals))
  for (n in n_vals) {
    prob_vals[n - min_n + 1] = One_Arm_Normal_Post_Prob(n, threshold, effect_size, prior_mean, prior_sd, sigma, quant)
  }
  if (prob_vals[1] >= crit) return("Decrease min_n")
  if (prob_vals[length(prob_vals)] < crit) return("Increase max_n")
  final_n = n_vals[which(prob_vals >= crit)[1]]
  return(list(n = final_n, prob = prob_vals[which(prob_vals >= crit)[1]], prob_h1_vec = prob_vals))
}