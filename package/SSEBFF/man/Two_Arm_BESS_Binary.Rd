\name{Two_Arm_BESS_Binary}
\alias{Two_Arm_BESS_Binary}
\title{Sample Size Estimation Using Bayesian Estimator of Sample Size (BESS) for Binary Outcomes in Two-Arm Trials}
\description{
  Determines the minimum sample size required in a two-arm trial with binary outcomes, using a Bayesian error spending strategy (BESS) approach. This is based on controlling the posterior probability \code{xi} to exceed a cutoff value \code{c} when the observed treatment effect exceeds a certain proportion \code{e}.
}
\usage{
Two_Arm_BESS_Binary(theta0, c, e, n_min, n_max,
                    a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
                    q = 0.5, sim = 10000)
}
\arguments{
  \item{theta0}{Null hypothesis success rate (reference threshold for comparison).}
  \item{c}{Cutoff for posterior probability \code{xi} to be exceeded.}
  \item{e}{Proportion of observed treatment difference to use (typically between 0 and 1).}
  \item{n_min}{Minimum sample size to begin the search.}
  \item{n_max}{Maximum sample size to stop the search if criteria are not met.}
  \item{a1}{Alpha parameter for Beta prior of the treatment group.}
  \item{b1}{Beta parameter for Beta prior of the treatment group.}
  \item{a2}{Alpha parameter for Beta prior of the control group.}
  \item{b2}{Beta parameter for Beta prior of the control group.}
  \item{q}{Prior belief that the treatment is better than control (default 0.5).}
  \item{sim}{Number of simulations to approximate posterior probability (default 10000).}
}
\details{
  The function iteratively increases the sample size starting from \code{n_min} and computes the minimum posterior probability \code{xi} for an observed difference \code{yd = floor(e * n)} using \code{Two_Arm_Find_Min_Xi}. The smallest sample size for which the posterior probability exceeds \code{c} is returned.
}
\value{
  A list with components:
  \itemize{
    \item{\code{n}}{The estimated minimum sample size that meets the BESS criterion.}
    \item{\code{yd}}{The required minimum observed difference in outcomes.}
    \item{\code{n_seq}}{The sequence of sample sizes evaluated from \code{n_min} to \code{n_max}.}
    \item{\code{vec}}{Posterior probabilities \code{xi} for each evaluated sample size.}
    \item{\code{yd_vec}}{List of required observed differences \code{yd} for each \code{n}.}
    \item{\code{y1_vec}}{Corresponding treatment group success values.}
    \item{\code{y2_vec}}{Corresponding control group success values.}
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
Two_Arm_BESS_Binary(theta0 = 0.2, c = 0.9, e = 0.2, n_min = 30, n_max = 300)
}