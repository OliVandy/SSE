\name{Two_Arm_Count_Post_Prob}
\alias{Two_Arm_Count_Post_Prob}
\title{
  Posterior Probability for Count Outcomes (Gamma-Poisson)
}
\description{
  Computes the posterior probability that the difference between treatment and control group rates exceeds a threshold under Gamma-Poisson priors.
}
\usage{
Two_Arm_Count_Post_Prob(count_treat, count_ctrl, sample_size,
                        threshold, a_t, b_t, a_c, b_c,
                        quant = 0.5, simulations = 1e4)
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
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  Posterior probability that treatment rate exceeds control by more than the threshold.
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
}