\name{Two_Arm_Bayes_Sample_Size}
\alias{Two_Arm_Bayes_Sample_Size}
\title{Bayesian Sample Size Determination for Binary Outcome (Two‑Arm Trial)}
\description{
Computes the smallest sample size such that the minimum adjusted posterior probability for a given expected effect exceeds a decision threshold.
}
\usage{
Two_Arm_Bayes_Sample_Size(
  null_margin, threshold, expected_effect,
  min_n, max_n,
  alpha1 = 0.05, beta1 = 0.05, alpha2 = 0.05, beta2 = 0.05,
  prior_weight = 0.5, iterations = 10000
)
}
\arguments{
  \item{null_margin}{Margin defining the null hypothesis (e.g., non‑inferiority or superiority threshold).}
  \item{threshold}{Minimum required adjusted posterior probability.}
  \item{expected_effect}{Assumed treatment effect (difference in success rates).}
  \item{min_n, max_n}{Search bounds for sample size.}
  \item{alpha1, beta1, alpha2, beta2}{Beta prior parameters.}
  \item{prior_weight}{Prior weight for posterior probability adjustment.}
  \item{iterations}{Number of posterior samples per simulation.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A list with:
\itemize{
  \item{\code{n}}: Estimated minimum sample size
  \item{\code{yd}}: Corresponding minimum detectable difference (rounded)
  \item{\code{n_seq}}: Sequence of evaluated sample sizes
  \item{\code{vec}}: Vector of minimum adjusted posterior probabilities
  \item{\code{yd_vec}}: Differences used at each sample size
  \item{\code{tr_vals}, \code{ct_vals}}: Success counts giving the minimum probabilities
}
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
# Determine minimum sample size with an expected effect of 0.1
ss_result = Two_Arm_Bayes_Sample_Size(
  null_margin = 0.05, threshold = 0.7, expected_effect = 0.1,
  min_n = 10, max_n = 50,
  alpha1 = 0.05, beta1 = 0.05, alpha2 = 0.05, beta2 = 0.05,
  prior_weight = 0.5, iterations = 100
)
# In practice, set iterations to 1000
ss_result$n   # Sample size
ss_result$yd  # Target detectable difference
}