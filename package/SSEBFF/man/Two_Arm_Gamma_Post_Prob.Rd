\name{Two_Arm_Gamma_Post_Prob.Rd}
\alias{Two_Arm_Gamma_Post_Prob.Rd}
\title{Posterior Probability for Difference in Rates (Gamma-Poisson Model)}
\description{
Computes the posterior probability that the treatment event rate exceeds the control rate by a threshold using Gamma priors and Poisson likelihoods.
}
\usage{
Two_Arm_Gamma_Post_Prob(
  count_treat, count_ctrl, sample_size, threshold,
  a_t, b_t, a_c, b_c, quant = 0.5, simulations = 10000
)
}
\arguments{
  \item{count_treat}{Number of events in the treatment group.}
  \item{count_ctrl}{Number of events in the control group.}
  \item{sample_size}{Total time or exposure (same for both groups).}
  \item{threshold}{Minimum difference in rates to be declared effective.}
  \item{a_t, b_t}{Gamma prior shape and rate for treatment.}
  \item{a_c, b_c}{Gamma prior shape and rate for control.}
  \item{quant}{Quantile adjustment for prior belief (0.5 = no adjustment).}
  \item{simulations}{Number of posterior draws.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A scalar: posterior probability (adjusted if \code{quant} ≠ 0.5).
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
Two_Arm_Gamma_Post_Prob(
  count_treat = 12, count_ctrl = 8, sample_size = 50,
  threshold = 0.2,
  a_t = 0.1, b_t = 0.1,
  a_c = 0.1, b_c = 0.1
)
}