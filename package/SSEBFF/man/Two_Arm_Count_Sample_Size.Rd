\name{Two_Arm_Count_Sample_Size}
\alias{Two_Arm_Count_Sample_Size}
\title{Bayesian Sample Size Calculation for Two-Arm Count Outcome Trials}
\description{
Estimate the minimum required sample size per arm to achieve a posterior probability exceeding a decision threshold in two-arm trials with count data modeled using a Gamma-Poisson (negative binomial) framework.
}
\usage{
Two_Arm_Count_Sample_Size(threshold, crit, effect_size,
                          a_t, b_t, a_c, b_c,
                          min_n = 5, max_n = 100,
                          quant = 0.5, s_reps = 1000, reps = 1e4)
}
\arguments{
  \item{threshold}{Posterior probability margin (e.g., treatment – control rate > threshold).}
  \item{crit}{Decision threshold for the posterior probability (e.g., 0.8 or 0.9).}
  \item{effect_size}{Expected treatment effect size as an additive increase over control.}
  \item{a_t, b_t}{Shape and rate parameters for the Gamma prior on the treatment arm rate.}
  \item{a_c, b_c}{Shape and rate parameters for the Gamma prior on the control arm rate.}
  \item{min_n, max_n}{Range of sample sizes (per arm) to consider in the search.}
  \item{quant}{Prior weight or Bayesian quantile adjustment; default is 0.5 (no adjustment).}
  \item{s_reps}{Number of outer simulation replicates to generate prior predictive draws.}
  \item{reps}{Number of posterior simulations used per outcome configuration.}
}
\details{
This function supports Bayesian sample size calculation for trials with count outcomes, such as number of events, incidents, or occurrences per unit. Outcomes are modeled using a Gamma-Poisson framework: prior beliefs about event rates are expressed as Gamma distributions, and observed counts are assumed to follow Poisson likelihoods.

For each candidate sample size between \code{min_n} and \code{max_n}, the function simulates control group rates from the prior, generates Poisson data, adds a fixed \code{effect_size} increase in the treatment group, and computes the posterior probability that the rate difference exceeds the specified \code{threshold}.

The result ensures that the desired posterior certainty (\code{crit}) is met even in the most pessimistic scenario observed across prior simulations. This makes it suitable for planning conservative, decision-theoretically robust studies.
}
\value{
If criteria are met, returns a \code{list} containing:
  \item{n}{The minimum required sample size per arm.}
  \item{yd}{Observed difference in total counts between treatment and control in the worst-case simulation that still meets the threshold.}
  \item{posterior_prob_margin_exceeded}{Posterior probability of exceeding the threshold in that scenario.}

If the criterion is not met within the range, returns a character string: \code{"Criteria not met - increase max_n"}.
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
\code{\link{Two_Arm_Count_Post_Prob}}, \code{\link{Two_Arm_Count_Min_Effect}}
}
\examples{
Two_Arm_Count_Sample_Size(threshold = 1, crit = 0.9, effect_size = 0.25,
                          a_t = 1, b_t = 1, a_c = 1, b_c = 1,
                          min_n = 5, max_n = 50)
}