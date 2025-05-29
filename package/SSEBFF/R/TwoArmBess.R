Two_Arm_BESS_SSR_Cont = function(theta_H, theta_L, theta_s, c, c_s, n0, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05, q = 0.5, n_min = 1, n_max = 200, cap = F, n_cap = 200){
  
  y_H = rbinom(n0, 1, theta_H)
  y_L = rbinom(n0, 1, theta_L)
  
  pH1 = post_prob_H1_sim(sum(y_L), sum(y_H), n0, -theta_s, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q)
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
    ss_result <- BESS_bin(-theta_s, c, e_s, n_min, n_max, a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
    n_s <- ss_result$n
    
    if(cap == T){
      if(n_s > n_cap - n0){
        n_s <- n_cap - n0
      }
    }
    
    # generate additional outcome
    y_H_s <- rbinom(n_s, 1, theta_H)
    y_L_s <- rbinom(n_s, 1, theta_L)
    
    pH1_s <- post_prob_H1_sim(sum(y_L_s), sum(y_H_s), n_s, -theta_s, a1 = a1_ip, b1 = b1_ip, a2 = a2_ip, b2 = b2_ip, q = q)
    bess_dec <- 0
    if(pH1_s >= c){
      bess_dec <- 1
    }
  }
  
  return(list(y_H_n0 = y_H, y_L_n0 = y_L, pH1_int = pH1, bess_int_dec = bess_int_dec, y_H_ns = y_H_s,
              y_L_ns = y_L_s, e_s = e_s, n_s = n_s, pH1_s = pH1_s, bess_fin_dec = bess_dec))
  
}

Two_Arm_StandardSSE_Cont = function(n_f, theta_H, theta_L, theta_s, alpha, interim = F,
          n_0 = NA, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
          q = 0.5, c = 0.7, c_s = 0.3){
  
  y_H <- rbinom(n_f, 1, theta_H)
  y_L <- rbinom(n_f, 1, theta_L)
  freq_dec <- NULL
  n_tot <- NA
  
  if(interim == T){
    
    y_H_50 <- y_H[1:n_0]
    y_L_50 <- y_L[1:n_0]
    
    pH1 <- post_prob_H1_sim(sum(y_L_50), sum(y_H_50), n_0, -theta_s, a1 = a1, b1 = b1, a2 = a2, b2 = b2, q = q)
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