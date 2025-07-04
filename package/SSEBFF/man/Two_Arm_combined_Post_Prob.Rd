\name{Two_Arm_Combined_Post_Prob}
\alias{Two_Arm_Combined_Post_Prob}
\alias{Two_Arm_Binary_Min_Prob}
\title{
  Posterior Probability and the minimum Posterior Probability for Given Difference in Binary Outcomes (Two-Arm)
}
\description{
  1. Combined_Post_Prob: Computes the posterior probability that the treatment effect exceeds a defined threshold in two-arm Bayesian trials. Supports binary, continuous, and count data types using conjugate priors and optional quantile adjustment.\cr
  2. Min_Prob: For a given observed difference in responders, finds the worst-case (minimum) posterior probability across all valid combinations of treatment and control responses that yield that difference.
}
\usage{
Two_Arm_Combined_Post_Prob(type = c("binary", "continuous", "count"),
                               count_treat = NULL, count_ctrl = NULL,
                               n = NULL,
                               threshold, effect_size = NULL,
                               alpha1 = 0.5, beta1 = 0.5,
                               alpha2 = 0.5, beta2 = 0.5,
                               prior_mean = NULL, prior_sd = NULL,
                               sigma = 1,
                               a_t = NULL, b_t = NULL,
                               a_c = NULL, b_c = NULL,
                               quant = 0.5, simulations = 10000)
Two_Arm_Combined_Post_Prob(diff, n, margin,
                        alpha1 = 0.5, beta1 = 0.5,
                        alpha2 = 0.5, beta2 = 0.5,
                        prior_weight = 0.5,
                        iterations = 10000)
}
\arguments{
  \item{type}{Character. Outcome type. Must be one of \code{"binary"}, \code{"continuous"}, or \code{"count"}.}
  \item{count_treat}{Numeric. Number of successes (binary) or event counts (count) in the treatment group. Required for binary and count types.}
  \item{count_ctrl}{Numeric. Number of successes (binary) or event counts (count) in the control group. Required for binary and count types.}
  \item{n}{Numeric. Sample size per arm. Required for all types.}
  \item{threshold}{Numeric. Threshold value (null margin) to compare against posterior difference (e.g. \eqn{\theta_0}).}
  \item{effect_size}{Numeric. Observed or assumed effect size. Required for continuous type.}
  \item{alpha1, beta1}{Numerics. Beta prior parameters for the control group (binary outcomes).}
  \item{alpha2, beta2}{Numerics. Beta prior parameters for the treatment group (binary outcomes).}
  \item{prior_mean}{Numeric. Prior mean for continuous outcomes.}
  \item{prior_sd}{Numeric. Prior standard deviation for continuous outcomes.}
  \item{sigma}{Numeric. Known standard deviation of the continuous outcome. Default is 1.}
  \item{a_t, b_t}{Numerics. Shape and rate of Gamma prior for treatment group (count outcomes).}
  \item{a_c, b_c}{Numerics. Shape and rate of Gamma prior for control group (count outcomes).}
  \item{quant}{Numeric. Posterior quantile correction factor. Default is 0.5 (no correction).}
  \item{simulations}{Integer. Number of samples drawn for posterior estimation in binary and count outcomes. Default is 10,000.}
  \item{obs_t}{Observed number of responders in the treatment group.}
  \item{obs_c}{Observed number of responders in the control group.}
  \item{margin}{Superiority (margin > 0) or non-inferiority (margin < 0) threshold.}
  \item{prior_weight}{Weighting for the posterior adjustment (default 0.5 = no adjustment).}
  \item{iterations}{Number of samples to draw from the posterior distributions.}
  \item{diff}{Observed difference in responder counts: tr - ct.}
}
\details{
These functions calculate the posterior probability that the difference in response rates between treatment and control groups exceeds a user-defined margin. The calculation uses Beta priors for the true proportions and simulates from the posterior distributions via the Beta-Binomial conjugate model.

The \code{prior_weight} argument allows for adjusting the raw posterior probability in a weighted fashion, consistent with robust Bayesian updating. For \code{prior_weight = 0.5}, the posterior is unadjusted (i.e., equal to the raw Monte Carlo estimate). Values closer to 0 or 1 bias the posterior toward a more skeptical or enthusiastic prior stance, respectively.

These functions are building blocks for sample size calculations, decision-theoretic evaluation, and sensitivity analyses in binary outcome trials.

In particular, in conjunction with \code{BESS_binary()}, these functions support robust sample size planning under uncertainty and variation in observed outcomes.
}
\value{
  1. Post Prob: Posterior probability (possibly adjusted) that \code{p_t - p_c > margin}.\cr
  2. Min Prob: A list with:\cr
  \item{tr}{Treatment responder count (worst-case).}
  \item{ct}{Control responder count (worst-case).}
  \item{min_prob}{Minimum posterior probability observed for the given difference.}
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
# Binary example
Two_Arm_Combined_Post_Prob(
  type = "binary",
  count_treat = 25,
  count_ctrl = 15,
  n = 50,
  threshold = 0,
  alpha1 = 0.5,
  beta1 = 0.5,
  alpha2 = 0.5,
  beta2 = 0.5,
  quant = 0.5
)

# Continuous example
Two_Arm_Combined_Post_Prob(
  type = "continuous",
  n = 50,
  threshold = 0,
  effect_size = 0.3,
  prior_mean = 0,
  prior_sd = 1,
  sigma = 1,
  quant = 0.5
)

# Count example
Two_Arm_Combined_Post_Prob(
  type = "count",
  count_treat = 60,
  count_ctrl = 40,
  n = 50,
  threshold = 0,
  a_t = 1, b_t = 1,
  a_c = 1, b_c = 1,
  quant = 0.5
)
}
Two_Arm_Binary_Min_Prob(diff = 5, n = 30, margin = 0.05)
}