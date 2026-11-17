# Continuous
Two_Arm_Cont_Post_Prob = function(sample_size, threshold, effect_size, prior_mean, prior_sd, sigma, quant = 0.5) {
  variance = 1 / ((1 / (prior_sd^2)) + (sample_size / (sigma^2)))
  post_mean = variance * (prior_mean / (prior_sd^2) + (sample_size * effect_size) / (sigma^2))
  z_val = (threshold - post_mean) / sqrt(variance)
  prob = 1 - pnorm(z_val)
  if(quant == 0.5) return(prob)
  adjust = (2 * quant - 1) * prob
  (quant * prob) / (1 - quant + adjust)
}

Two_Arm_Cont_Sample_Size = function(threshold, crit, effect_size, prior_mean, prior_sd, 
                                    min_n=5, max_n=100, quant=0.5, sigma=1) {
  prob_vals = sapply(seq(min_n, max_n), function(n) 
    Two_Arm_Cont_Post_Prob(n, threshold, effect_size, prior_mean, prior_sd, sigma, quant))
  
  if(prob_vals[1] >= crit) return("Decrease min_n")
  if(prob_vals[length(prob_vals)] < crit) return("Increase max_n")
  
  final_n = which(prob_vals >= crit)[1] + min_n - 1
  list(n = final_n, prob = prob_vals[final_n - min_n + 1], 
       posterior_prob_margin_exceeded = prob_vals)
}

# Gamma-Poisson
Two_Arm_Count_Post_Prob = function(count_treat, count_ctrl, sample_size, threshold, 
                                   a_t, b_t, a_c, b_c, quant=0.5, simulations=1e4) {
  post_t = rgamma(simulations, a_t + count_treat, rate = b_t + sample_size)
  post_c = rgamma(simulations, a_c + count_ctrl, rate = b_c + sample_size)
  post_prob = mean(post_t - post_c > threshold)
  
  if(quant == 0.5) return(post_prob)
  adjust = (2 * quant - 1) * post_prob
  (quant * post_prob) / (1 - quant + adjust)
}

Two_Arm_Count_Min_Effect = function(effect_size, sample_size, threshold, 
                                    a_t, b_t, a_c, b_c, quant=0.5, s_reps=1e4, reps=1e4) {
  result = Two_Arm_Gamma_Min_Effect(effect_size, sample_size, threshold,
                                    a_t, b_t, a_c, b_c, quant, s_reps, reps)
  list(y1 = result$y1, y2 = result$y2, prob = result$min_xi)
}

Two_Arm_Combined_Post_Prob = function(type = c("continuous", "count", "binary"),
                                         sample_size,
                                         threshold,
                                         # For continuous
                                         effect_size = NULL,
                                         prior_mean = NULL, prior_sd = NULL, sigma = 1,
                                         # For count
                                         count_treat = NULL, count_ctrl = NULL,
                                         a_t = NULL, b_t = NULL, a_c = NULL, b_c = NULL,
                                         # For binary
                                         obs_t = NULL, obs_c = NULL,
                                         alpha1 = 0.5, beta1 = 0.5,
                                         alpha2 = 0.5, beta2 = 0.5,
                                         prior_weight = 0.5,
                                         quant = 0.5,
                                         simulations = 1e4) {
  type <- match.arg(type)
  
  if (type == "continuous") {
    if (is.null(prior_mean) || is.null(prior_sd) || is.null(effect_size)) {
      stop("Missing inputs for continuous outcome: prior_mean, prior_sd, or effect_size.")
    }
    variance = 1 / ((1 / (prior_sd^2)) + (sample_size / (sigma^2)))
    post_mean = variance * (prior_mean / (prior_sd^2) + (sample_size * effect_size) / (sigma^2))
    z_val = (threshold - post_mean) / sqrt(variance)
    prob = 1 - pnorm(z_val)
    
  } else if (type == "count") {
    if (is.null(count_treat) || is.null(count_ctrl) || is.null(a_t) || is.null(b_t) || is.null(a_c) || is.null(b_c)) {
      stop("Missing inputs for count outcome: counts or prior parameters.")
    }
    post_t = rgamma(simulations, a_t + count_treat, rate = b_t + sample_size)
    post_c = rgamma(simulations, a_c + count_ctrl, rate = b_c + sample_size)
    prob = mean(post_t - post_c > threshold)
    
  } else if (type == "binary") {
    if (is.null(obs_t) || is.null(obs_c)) {
      stop("Missing observed counts for binary outcome.")
    }
    post_t = rbeta(simulations, alpha1 + obs_t, beta1 + sample_size - obs_t)
    post_c = rbeta(simulations, alpha2 + obs_c, beta2 + sample_size - obs_c)
    raw_prob = mean(post_t - post_c > threshold)
    
    if (prior_weight == 0.5) {
      prob = raw_prob
    } else {
      adj = (2 * prior_weight - 1) * raw_prob
      prob = (prior_weight * raw_prob) / (1 - prior_weight + adj)
    }
  }
  
  # Quantile adjustment
  if (quant == 0.5) return(prob)
  adjust = (2 * quant - 1) * prob
  return((quant * prob) / (1 - quant + adjust))
}

Two_Arm_Combined_Sample_Size = function(type = c("binary", "continuous", "count"),
                                           threshold, crit, effect_size,
                                           # Continuous
                                           prior_mean = NULL, prior_sd = NULL, sigma = 1,
                                           # Count
                                           a_t = NULL, b_t = NULL, a_c = NULL, b_c = NULL,
                                           # Binary
                                           alpha1 = 0.5, beta1 = 0.5,
                                           alpha2 = 0.5, beta2 = 0.5,
                                           prior_weight = 0.5,
                                           min_n = 5, max_n = 100,
                                           quant = 0.5,
                                           s_reps = 1000, sims = 1e4) {
  type <- match.arg(type)
  
  if (type == "continuous") {
    prob_vals = sapply(seq(min_n, max_n), function(n)
      Two_Arm_Cont_Post_Prob(n, threshold, effect_size, prior_mean, prior_sd, sigma, quant))
    
    if (prob_vals[1] >= crit) return("Decrease min_n")
    if (prob_vals[length(prob_vals)] < crit) return("Increase max_n")
    
    final_n = which(prob_vals >= crit)[1] + min_n - 1
    return(list(n = final_n,
                prob = prob_vals[final_n - min_n + 1],
                posterior_prob_margin_exceeded = prob_vals))
    
  } else if (type == "count") {
    for (n in seq(min_n, max_n)) {
      min_eff = Two_Arm_Count_Min_Effect(effect_size, n, threshold,
                                         a_t, b_t, a_c, b_c,
                                         quant, s_reps, sims)
      if (min_eff$prob >= crit) {
        return(list(n = n,
                    yd = min_eff$y1 - min_eff$y2,
                    posterior_prob_margin_exceeded = min_eff$prob))
      }
    }
    return("Criteria not met - increase max_n")
    
  } else if (type == "binary") {
    for (n in seq(min_n, max_n)) {
      d_obs = floor(effect_size * n)
      worst = Two_Arm_Binary_Min_Prob(d_obs, n, threshold,
                                    alpha1, beta1, alpha2, beta2,
                                    prior_weight, sims)
      if (worst$min_prob >= crit) {
        return(list(n_per_arm           = n,
                    required_difference = d_obs,
                    worst_case          = worst))
      }
    }
    # Fallback
    d_obs = floor(effect_size * max_n)
    worst = Two_Arm_Binary_Min_Prob(d_obs, max_n, threshold,
                                  alpha1, beta1, alpha2, beta2,
                                  prior_weight, sims)
    return(list(n_per_arm           = max_n,
                required_difference = d_obs,
                worst_case          = worst))
  }
}

# Compute the (possibly weighted) posterior probability  
# that p_t – p_c exceeds the specified margin (M).  
# For a superiority test, M > 0 means H1: p_t – p_c > M  
# For a non‑inferiority test, you simply pass M < 0,  
# so H1: p_t – p_c > M  ⇔  p_t is no more than |M| worse than p_c.
Two_Arm_Binary_Post_Prob = function(obs_t, obs_c, n, margin,
                                    alpha1 = 0.5, beta1 = 0.5,
                                    alpha2 = 0.5, beta2 = 0.5,
                                    prior_weight = 0.5,
                                    iterations = 10000) {
  
  post_t = rbeta(iterations, alpha1 + obs_t, beta1 + n - obs_t)
  post_c = rbeta(iterations, alpha2 + obs_c, beta2 + n - obs_c)
  raw_prob = mean(post_t - post_c > margin)
  
  if (prior_weight == 0.5) {
    return(raw_prob)
  } else {
    adj = (2 * prior_weight - 1) * raw_prob
    return((prior_weight * raw_prob) / (1 - prior_weight + adj))
  }
}

#’ For a given observed difference, find the worst‑case (min) adjusted
#’ posterior probability H1 across all outcome pairs (tr, ct) with tr – ct = diff.
Two_Arm_Binary_Min_Prob = function(diff, n, margin,
                                   alpha1 = 0.5, beta1 = 0.5,
                                   alpha2 = 0.5, beta2 = 0.5,
                                   prior_weight = 0.5,
                                   iterations = 10000) {
  
  probs = sapply(0:n, function(tr) {
    ct = tr - diff
    if (ct >= 0 && ct <= n) {
      Two_Arm_Binary_Post_Prob(tr, ct, n, margin,
                               alpha1, beta1, alpha2, beta2,
                               prior_weight, iterations)
    } else {
      NA
    }
  })
  
  valid_idx = which(!is.na(probs))
  if (length(valid_idx) == 0) stop("No valid (tr, ct) pairs for diff = ", diff)
  
  min_idx = valid_idx[which.min(probs[valid_idx])]
  list(
    tr = min_idx - 1,
    ct = (min_idx - 1) - diff,
    min_prob = min(probs[valid_idx])
  )
}

# BESS two-arm sample‑size finder  
# @param margin      if >0 you’re asking for superiority;  
#                    if <0 you’re asking for non‑inferiority by |margin|.
# @param threshold   posterior probability cut‑off (e.g. 0.8 or 0.9)
# @param delta       expected true difference p_t – p_c
# @param min_n, max_n search range for total sample per arm
# @param …           other prior parameters & iterations
BESS_binary = function(margin, threshold, delta,
                       min_n, max_n,
                       alpha1 = 0.5, beta1 = 0.5,
                       alpha2 = 0.5, beta2 = 0.5,
                       prior_weight = 0.5,
                       iterations = 10000) {
  for (n in seq(min_n, max_n)) {
    d_obs = floor(delta * n)
    worst = Two_Arm_Binary_Min_Prob(d_obs, n, margin,
                                  alpha1, beta1, alpha2, beta2,
                                  prior_weight, iterations)
    if (worst$min_prob >= threshold) {
      return(list(
        n_per_arm           = n,
        required_difference = d_obs,
        worst_case          = worst
      ))
    }
  }
  # if threshold never met, return max_n result
  d_obs = floor(delta * max_n)
  worst = Two_Arm_Binary_Min_Prob(d_obs, max_n, margin,
                                alpha1, beta1, alpha2, beta2,
                                prior_weight, iterations)
  list(
    n_per_arm           = max_n,
    required_difference = d_obs,
    worst_case          = worst
  )
}
