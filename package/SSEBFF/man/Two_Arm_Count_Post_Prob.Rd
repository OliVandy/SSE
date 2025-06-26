\name{Two_Arm_Count_Post_Prob}
\alias{Two_Arm_Count_Post_Prob}
\alias{Two_Arm_Count_Min_Effect}
\title{
  1. Posterior Probability for Count Outcomes (Gamma-Poisson)
  2. Minimum Posterior Probability for Count Outcome
}
\description{
  1. Computes the posterior probability that the difference between treatment and control group rates exceeds a threshold under Gamma-Poisson priors.
  2. Simulates Gamma-Poisson outcomes to determine the minimum posterior probability of superiority over many random realizations of the control rate.
}
\usage{
Two_Arm_Count_Post_Prob(count_treat, count_ctrl, sample_size,
                        threshold, a_t, b_t, a_c, b_c,
                        quant = 0.5, simulations = 1e4)
Two_Arm_Count_Min_Effect(effect_size, sample_size, threshold,
                         a_t, b_t, a_c, b_c,
                         quant = 0.5, s_reps = 1e4, reps = 1e4)
}
\arguments{
  \item{count_treat}{Observed event count in the treatment group.}
  \item{count_ctrl}{Observed event count in the control group.}
  \item{sample_size}{Sample size per group.}
  \item{threshold}{Value the treatment effect must exceed.}
  \item{a_t}{Shape parameter for Gamma prior on treatment rate.}
  \item{b_t}{Rate parameter for Gamma prior on treatment rate.}
  \item{a_c}{Shape parameter for Gamma prior on control rate.}
  \item{b_c}{Rate parameter for Gamma prior on control rate.}
  \item{quant}{Weight for posterior adjustment (default 0.5).}
  \item{simulations}{Number of posterior draws (default 10000).}
  \item{effect_size}{Assumed treatment effect (difference in mean rates).}
  \item{s_reps}{Number of prior control rate simulations.}
  \item{reps}{Posterior draws per simulated trial.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  1. Posterior probability that treatment rate exceeds control by more than the threshold.

  2. A list with elements:
  \item{y1}{Event count in the treatment group.}
  \item{y2}{Event count in the control group.}
  \item{prob}{Minimum posterior probability observed.}
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
# Posterior probability using count data
Two_Arm_Count_Post_Prob(
  count_treat = 22,
  count_ctrl = 18,
  sample_size = 30,
  threshold = 1,
  a_t = 0.05, b_t = 0.05,
  a_c = 0.05, b_c = 0.05,
  quant = 0.5,
  simulations = 1000
)
# Find the worst-case scenario for count data posterior
Two_Arm_Count_Min_Effect(
  effect_size = 0.2,
  sample_size = 30,
  threshold = 1,
  a_t = 0.05, b_t = 0.05,
  a_c = 0.05, b_c = 0.05,
  quant = 0.5,
  s_reps = 100,
  reps = 1000
)
}