One_Arm_Bayes_prob = function(n, theta0, e, outcome, a, b, sig = 1){
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

One_Arm_Bayes_H1 = function(n, theta0, e, outcome, a, b, sig = 1, q = 0.5){
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
  
  prob <- post_prob_theta_1a(n, theta0, e, outcome, a, b, sig = sig)
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
    s_vec[cnt] = post_prob_H1_1a(n, theta0, e, outcome, a, b, sig = sig, q = q)
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

One_Arm_Bayes_sim = function(Y_t, Y_c, n, delta, a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, q = 0.5, sim = 10000){
  #set.seed(seed)
  # Posterior p_t parameters
  pt_pa = a1 + Y_t
  pt_pb = b1 + n - Y_t
  # Posterior p1|Y_t, n ~ Beta(pt_pa, pt_pb)
  pt_post = rbeta(sim, pt_pa, pt_pb)
  
  # Posterior p_c parameters
  pc_pa = a2 + Y_c
  pc_pb = b2 + n - Y_c
  # Posterior p2|Y_c, n ~ Beta(pc_pa, pc_pb)
  pc_post = rbeta(sim, pc_pa, pc_pb)
  
  # p1 - p2
  pd_post = pt_post - pc_post
  
  #rm(.Random.seed, envir=.GlobalEnv)
  
  # Compute Pr(p1 - p2 > delta|data) = #(p1 - p2 > delta)/sim
  post_prob = sum(pd_post > delta)/sim
  
  if(q == 0.5){
    return(post_prob)
  }else{
    A2Pm1 = (2*q-1)*post_prob
    result = (q*post_prob)/(1 - q + A2Pm1)
    return(result)
  }
}

One_Arm_Find_MinXi = function(yd, n, delta, a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, q = 0.5, sim = 10000){
  xi_list = list(y1 = c(), y2 = c(), xi = c())
  for(y1 in 0:n){
    for(y2 in 0:n){
      # For all y1 - y2 satisfy y1 - y2 = yd, find xi
      if((y1 - y2) == yd){
        xi_list$y1 = c(xi_list$y1, y1)
        xi_list$y2 = c(xi_list$y2, y2)
        xi_list$xi = c(xi_list$xi, post_prob_H1_sim(y1, y2, n, delta, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim))
      }
    }
  }
  # Find the minimum xi among all the y1s and y2s in the set y1 - y2 = yd
  min_xi_idx = which(xi_list$xi == min(xi_list$xi))[1]
  return(list(y1 = xi_list$y1[min_xi_idx], y2 = xi_list$y2[min_xi_idx], min_xi = xi_list$xi[min_xi_idx]))
}

One_Arm_BESS_bin = function(theta0, c, e, n_min, n_max, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05, q = 0.5, sim = 10000){
  
  xi_list = c()
  yd_n_list = c()
  y1_list = c()
  y2_list = c()
  
  ss = NA
  yd_n = NA
  
  # If at max, c is not attained, we shall use n_max as output
  yd_v_max = floor(e*n_max)
  min_xi_max = find_min_xi(yd_v_max, n_max, theta0, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim)
  if(min_xi_max$min_xi < c){
    ss = n_max
    yd_n = yd_v_max
    return(list(n = ss, yd = yd_n, n_seq = seq(n_min, n_max), vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
  }
  
  for(n in seq(n_min,n_max)){
    
    yd_v = floor(e*n)
    min_xi = find_min_xi(yd_v, n, theta0, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim)
    #print(c(n, yd_v, min_xi$y1, min_xi$y2,  min_xi$min_xi))
    
    if(min_xi$min_xi >= c && is.na(ss)){
      ss = n
      yd_n = yd_v
      break
    }
    xi_list = c(xi_list, min_xi$min_xi)
    yd_n_list = c(yd_n_list, yd_v)
    y1_list = c(y1_list, min_xi$y1)
    y2_list = c(y2_list, min_xi$y2)
    
  }
  if(is.na(ss)){
    ss = n_max
    yd_n = floor(e*ss)
  }
  
  return(list(n = ss, yd = yd_n, n_seq = seq(n_min, n_max), vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
  
}