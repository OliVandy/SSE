Two_Arm_Post_Prob_H1_Sim = function(Y_t, Y_c, n, delta, a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, q = 0.5, sim = 10000){
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

Two_Arm_Find_Min_Xi = function(yd, n, delta, a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, q = 0.5, sim = 10000){
  xi_list = list(y1 = c(), y2 = c(), xi = c())
  for(y1 in 0:n){
    for(y2 in 0:n){
      # For all y1 - y2 satisfy y1 - y2 = yd, find xi
      if((y1 - y2) == yd){
        xi_list$y1 = c(xi_list$y1, y1)
        xi_list$y2 = c(xi_list$y2, y2)
        xi_list$xi = c(xi_list$xi, Two_Arm_Post_Prob_H1_Sim(y1, y2, n, delta, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim))
      }
    }
  }
  # Find the minimum xi among all the y1s and y2s in the set y1 - y2 = yd
  min_xi_idx = which(xi_list$xi == min(xi_list$xi))[1]
  return(list(y1 = xi_list$y1[min_xi_idx], y2 = xi_list$y2[min_xi_idx], min_xi = xi_list$xi[min_xi_idx]))
}

Two_Arm_BESS_Binary = function(theta0, c, e, n_min, n_max, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05, q = 0.5, sim = 10000){
  
  xi_list = c()
  yd_n_list = c()
  y1_list = c()
  y2_list = c()
  
  ss = NA
  yd_n = NA
  
  # If at max, c is not attained, we shall use n_max as output
  yd_v_max = floor(e*n_max)
  min_xi_max = Two_Arm_Find_Min_Xi(yd_v_max, n_max, theta0, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim)
  if(min_xi_max$min_xi < c){
    ss = n_max
    yd_n = yd_v_max
    return(list(n = ss, yd = yd_n, n_seq = seq(n_min, n_max), vec = xi_list, yd_vec = yd_n_list, y1_vec = y1_list, y2_vec = y2_list))
  }
  
  for(n in seq(n_min,n_max)){
    
    yd_v = floor(e*n)
    min_xi = Two_Arm_Find_Min_Xi(yd_v, n, theta0, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q, sim = sim)
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

Two_Arm_BESS_SSR_Design = function(theta_H, theta_L, theta_s, c, c_s, n0, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05, q = 0.5, n_min = 1, n_max = 200, cap = F, n_cap = 200){
  
  y_H = rbinom(n0, 1, theta_H)
  y_L = rbinom(n0, 1, theta_L)
  
  pH1 = Two_Arm_Post_Prob_H1_Sim(sum(y_L), sum(y_H), n0, -theta_s, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q)
  bess_int_dec <- NA
  if(pH1 >= c){        # Stop for success
    bess_int_dec <- 1
  }else if(pH1 <= c_s){# Stop for futility
    bess_int_dec = 0
  }else{               # Continue enrollment
    bess_int_dec = 2
  }
  
  y_H_s = NA
  y_L_s= NA
  e_s = NA
  n_s = NA
  pH1_s = NA
  bess_dec = NA
  if(bess_int_dec == 2){
    # Compute BESS with informative prior
    a1_ip = a1+sum(y_L)
    b1_ip <- b1+n0-sum(y_L)
    a2_ip <- a2+sum(y_H)
    b2_ip <- b2+n0-sum(y_H)
    
    # Compute posterior pred e
    post_mean_theta_L <- a1_ip/(a1_ip+b1_ip)
    post_mean_theta_H <- a2_ip/(a2_ip+b2_ip)
    e_s <- post_mean_theta_L - post_mean_theta_H
    
    # BESS additional sample size
    ss_result <- Two_Arm_BESS_Binary(theta_s, c, e_s, n_min, n_max, a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
    n_s <- ss_result$n
    
    if(cap == T){
      if(n_s > n_cap - n0){
        n_s <- n_cap - n0
      }
    }
    
    # generate additional outcome
    y_H_s <- rbinom(n_s, 1, theta_H)
    y_L_s <- rbinom(n_s, 1, theta_L)
    
    pH1_s <- Two_Arm_Post_Prob_H1_Sim(sum(y_L_s), sum(y_H_s), n_s, -theta_s, a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
    bess_dec <- 0
    if(pH1_s >= c){
      bess_dec <- 1
    }
  }
  
  return(list(y_H_n0 = y_H, y_L_n0 = y_L, pH1_int = pH1, bess_int_dec = bess_int_dec, y_H_ns = y_H_s,
              y_L_ns = y_L_s, e_s = e_s, n_s = n_s, pH1_s = pH1_s, bess_fin_dec = bess_dec))
}

Two_Arm_Standard_SSE_Design <- function(n_f, theta_H, theta_L, theta_s, alpha, interim = F,
                                        n_0 = NA, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
                                        q = 0.5, c = 0.7, c_s = 0.3){
  
  y_H <- rbinom(n_f, 1, theta_H)
  y_L <- rbinom(n_f, 1, theta_L)
  freq_dec <- NULL
  n_tot <- NA
  
  if(interim == T){
    
    y_H_50 <- y_H[1:n_0]
    y_L_50 <- y_L[1:n_0]
    
    pH1 <- Two_Arm_Post_Prob_H1_Sim(sum(y_L_50), sum(y_H_50), n_0, -theta_s, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q)
    bess_int_dec <- NA
    if(pH1 >= c){        # Stop for success
      freq_dec <- 1
      n_tot <- n_0
    }else if(pH1 <= c_s){# Stop for futility
      freq_dec <- 0
      n_tot <- n_0
    }else{
      # Freq test result
      z_stats <- (mean(y_L) - mean(y_H) + theta_s)/
        (sqrt((mean(y_L)*(1-mean(y_L))+mean(y_H)*(1-mean(y_H)))/n_f))
      p_val <- pnorm(z_stats, lower.tail = F)
      n_tot <- n_f
      if(p_val < alpha){
        freq_dec <- 1
      }else{
        freq_dec <- 0
      }
    }
    
  }else{
    
    # Freq test result
    z_stats <- (mean(y_L) - mean(y_H) + theta_s)/
      (sqrt((mean(y_L)*(1-mean(y_L))+mean(y_H)*(1-mean(y_H)))/n_f))
    p_val <- pnorm(z_stats, lower.tail = F)
    freq_dec <- 0
    n_tot <- n_f
    if(p_val < alpha){
      freq_dec <- 1
    }
    
  }
  
  return(c(mean(y_H), mean(y_L), freq_dec, n_tot))
}

# Posterior probability function for H1 (two-arm)
Two_Arm_Post_Prob_H1 = function(obs_t, obs_c, sample_size, margin, alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5, prior_weight = 0.5, iterations = 10000) {
  
  p_t_a = alpha1 + obs_t
  p_t_b = beta1 + sample_size - obs_t
  post_t = rbeta(iterations, p_t_a, p_t_b)
  
  p_c_a = alpha2 + obs_c
  p_c_b = beta2 + sample_size - obs_c
  post_c = rbeta(iterations, p_c_a, p_c_b)
  
  diff_post = post_t - post_c
  p_post = sum(diff_post > margin) / iterations
  
  if (prior_weight == 0.5) {
    return(p_post)
  } else {
    adj = (2 * prior_weight - 1) * p_post
    result = (prior_weight * p_post) / (1 - prior_weight + adj)
    return(result)
  }
}

# Find minimum adjusted posterior (two-arm)
Two_Arm_Min_Adj_Prob = function(diff, sample_size, margin, alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5, prior_weight = 0.5, iterations = 10000) {
  outcome_list = list(treat = c(), ctrl = c(), adj_prob = c())
  
  for (tr in 0:sample_size) {
    for (ct in 0:sample_size) {
      if ((tr - ct) == diff) {
        outcome_list$treat = c(outcome_list$treat, tr)
        outcome_list$ctrl = c(outcome_list$ctrl, ct)
        outcome_list$adj_prob = c(outcome_list$adj_prob, Two_Arm_Post_Prob_H1(tr, ct, sample_size, margin, alpha1, beta1, alpha2, beta2, prior_weight, iterations))
      }
    }
  }
  min_index = which(outcome_list$adj_prob == min(outcome_list$adj_prob))[1]
  return(list(treat = outcome_list$treat[min_index], ctrl = outcome_list$ctrl[min_index], min_prob = outcome_list$adj_prob[min_index]))
}

# BESS design for binary outcome (two-arm)
Two_Arm_Bayes_Sample_Size = function(null_margin, threshold, expected_effect, min_n, max_n, alpha1 = 0.05, beta1 = 0.05, alpha2 = 0.05, beta2 = 0.05, prior_weight = 0.5, iterations = 10000) {
  
  prob_vec = c()
  diff_vec = c()
  tr_vec = c()
  ct_vec = c()
  
  final_n = NA
  target_diff = NA
  
  max_diff = floor(expected_effect * max_n)
  min_at_max = Two_Arm_Min_Adj_Prob(max_diff, max_n, null_margin, alpha1, beta1, alpha2, beta2, prior_weight, iterations)
  
  if (min_at_max$min_prob < threshold) {
    final_n = max_n
    target_diff = max_diff
    return(list(n = final_n, yd = target_diff, n_seq = seq(min_n, max_n), vec = prob_vec, yd_vec = diff_vec, tr_vals = tr_vec, ct_vals = ct_vec))
  }
  
  for (current_n in seq(min_n, max_n)) {
    diff_value = floor(expected_effect * current_n)
    min_out = Two_Arm_Min_Adj_Prob(diff_value, current_n, null_margin, alpha1, beta1, alpha2, beta2, prior_weight, iterations)
    
    if (min_out$min_prob >= threshold && is.na(final_n)) {
      final_n = current_n
      target_diff = diff_value
      break
    }
    
    prob_vec = c(prob_vec, min_out$min_prob)
    diff_vec = c(diff_vec, diff_value)
    tr_vec = c(tr_vec, min_out$treat)
    ct_vec = c(ct_vec, min_out$ctrl)
  }
  
  if (is.na(final_n)) {
    final_n = max_n
    target_diff = floor(expected_effect * final_n)
  }
  
  return(list(n = final_n, yd = target_diff, n_seq = seq(min_n, max_n), vec = prob_vec, yd_vec = diff_vec, tr_vals = tr_vec, ct_vals = ct_vec))
}

Two_Arm_Gamma_Post_Prob = function(count_treat, count_ctrl, sample_size, threshold, a_t, b_t, a_c, b_c, quant = 0.5, simulations = 10000) {
  shape_t = a_t + count_treat
  rate_t = b_t + sample_size
  post_t = rgamma(simulations, shape_t, rate = rate_t)
  
  shape_c = a_c + count_ctrl
  rate_c = b_c + sample_size
  post_c = rgamma(simulations, shape_c, rate = rate_c)
  
  diff = post_t - post_c
  post_prob = sum(diff > threshold) / simulations
  
  if (quant == 0.5) {
    return(post_prob)
  } else {
    adjust = (2 * quant - 1) * post_prob
    res = (quant * post_prob) / (1 - quant + adjust)
    return(res)
  }
}

Two_Arm_Gamma_Min_Effect = function(effect_size, sample_size, threshold, a_t, b_t, a_c, b_c, quant = 0.5, s_reps = 10000, reps = 10000) {
  lambda_ctrl = rgamma(s_reps, a_c, rate = b_c)
  probs = rep(NA, s_reps)
  yt_vals = rep(NA, s_reps)
  yc_vals = rep(NA, s_reps)
  
  for (i in 1:s_reps) {
    ctrl_count = sum(rpois(sample_size, lambda_ctrl[i]))
    treat_count = ctrl_count + floor(sample_size * effect_size)
    probs[i] = Two_Arm_Gamma_Post_Prob(treat_count, ctrl_count, sample_size, threshold, a_t, b_t, a_c, b_c, quant, reps)
    yt_vals[i] = treat_count
    yc_vals[i] = ctrl_count
  }
  
  min_index = which.min(probs)
  return(list(y1 = yt_vals[min_index], y2 = yc_vals[min_index], min_xi = probs[min_index]))
}

Two_Arm_Gamma_Sample_Size = function(threshold, crit, effect_size, a_t, b_t, a_c, b_c, min_n = 5, max_n = 100, quant = 0.5, s_reps = 1000, reps = 10000) {
  xi_vals = numeric(max_n - min_n + 1)
  diff_vals = numeric(max_n - min_n + 1)
  y1_vals = numeric(max_n - min_n + 1)
  y2_vals = numeric(max_n - min_n + 1)
  
  for (n in seq(min_n, max_n)) {
    min_result = Two_Arm_Gamma_Min_Effect(effect_size, n, threshold, a_t, b_t, a_c, b_c, quant, s_reps, reps)
    idx = n - min_n + 1
    xi_vals[idx] = min_result$min_xi
    diff_vals[idx] = min_result$y1 - min_result$y2
    y1_vals[idx] = min_result$y1
    y2_vals[idx] = min_result$y2
    
    if (min_result$min_xi >= crit) {
      return(list(n = n, yd = diff_vals[idx], prob_h1_vec = xi_vals[1:idx], 
                  yd_vec = diff_vals[1:idx], y1_vec = y1_vals[1:idx], y2_vec = y2_vals[1:idx]))
    }
  }
  return("Criteria not met - increase max_n")
}