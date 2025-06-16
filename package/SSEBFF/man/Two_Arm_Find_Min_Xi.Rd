\name{Two_Arm_Find_Min_Xi}
\alias{Two_Arm_Find_Min_Xi}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Find Minimum Posterior Probability (Xi) for a Fixed Difference in Two-Arm Bayesian Test}
\description{
  For a fixed difference in outcomes between treatment and control groups, this function finds the outcome pair (y1, y2) that yields the minimum posterior probability \code{xi}.
}
\usage{
Two_Arm_Find_Min_Xi(yd, n, delta, 
                    a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, 
                    q = 0.5, sim = 10000)
}
\arguments{
  \item{yd}{Fixed difference in observed successes: \code{y1 - y2}.}
  \item{n}{Sample size per group.}
  \item{delta}{Threshold for meaningful treatment effect.}
  \item{a1}{Alpha parameter of the Beta prior for the treatment group.}
  \item{b1}{Beta parameter of the Beta prior for the treatment group.}
  \item{a2}{Alpha parameter of the Beta prior for the control group.}
  \item{b2}{Beta parameter of the Beta prior for the control group.}
  \item{q}{Prior belief that the alternative hypothesis is true (default 0.5).}
  \item{sim}{Number of simulations to use in posterior probability estimation.}
}
\details{
  Iterates through all valid combinations of \code{y1} and \code{y2} satisfying \code{y1 - y2 = yd}, computes posterior probabilities using \code{Two_Arm_Post_Prob_H1_Sim}, and identifies the pair with the lowest \code{xi}.
}
\value{
  A list with components:
  \itemize{
    \item{\code{y1}}{Treatment group success count with minimum xi.}
    \item{\code{y2}}{Control group success count such that \code{y1 - y2 = yd}.}
    \item{\code{min_xi}}{The minimum posterior probability among all such pairs.}
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
Two_Arm_Find_Min_Xi(yd = 5, n = 50, delta = 0.05)
}