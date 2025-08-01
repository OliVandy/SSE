\name{Post_Prob_Bayes}
\alias{Post_Prob_Bayes}
\title{Posterior Probability Calculation for One- and Two-Sample Bayesian Settings}
\description{
Computes the posterior probability that a parameter exceeds a threshold using Bayesian updating for one-sample or two-sample scenarios. Supports binary and continuous outcomes for one and two-arm tests.
}
\usage{
Post_Prob_Bayes(type = "one.sample", 
                n, theta0 = NULL, delta = NULL, 
                outcome = NULL, e = NULL, 
                a = 0.5, b = 0.5, sig = 1,
                Y_t = NULL, Y_c = NULL,
                a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
                q = 0.5, sim = 10000)
}
\arguments{
  \item{type}{Type of test: \code{"one.sample"} or \code{"two.sample"}.}
  \item{n}{Sample size per group or total sample size (one-sample).}
  \item{theta0}{Threshold for posterior probability comparison. Required for \code{one.sample}.}
  \item{delta}{Margin threshold for two-sample difference. Required for \code{two.sample}.}
  \item{outcome}{Outcome type: 1 = binary, 2 = continuous.}
  \item{e}{Evidence level; proportion of observed successes or mean response.}
  \item{a, b}{Prior hyperparameters for one-sample case.}
  \item{sig}{Standard deviation (for continuous one-sample outcomes).}
  \item{Y_t, Y_c}{Observed successes or responses in treatment and control groups for two-sample case.}
  \item{a1, b1, a2, b2}{Beta prior hyperparameters for treatment and control groups.}
  \item{q}{Weighting parameter for adjusting posterior probability.}
  \item{sim}{Number of simulations to use in the two-sample posterior estimation.}
}
\details{
\itemize{
  \item Binary: uses Beta posterior.
  \item Continuous: uses Normal posterior.
  \item Posterior probabilities for difference in success rates are estimated using simulation from Beta posteriors.
}
An optional adjustment based on \code{q} is applied to the raw posterior using a quasi-decision-theoretic rule.
}
\value{
A numeric value representing the posterior probability (possibly adjusted by \code{q}).
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
# One-sample binary
Post_Prob_Bayes(type = "one.sample", n = 20, theta0 = 0.5, outcome = 1, e = 0.6)

# Two-sample binary
Post_Prob_Bayes(type = "two.sample", n = 20, delta = 0.1, outcome = 1, Y_t = 13, Y_c = 8)
}