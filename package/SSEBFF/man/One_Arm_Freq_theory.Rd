\name{One_Arm_Freq_theory}
\alias{One_Arm_Freq_theory}
\title{Theoretical Sample Size Calculation for One-Arm Binomial Test}
\description{
  Calculates the minimum required sample size for a one-arm binomial test based on theoretical (normal approximation) formulas.
}
\usage{
One_Arm_Freq_theory(alpha, beta, theta, theta_star)
}
\arguments{
  \item{alpha}{Significance level (Type I error rate), usually 0.05.}
  \item{beta}{Type II error rate (1 - power), usually 0.2 for 80\% power.}
  \item{theta}{The true proportion under the alternative hypothesis.}
  \item{theta_star}{The null hypothesis proportion.}
}
\value{
  An integer representing the minimum sample size required to achieve the specified alpha and beta.
}
\details{
  This function uses the normal approximation to the binomial distribution to estimate the required sample size for hypothesis testing. It assumes large-sample conditions and computes the sample size analytically.
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
One_Arm_Freq_theory(alpha = 0.05, beta = 0.2, theta = 0.6, theta_star = 0.5)
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