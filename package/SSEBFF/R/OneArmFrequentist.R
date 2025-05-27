One_Arm_Freq_cont<-function(alpha, beta, theta, theta_star) {
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)         # Z-score for desired power
  numerator = (z_alpha + z_beta)^2 * theta * (1 - theta)
  denominator = (theta - theta_star)^2
  n = ceiling(numerator / denominator)  # Round up to nearest whole number
  return(n)
}