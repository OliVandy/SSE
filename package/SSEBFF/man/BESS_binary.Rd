\name{BESS_binary}
\alias{BESS_binary}
\title{
  Bayesian Effect Size Sample Size (BESS) for Binary Outcomes
}
\description{
  Determines the minimum sample size per group needed for the posterior probability of a treatment effect (defined as difference in proportions) to exceed a given threshold, under worst-case outcome configuration.
}
\usage{
BESS_binary(margin, threshold, delta,
            min_n, max_n,
            alpha1 = 0.5, beta1 = 0.5,
            alpha2 = 0.5, beta2 = 0.5,
            prior_weight = 0.5,
            iterations = 10000)
}
\arguments{
  \item{margin}{Superiority (margin > 0) or non-inferiority (margin < 0) margin.}
  \item{threshold}{Minimum posterior probability required to declare success.}
  \item{delta}{Assumed true difference in response probability (p_t - p_c).}
  \item{min_n, max_n}{Range of candidate sample sizes to consider per arm.}
  \item{alpha1, beta1}{Prior Beta parameters for treatment arm.}
  \item{alpha2, beta2}{Prior Beta parameters for control arm.}
  \item{prior_weight}{Posterior adjustment weight (default 0.5).}
  \item{iterations}{Number of posterior samples used.}
}
\details{
This is the main interface for computing the minimum required sample size per arm in a two-group trial with binary outcomes using Bayesian posterior probability thresholds.

The function assumes a fixed expected treatment effect (\code{delta}) and a decision rule based on whether the posterior probability that \code{p_t - p_c > margin} exceeds a given threshold. It evaluates all candidate sample sizes from \code{min_n} to \code{max_n}, using worst-case observed differences to ensure conservativeness.

It integrates over outcome uncertainty using \code{Two_Arm_Binary_Min_Prob()} and returns both the minimum acceptable sample size and the outcome configuration at which the posterior is weakest (but still acceptable).

This function enables Bayesian assurance and planning in superiority and non-inferiority trials where control and treatment proportions are modeled with Beta-Binomial priors.
}
\value{
  A list with:
  \item{n_per_arm}{Sample size per group that meets posterior threshold.}
  \item{required_difference}{Observed difference needed.}
  \item{worst_case}{A list of worst-case responder counts and the corresponding posterior probability.}
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
BESS_binary(
  margin = 0.05,
  threshold = 0.9,
  delta = 0.15,
  min_n = 10,
  max_n = 200
)
}