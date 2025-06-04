\name{One_Arm_Post_Prob_Theta}
\alias{One_Arm_Post_Prob_Theta}
\title{Posterior Probability that Theta > Theta0 for One-Arm Study}
\description{
Computes the posterior probability that the parameter \code{theta} exceeds a specified threshold \code{theta0} for binary, continuous, or count data using Bayesian updating.
}
\usage{
One_Arm_Post_Prob_Theta(n, theta0, e, outcome, a, b, sig = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{Sample size.}
  \item{theta0}{Threshold value of interest for theta.}
  \item{e}{Observed evidence or effect.}
  \item{outcome}{Type of outcome: 1 = binary, 2 = continuous, 3 = count.}
  \item{a}{Prior parameter alpha or prior mean (continuous).}
  \item{b}{Prior parameter beta or prior standard deviation (continuous).}
  \item{sig}{Standard deviation of the data (for continuous outcomes). Default is 1.}
}
\value{
Returns a posterior probability \code{Pr(theta > theta0)}.
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or standard data sets, see data().

## The function is currently defined as
One_Arm_Post_Prob_Theta(30, 0.5, 0.6, 1, 1, 1)
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