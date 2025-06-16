\name{Two_Arm_Gamma_Min_Effect}
\alias{Two_Arm_Gamma_Min_Effect}
\title{
  Minimum Posterior Probability under Gamma Model
}
\description{
  Simulates outcomes under a Gamma-Poisson model to find the minimum posterior probability of superiority for a given sample size and effect size, assuming the control rate is drawn from a Gamma prior.
}
\usage{
Two_Arm_Gamma_Min_Effect(effect_size, sample_size, threshold,
                          a_t, b_t, a_c, b_c, quant = 0.5,
                          s_reps = 10000, reps = 10000)
}
\arguments{
  \item{effect_size}{The assumed treatment effect (difference in means).}
  \item{sample_size}{Sample size per arm.}
  \item{threshold}{Posterior probability threshold for superiority.}
  \item{a_t}{Shape parameter for the Gamma prior on treatment group rate.}
  \item{b_t}{Rate parameter for the Gamma prior on treatment group rate.}
  \item{a_c}{Shape parameter for the Gamma prior on control group rate.}
  \item{b_c}{Rate parameter for the Gamma prior on control group rate.}
  \item{quant}{Weighting factor for posterior adjustment (default is 0.5, i.e., no adjustment).}
  \item{s_reps}{Number of simulations for prior sampling (default 10000).}
  \item{reps}{Number of posterior simulations per trial (default 10000).}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A list with elements:
  \item{y1}{Simulated event count for treatment group.}
  \item{y2}{Simulated event count for control group.}
  \item{min_xi}{Minimum posterior probability of superiority observed.}
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
}