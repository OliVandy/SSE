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
  if(length(n) != 1 || !is.numeric(n) || !is.finite(n) || n <= 0 || n != floor(n)){
    return("Please enter an interger that is greater than 0.")
  }
  # Check if outcome is 1, 2, or 3
  if(!(outcome %in% c(1,2,3))){
    return("Please enter a valid outcome type, 1 = binary, 2 = continuous, and 3 = count-data.")
  }
  if(length(e) != 1 || !is.numeric(e) || !is.finite(e)){
    return("Please enter a finite numeric evidence value.")
  }
  if(outcome == 1 && (e < 0 || e > 1)){
    return("Please enter an evidence that is between 0 and 1.")
  }
  if(outcome == 3 && e < 0){
    return("Please enter a non-negative mean count.")
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
  if(length(n_min) != 1 || length(n_max) != 1 ||
     !is.numeric(n_min) || !is.numeric(n_max) ||
     !is.finite(n_min) || !is.finite(n_max) ||
     n_min <= 0 || n_max < n_min ||
     n_min != floor(n_min) || n_max != floor(n_max)){
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
    if(is.character(s_vec)) return(s_vec[cnt])
    #print(s_vec)
    if(outcome %in% c(1,3)){
      m_vec[cnt] = floor(n*e)
    }
    cnt = cnt + 1
  }
  if(s_vec[1] >= c){
    return("Can lower n_min.")
  }
  if(!any(s_vec >= c)){
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

One_Arm_Count_Post_Prob = function(count, n, threshold, a = 0.5, b = 0.5, quant = 0.5, simulations = 1e4) {
  # Posterior: shape = a + count, rate = b + n
  post_samples <- rgamma(simulations, shape = a + count, rate = b + n)
  post_prob <- mean(post_samples > threshold)
  if (quant == 0.5) {
    return(post_prob)
  } else {
    adjust <- (2 * quant - 1) * post_prob
    return((quant * post_prob) / (1 - quant + adjust))
  }
}

One_Arm_Count_Sample_Size = function(threshold, crit, effect_size, a = 0.5, b = 0.5,
                                      min_n = 5, max_n = 100, quant = 0.5, simulations = 1e4) {
  for (n in seq(min_n, max_n)) {
    count <- floor(n * effect_size)
    prob <- One_Arm_Count_Post_Prob(count, n, threshold, a, b, quant, simulations)
    if (prob >= crit) {
      return(list(
        n = n,
        count = count,
        prob = prob
      ))
    }
  }
  return("Criteria not met - increase max_n")
}
