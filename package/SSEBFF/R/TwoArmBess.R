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
    ss_result <- Two_Arm_BESS_Binary(-theta_s, c, e_s, n_min, n_max, a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
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