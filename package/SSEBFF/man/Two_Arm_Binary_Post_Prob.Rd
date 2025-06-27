\name{Two_Arm_Binary_Post_Prob}
\alias{Two_Arm_Binary_Post_Prob}
\alias{Two_Arm_Binary_Min_Prob}
\title{
  Posterior Probability and the minimum Posterior Probability for Given Difference in Binary Outcomes (Two-Arm)
}
\description{
  Computes the (possibly weighted) posterior probability that the difference in response probabilities \( p_t - p_c \) exceeds a specified margin.\cr
  For a given observed difference in responders, finds the worst-case (minimum) posterior probability across all valid combinations of treatment and control responses that yield that difference.
}
\usage{
Two_Arm_Binary_Post_Prob(obs_t, obs_c, n, margin,
                         alpha1 = 0.5, beta1 = 0.5,
                         alpha2 = 0.5, beta2 = 0.5,
                         prior_weight = 0.5,
                         iterations = 10000)
Two_Arm_Binary_Min_Prob(diff, n, margin,
                        alpha1 = 0.5, beta1 = 0.5,
                        alpha2 = 0.5, beta2 = 0.5,
                        prior_weight = 0.5,
                        iterations = 10000)
}
\arguments{
  \item{obs_t}{Observed number of responders in the treatment group.}
  \item{obs_c}{Observed number of responders in the control group.}
  \item{n}{Sample size per arm.}
  \item{margin}{Superiority (margin > 0) or non-inferiority (margin < 0) threshold.}
  \item{alpha1, beta1}{Prior Beta parameters for treatment group.}
  \item{alpha2, beta2}{Prior Beta parameters for control group.}
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
Two_Arm_Binary_Post_Prob(obs_t = 25, obs_c = 20, n = 30, margin = 0.05)
Two_Arm_Binary_Min_Prob(diff = 5, n = 30, margin = 0.05)
}