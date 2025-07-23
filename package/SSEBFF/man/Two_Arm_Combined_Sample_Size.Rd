\name{Two_Arm_Combined_Sample_Size}
\alias{Two_Arm_Combined_Sample_Size}
\title{
  Sample Size Calculation for Continuous Outcome BESS
}
\description{
  Computes the minimum required sample size per arm in a two-arm Bayesian trial design to ensure the posterior probability that the treatment effect exceeds a threshold is at least a specified critical value. This function supports \code{"binary"}, \code{"continuous"}, and \code{"count"} outcomes.
}
\usage{
Two_Arm_Combined_Sample_Size(type = c("binary", "continuous", "count"),
                                 threshold, crit, effect_size,
                                 prior_mean = NULL, prior_sd = NULL, sigma = 1,
                                 a_t = NULL, b_t = NULL, a_c = NULL, b_c = NULL,
                                 alpha1 = 0.5, beta1 = 0.5,
                                 alpha2 = 0.5, beta2 = 0.5,
                                 prior_weight = 0.5,
                                 min_n = 5, max_n = 100,
                                 quant = 0.5,
                                 s_reps = 1000, sims = 1e4)
}
\arguments{
  \item{type}{Character. Outcome type. Must be one of \code{"binary"}, \code{"continuous"}, or \code{"count"}.}
  \item{threshold}{Numeric. The null margin \eqn{\theta_0}. Posterior probabilities are computed for the treatment effect exceeding this value.}
  \item{crit}{Numeric. Critical posterior probability (e.g., 0.8). The sample size is chosen to meet or exceed this value.}
  \item{effect_size}{Numeric. The expected effect size (treatment minus control).}
  
  \item{prior_mean}{Numeric. Prior mean for continuous outcomes.}
  \item{prior_sd}{Numeric. Prior standard deviation for continuous outcomes.}
  \item{sigma}{Numeric. Known standard deviation of the continuous outcome (likelihood). Default is 1.}
  
  \item{a_t, b_t}{Numerics. Shape and rate parameters of the Gamma prior for the treatment group in count outcomes.}
  \item{a_c, b_c}{Numerics. Shape and rate parameters of the Gamma prior for the control group in count outcomes.}
  
  \item{alpha1, beta1}{Numerics. Prior alpha and beta for the control group in binary outcomes.}
  \item{alpha2, beta2}{Numerics. Prior alpha and beta for the treatment group in binary outcomes.}
  
  \item{prior_weight}{Numeric between 0 and 1. Prior weight for adjusting posterior probability in binary outcomes. Default is 0.5 (no adjustment).}
  \item{min_n, max_n}{Integers. The minimum and maximum sample size per arm to search.}
  \item{quant}{Numeric. Quantile adjustment for posterior probability (0.5 = no correction).}
  \item{s_reps}{Integer. Number of samples for count simulations. Default is 1000.}
  \item{sims}{Integer. Number of simulation iterations for binary/count posterior sampling. Default is 10,000.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A list containing:
  \item{n}{Minimum sample size satisfying the posterior criterion.}
  \item{prob}{Posterior probability at that sample size.}
  \item{posterior_prob_margin_exceeded}{Vector of posterior probabilities for each sample size.}
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
# Binary outcome example
Two_Arm_Combined_Sample_Size(
  type = "binary",
  threshold = 0,
  crit = 0.8,
  effect_size = 0.15)

# Continuous outcome example
Two_Arm_Combined_Sample_Size(
  type = "continuous",
  threshold = 0.2,
  crit = 0.9,
  effect_size = 0.4,
  prior_mean = 0,
  prior_sd = 1,
  sigma = 1)

# Count outcome example
Two_Arm_Combined_Sample_Size(
  type = "count",
  threshold = 0,
  crit = 0.85,
  effect_size = 0.2,
  a_t = 1, b_t = 1,
  a_c = 1, b_c = 1)
}

\seealso{
  \code{\link{Two_Arm_Binary_Post_Prob}},
}