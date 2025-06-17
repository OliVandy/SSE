\name{Two_Arm_Cont_Sample_Size}
\alias{Two_Arm_Cont_Sample_Size}
\title{
  Sample Size Calculation for Continuous Outcome BESS
}
\description{
  Determines the minimum sample size required for the posterior probability of a treatment effect to exceed a specified threshold, given a prior distribution and assumed effect.
}
\usage{
Two_Arm_Cont_Sample_Size(threshold, crit, effect_size,
                         prior_mean, prior_sd,
                         min_n = 5, max_n = 100,
                         quant = 0.5, sigma = 1)
}
\arguments{
  \item{threshold}{Posterior probability threshold to exceed.}
  \item{crit}{Critical posterior probability required for design success.}
  \item{effect_size}{Assumed treatment effect (mean difference).}
  \item{prior_mean}{Prior mean of the effect.}
  \item{prior_sd}{Prior standard deviation of the effect.}
  \item{min_n}{Minimum sample size to consider (default 5).}
  \item{max_n}{Maximum sample size to consider (default 100).}
  \item{quant}{Posterior adjustment weight (default 0.5).}
  \item{sigma}{Known standard deviation of the continuous outcome.}
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
# Sample size calculation for continuous BESS
res <- Two_Arm_Cont_Sample_Size(
  threshold = 0,
  crit = 0.8,
  effect_size = 0.2,
  prior_mean = 0,
  prior_sd = 1,
  sigma = 1,
  quant = 0.5
)
print(res$n)
}