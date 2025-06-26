\name{Two_Arm_Count_Min_Effect}
\alias{Two_Arm_Count_Min_Effect}
\title{
  Minimum Posterior Probability for Count Outcome
}
\description{
  Simulates Gamma-Poisson outcomes to determine the minimum posterior probability of superiority over many random realizations of the control rate.
}
\usage{
Two_Arm_Count_Min_Effect(effect_size, sample_size, threshold,
                         a_t, b_t, a_c, b_c,
                         quant = 0.5, s_reps = 1e4, reps = 1e4)
}
\arguments{
  \item{effect_size}{Assumed treatment effect (difference in mean rates).}
  \item{sample_size}{Sample size per group.}
  \item{threshold}{Threshold for treatment superiority.}
  \item{a_t}{Shape parameter for treatment rate prior.}
  \item{b_t}{Rate parameter for treatment rate prior.}
  \item{a_c}{Shape parameter for control rate prior.}
  \item{b_c}{Rate parameter for control rate prior.}
  \item{quant}{Posterior adjustment factor (default 0.5).}
  \item{s_reps}{Number of prior control rate simulations.}
  \item{reps}{Posterior draws per simulated trial.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A list with elements:
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