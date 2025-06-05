\name{One_Arm_Freq_cont}
\alias{One_Arm_Freq_cont}
\title{Monte Carlo-Based Sample Size Calculation for One-Arm Binomial Test}
\description{
  Estimates the minimum required sample size using simulations to meet Type I and Type II error constraints for a one-arm binomial test.
}
\usage{
One_Arm_Freq_cont(alpha, beta, theta, theta_star, nmin = 10, nmax = 5000, sims = 10000)
}
\arguments{
  \item{alpha}{Significance level (Type I error rate).}
  \item{beta}{Type II error rate (1 - power).}
  \item{theta}{True proportion under the alternative hypothesis.}
  \item{theta_star}{Proportion under the null hypothesis.}
  \item{nmin}{Minimum sample size to start checking from (default is 10).}
  \item{nmax}{Maximum sample size to consider (default is 5000).}
  \item{sims}{Number of Monte Carlo simulations per sample size (default is 10000).}
}
\value{
  The minimum integer sample size \(n\) that satisfies both error rate criteria.
}
\details{
  This function simulates binomial trials under both the null and alternative hypotheses to empirically check whether the Type I and Type II errors are within the specified bounds. It increases the sample size from \code{nmin} to \code{nmax} until both conditions are met.
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
One_Arm_Freq_cont(alpha = 0.05, beta = 0.2, theta = 0.6, theta_star = 0.5)
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