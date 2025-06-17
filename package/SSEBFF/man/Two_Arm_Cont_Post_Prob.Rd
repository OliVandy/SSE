\name{Two_Arm_Cont_Post_Prob}
\alias{Two_Arm_Cont_Post_Prob}
\title{
  Posterior Probability for Continuous Outcomes
}
\description{
  Computes the posterior probability that the mean of a continuous treatment group exceeds a threshold, assuming Normal prior and likelihood.
}
\usage{
Two_Arm_Cont_Post_Prob(sample_size, threshold, effect_size,
                       prior_mean, prior_sd, sigma, quant = 0.5)
}
\arguments{
  \item{sample_size}{Number of observations in each group.}
  \item{threshold}{Value to be exceeded by the posterior mean.}
  \item{effect_size}{Assumed treatment effect (mean difference).}
  \item{prior_mean}{Prior mean for the effect.}
  \item{prior_sd}{Prior standard deviation for the effect.}
  \item{sigma}{Known standard deviation of outcome.}
  \item{quant}{Posterior adjustment weight (default 0.5 = no adjustment).}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A scalar representing the posterior probability that the effect exceeds the threshold.
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
# Posterior probability calculation for continuous outcome
Two_Arm_Cont_Post_Prob(
  sample_size = 30,
  threshold = 0,
  effect_size = 0.2,
  prior_mean = 0,
  prior_sd = 1,
  sigma = 1,
  quant = 0.5
)
}