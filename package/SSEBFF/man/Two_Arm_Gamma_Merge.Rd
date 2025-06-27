\name{Two_Arm_Gamma_Merge}
\alias{Two_Arm_Gamma_Min_Effect}
\alias{Two_Arm_Gamma_Post_Prob}
\alias{Two_Arm_Gamma_Sample_Size}
\title{
  Gamma-Poisson Model for Two-Arm Trials
}
\description{
  The posterior probability is the probability of the alternative hypothesis: in this case, that the count of the treatment group has a higher event rate than count control.\cr
  1. Min Effect: Simulates outcomes under a Gamma-Poisson model to find the minimum posterior probability of superiority for a given sample size and effect size, assuming the control rate is drawn from a Gamma prior. \cr
  2. Post Prob: Computes the posterior probability that the treatment event rate exceeds the control rate by a threshold using Gamma priors and Poisson likelihoods.\cr
  3. Sample Size: Computes the minimum sample size needed to achieve a posterior probability of superiority greater than or equal to a critical threshold, under a Gamma-Poisson model for count outcomes.
}
\usage{
Two_Arm_Gamma_Min_Effect(effect_size, sample_size, threshold,
                          a_t, b_t, a_c, b_c, quant = 0.5,
                          s_reps = 10000, reps = 10000)
Two_Arm_Gamma_Post_Prob(
  count_treat, count_ctrl, sample_size, threshold,
  a_t, b_t, a_c, b_c, quant = 0.5, simulations = 10000)
Two_Arm_Gamma_Sample_Size(threshold, crit, effect_size,
                          a_t, b_t, a_c, b_c,
                          min_n = 5, max_n = 100,
                          quant = 0.5, s_reps = 1000, reps = 10000)
}
\arguments{
  \item{effect_size}{Assumed difference in means between treatment and control.}
  \item{sample_size}{Sample size per arm.}
  \item{threshold}{Minimum difference in rates to be declared effective.}
  \item{a_t}{Shape parameter for the Gamma prior on treatment group rate.}
  \item{b_t}{Rate parameter for the Gamma prior on treatment group rate.}
  \item{a_c}{Shape parameter for the Gamma prior on control group rate.}
  \item{b_c}{Rate parameter for the Gamma prior on control group rate.}
  \item{quant}{Weighting factor for quantile posterior adjustment (default is 0.5, i.e., no adjustment).}
  \item{s_reps}{Number of simulations for prior sampling (default 10000).}
  \item{reps}{Number of posterior simulations per trial (default 10000).}
  \item{count_treat}{Number of events in the treatment group.}
  \item{count_ctrl}{Number of events in the control group.}
  \item{simulations}{Number of posterior draws.}
  \item{crit}{Minimum acceptable posterior probability for design success.}
  \item{min_n}{Minimum sample size to consider (default 5).}
  \item{max_n}{Maximum sample size to consider (default 100).}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  1. Min Effect: A list with elements:
  \item{y1}{Simulated event count for treatment group.}
  \item{y2}{Simulated event count for control group.}
  \item{min_xi}{Minimum posterior probability of superiority observed.}
  2. Post Prob: A scalar: posterior probability (adjusted if \code{quant} ≠ 0.5)./n
  3. Sample Size: A list with:
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
# Find minimum posterior probability given assumed sample size and effect
min_eff = Two_Arm_Gamma_Min_Effect(
  effect_size = 0.2,
  sample_size = 30,
  threshold = 0.1,
  a_t = 0.05, b_t = 0.05,
  a_c = 0.05, b_c = 0.05,
  quant = 0.5,
  s_reps = 100,
  reps = 1000
)
print(min_eff)

Two_Arm_Gamma_Post_Prob(
  count_treat = 12, count_ctrl = 8, sample_size = 50,
  threshold = 0.2,
  a_t = 0.1, b_t = 0.1,
  a_c = 0.1, b_c = 0.1
)

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