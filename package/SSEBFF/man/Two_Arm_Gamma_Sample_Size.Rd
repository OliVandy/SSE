\name{Two_Arm_Gamma_Sample_Size}
\alias{Two_Arm_Gamma_Sample_Size}
\title{
  Bayesian Sample Size Calculation for Gamma Outcomes
}
\description{
  Computes the minimum sample size needed to achieve a posterior probability of superiority greater than or equal to a critical threshold, under a Gamma-Poisson model for count outcomes.
}
\usage{
Two_Arm_Gamma_Sample_Size(threshold, crit, effect_size,
                          a_t, b_t, a_c, b_c,
                          min_n = 5, max_n = 100,
                          quant = 0.5, s_reps = 1000, reps = 10000)
}
\arguments{
  \item{threshold}{Posterior superiority threshold to assess.}
  \item{crit}{Minimum acceptable posterior probability for design success.}
  \item{effect_size}{Assumed difference in means between treatment and control.}
  \item{a_t}{Shape parameter for Gamma prior on treatment rate.}
  \item{b_t}{Rate parameter for Gamma prior on treatment rate.}
  \item{a_c}{Shape parameter for Gamma prior on control rate.}
  \item{b_c}{Rate parameter for Gamma prior on control rate.}
  \item{min_n}{Minimum sample size to consider (default 5).}
  \item{max_n}{Maximum sample size to consider (default 100).}
  \item{quant}{Weight for posterior adjustment (default 0.5 = unadjusted).}
  \item{s_reps}{Number of prior simulations (default 1000).}
  \item{reps}{Number of posterior draws per evaluation (default 10000).}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A list with:
  \item{n}{Minimum sample size achieving the target probability.}
  \item{yd}{Required outcome difference.}
  \item{prob_h1_vec}{Vector of posterior probabilities across iterations.}
  \item{yd_vec}{Vector of required outcome differences.}
  \item{y1_vec}{Vector of treatment event counts.}
  \item{y2_vec}{Vector of control event counts.}
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
# Estimate sample size for Gamma-based BESS design
res = Two_Arm_Gamma_Sample_Size(
  threshold = 0.1,
  crit = 0.7,
  effect_size = 0.2,
  a_t = 0.05, b_t = 0.05,
  a_c = 0.05, b_c = 0.05,
  min_n = 5,
  max_n = 50,
  quant = 0.5,
  s_reps = 100,
  reps = 1000
)
print(res$n)
print(res$yd)
}