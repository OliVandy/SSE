Freq_Binary_theoretical <- function(alpha, beta, theta1, theta0, type= "two.sample"){
  z_alpha = qnorm(1 - alpha)        # Z-score for significance level
  z_beta = qnorm(1 - beta)              # Z-score for desired power
  if(type=="two.sample"){
    numerator = (z_alpha + z_beta)^2 * (theta1 * (1 - theta1) + theta0 * (1 - theta0))
    denominator = (theta1 - theta0)^2
    n = ceiling(numerator / denominator)  # Round up to nearest whole number
  }
  if(type=="one.sample"){
    numerator = (z_alpha + z_beta)^2 * theta1 * (1 - theta1)
    denominator = (theta1 - theta0)^2
    n = ceiling(numerator / denominator)  # Round up to nearest whole number
  }
  if(!(type %in% c("two.sample","one.sample"))){
    warning("Wrong value, please choose from one.sample or two.sample")
  }
  return(n)
}
