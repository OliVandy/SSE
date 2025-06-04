\name{One_Arm_Normal_Post_Prob}
\alias{One_Arm_Normal_Post_Prob}
\title{Posterior Probability Under Normal-Normal Model}
\description{
Computes the posterior probability that a parameter exceeds a threshold using a conjugate normal prior and likelihood model.
}
\usage{
One_Arm_Normal_Post_Prob(sample_size, threshold, effect_size, prior_mean, prior_sd, sigma, quant = 0.5)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sample_size}{Number of observations.}
  \item{threshold}{Threshold value for hypothesis testing.}
  \item{effect_size}{Observed effect.}
  \item{prior_mean}{Prior mean.}
  \item{prior_sd}{Prior standard deviation.}
  \item{sigma}{Standard deviation of data.}
  \item{quant}{Prior probability for \code{H1}, between 0 and 1.}
}
\value{
Posterior or transformed probability that parameter exceeds the threshold.
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
One_Arm_Normal_Post_Prob(30, 0.5, 0.7, 0, 1, 1)
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
