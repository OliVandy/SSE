\name{One_Arm_Normal_Sample_Size}
\alias{One_Arm_Normal_Sample_Size}
\title{Sample Size Estimation for Normal-Normal Posterior}
\description{
Finds the minimum sample size such that the posterior probability under the normal-normal model exceeds a specified threshold.
}
\usage{
One_Arm_Normal_Sample_Size(threshold, crit, effect_size, prior_mean, prior_sd, min_n = 5, max_n = 100, quant = 0.5, sigma = 1)
}
\arguments{
  \item{threshold}{Critical threshold for testing.}
  \item{crit}{Posterior probability cutoff to exceed.}
  \item{effect_size}{Observed or assumed effect size.}
  \item{prior_mean}{Prior mean.}
  \item{prior_sd}{Prior standard deviation.}
  \item{min_n}{Minimum sample size to try.}
  \item{max_n}{Maximum sample size to try.}
  \item{quant}{Prior probability of \code{H1}.}
  \item{sigma}{Standard deviation of outcome.}
}
\value{
Returns a list with:
  \itemize{
    \item \code{n}: Required sample size.
    \item \code{prob}: Posterior probability at that sample size.
    \item \code{prob_h1_vec}: Vector of posterior probabilities across all n values.
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
One_Arm_Normal_Sample_Size(0.5, 0.9, 0.6, 0, 1)
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