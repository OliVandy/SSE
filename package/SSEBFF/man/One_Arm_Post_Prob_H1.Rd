\name{One_Arm_Post_Prob_H1}
\alias{One_Arm_Post_Prob_H1}
\title{Posterior Probability for H1 Under Different Outcome Types}
\description{
Computes a transformed posterior probability of a hypothesis \code{H1} holding, given the probability that \code{theta > theta0}. Applies to binary, continuous, or count outcomes.
}
\usage{
One_Arm_Post_Prob_H1(n, theta0, e, outcome, a, b, sig = 1, q = 0.5)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{Sample size.}
  \item{theta0}{Threshold value.}
  \item{e}{Evidence/effect size.}
  \item{outcome}{1 = binary, 2 = continuous, 3 = count-data.}
  \item{a}{Prior parameter.}
  \item{b}{Prior parameter.}
  \item{sig}{Standard deviation (used if continuous outcome).}
  \item{q}{Prior probability of \code{H1}. Must be in (0,1).}
}
\value{
Transformed posterior probability for \code{H1}.
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
One_Arm_Post_Prob_H1(50, 0.5, 0.6, 1, 1, 1, q = 0.7)
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