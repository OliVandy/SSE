\name{BESS_unified}
\alias{BESS_unified}
\title{Bayesian Estimator of Sample Size (BESS) for One- and Two-Sample Designs}
\description{
Estimates the minimum required sample size to achieve a desired posterior probability threshold \code{c} based on Bayesian inference, supporting binary and continuous for one-sample designs, and binary outcomes for two-sample designs. This is based on controlling the posterior probability \code{xi} to exceed a cutoff value \code{c} when the observed treatment effect exceeds a certain proportion \code{e}.
}
\usage{
BESS_unified(theta0, c, e, type = "one.sample", 
             outcome = NULL, a = NULL, b = NULL, sig = 1,
             a1 = NULL, b1 = NULL, a2 = NULL, b2 = NULL,
             q = 0.5, sim = 10000, n_min = 5, n_max = 100)
}
\arguments{
  \item{theta0}{Threshold value for comparison against the posterior distribution.
  One-sample design: is the null value (e.g., a historical mean or proportion) against which the
  posterior distribution of the observed parameter (mean, proportion, or rate) is compared.
  Two-sample design: represents the minimum clinically meaningful difference between treatment and control groups
  (e.g., risk difference in binary outcomes). The design aims to ensure that the posterior probability that the treatment effect exceeds \code{theta0} reaches or exceeds threshold \code{c}.
  In other functions in this package, this parameter can also be referred to as \code{threshold}.}
  \item{c}{Critical posterior probability level to exceed (e.g., 0.95).}
  \item{e}{Evidence level used to simulate observed effect (e.g., observed proportion or mean).
  One-sample design: represents the expected true value of the outcome (e.g., response rate, average outcome, or event rate) under the assumed alternative scenario.
  Two-sample design: represents the expected effect size between treatment and control (e.g., \code{e = p_t - p_c} for binary outcomes). It is used to generate simulated trial outcomes.}
  \item{type}{\code{"one.sample"} or \code{"two.sample"}.}
  \item{outcome}{Type of one-sample outcome: 1 = binary, 2 = continuous. Required for \code{type = "one.sample"}.}
  \item{a, b}{Beta/Gamma/Normal prior parameters for the one-sample case.}
  \item{sig}{Standard deviation for continuous outcomes.}
  \item{a1, b1, a2, b2}{Prior Beta parameters for treatment and control arms in the two-sample case.}
  \item{q}{Weighting parameter for adjusting posterior probabilities.}
  \item{sim}{Number of simulations used in two-sample estimation.}
  \item{n_min}{Minimum sample size to evaluate.}
  \item{n_max}{Maximum sample size to evaluate.}
}
\details{
This function supports unified Bayesian sample size planning under a range of outcome types and model assumptions.
The function checks whether the posterior probability (or its adjusted version) exceeds a threshold \code{c} for simulated or observed data, scanning a range of sample sizes to determine the minimum needed.
The function iteratively increases the sample size starting from \code{n_min} and computes the minimum posterior probability \code{xi} for an observed difference \code{yd = floor(e * n)} using \code{Two_Arm_Find_Min_Xi}. The smallest sample size for which the posterior probability exceeds \code{c} is returned.
}
\value{
A list containing:
\itemize{
  \item{\code{n}}{Estimated minimum sample size required.}
  \item{\code{vec}}{Posterior probabilities (or minimum \code{xi}) at each evaluated sample size.}
  \item{\code{n_seq}}{Sequence of evaluated sample sizes.}
  \item{\code{m_vec}}{Observed successes (one-sample binary/count only).}
  \item{\code{yd}}{Count of expected treatment-control effect difference.}
  \item{\code{yd_vec}{(Two-arm binary only) Vector of event allocations evaluated at each sample size.}
  \item{\code{y1_vec, y2_vec}{(Two-arm binary only) Event allocations in treatment and control arms that achieve the minimum posterior probability above the threshold.}
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
# One-sample, binary
BESS_unified(theta0 = 0.5, c = 0.95, e = 0.6, type = "one.sample",
             outcome = 1, a = 1, b = 1, q = 0.5)

# Two-sample
BESS_unified(theta0 = 0.1, c = 0.95, e = 0.6, type = "two.sample",
             a1 = 1, b1 = 1, a2 = 1, b2 = 1, q = 0.5)
}