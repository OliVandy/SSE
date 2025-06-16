\name{Two_Arm_Post_Prob_H1}
\alias{Two_Arm_Post_Prob_H1}
\title{Posterior Probability That Treatment Exceeds Control by a Margin (Binary Outcome)}
\description{
Computes the posterior probability that the treatment arm outperforms the control arm by more than a specified margin using Beta-binomial priors.
}
\usage{
Two_Arm_Post_Prob_H1(
  obs_t, obs_c, sample_size, margin,
  alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
  prior_weight = 0.5, iterations = 10000
)
}
\arguments{
  \item{obs_t}{Number of successes in the treatment arm.}
  \item{obs_c}{Number of successes in the control arm.}
  \item{sample_size}{Sample size per arm.}
  \item{margin}{Threshold (margin) for declaring superiority.}
  \item{alpha1, beta1}{Beta prior parameters for the treatment arm.}
  \item{alpha2, beta2}{Beta prior parameters for the control arm.}
  \item{prior_weight}{Weight for adjusting the posterior probability (default 0.5 = no adjustment).}
  \item{iterations}{Number of posterior samples.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A scalar: posterior probability that \eqn{p_{treat} - p_{control} > \text{margin}}, optionally adjusted by \code{prior_weight}.
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
Two_Arm_Post_Prob_H1(obs_t = 18, obs_c = 10, sample_size = 30, margin = 0.05)
}