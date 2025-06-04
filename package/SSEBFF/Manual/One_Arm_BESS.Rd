\name{One_Arm_BESS}
\alias{One_Arm_BESS}
\title{Bayesian Expected Sample Size Estimation for One-Arm Design}
\description{
Estimates the minimum sample size required for the posterior probability to exceed a specified threshold for binary, continuous, or count outcomes under a one-arm design.
}
\usage{
One_Arm_BESS(theta0, c, e, outcome, a, b, q = 0.5, sig = 1, n_min = 5, n_max = 100)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{theta0}{Threshold of interest.}
  \item{c}{Critical posterior probability cutoff.}
  \item{e}{Effect or evidence.}
  \item{outcome}{1 = binary, 2 = continuous, 3 = count.}
  \item{a}{Prior parameter.}
  \item{b}{Prior parameter.}
  \item{q}{Prior probability of \code{H1}.}
  \item{sig}{Standard deviation of the outcome (for continuous).}
  \item{n_min}{Minimum sample size to consider.}
  \item{n_max}{Maximum sample size to consider.}
}
\value{
Returns a list with:
  \itemize{
    \item \code{n}: Smallest sample size such that posterior probability exceeds \code{c}.
    \item \code{n_seq}: Sequence of sample sizes tested.
    \item \code{vec}: Corresponding posterior probabilities.
    \item \code{m_vec}: Number of "events" (for binary/count) if applicable.
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
One_Arm_BESS(theta0 = 0.5, c = 0.8, e = 0.6, outcome = 1, a = 1, b = 1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
