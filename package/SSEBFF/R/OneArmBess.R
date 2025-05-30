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