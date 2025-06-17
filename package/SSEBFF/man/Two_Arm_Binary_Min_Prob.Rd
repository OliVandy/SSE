\name{Two_Arm_Binary_Min_Prob}
\alias{Two_Arm_Binary_Min_Prob}
\title{
  Minimum Posterior Probability for Given Difference in Binary Outcomes
}
\description{
  For a given observed difference in responders, finds the worst-case (minimum) posterior probability across all valid combinations of treatment and control responses that yield that difference.
}
\usage{
Two_Arm_Binary_Min_Prob(diff, n, margin,
                        alpha1 = 0.5, beta1 = 0.5,
                        alpha2 = 0.5, beta2 = 0.5,
                        prior_weight = 0.5,
                        iterations = 10000)
}
\arguments{
  \item{diff}{Observed difference in responder counts: tr - ct.}
  \item{n}{Sample size per arm.}
  \item{margin}{Margin for superiority or non-inferiority.}
  \item{alpha1, beta1}{Prior Beta parameters for treatment group.}
  \item{alpha2, beta2}{Prior Beta parameters for control group.}
  \item{prior_weight}{Posterior weight adjustment factor.}
  \item{iterations}{Number of posterior draws.}
}
\details{
For a fixed sample size and an assumed observed difference in response counts, this function finds the \emph{worst-case} posterior probability—that is, the lowest posterior probability across all possible (tr, ct) pairs where the difference \code{tr - ct = diff} and both counts are valid (i.e., between 0 and \code{n}).

This is useful in trial planning and design because it ensures that the decision rule (e.g., whether the posterior exceeds a threshold) is conservative across all possible outcome combinations consistent with the assumed effect size.

In conjunction with \code{BESS_binary()}, this function supports robust sample size planning under uncertainty and variation in observed outcomes.
}
\value{
  A list with:
  \item{tr}{Treatment responder count (worst-case).}
  \item{ct}{Control responder count (worst-case).}
  \item{min_prob}{Minimum posterior probability observed for the given difference.}
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
Two_Arm_Binary_Min_Prob(
  diff = 5,
  n = 30,
  margin = 0.05
)
}