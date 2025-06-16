\name{Two_Arm_t_test_sim}
\alias{Two_Arm_t_test_sim}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Simulated Sample Size Estimation for Two-Sample t-Test}
\description{
  Estimates the minimum sample size per group using simulation to satisfy Type I and Type II error constraints for a two-sample t-test.
}
\usage{
Two_Arm_t_test_sim(alpha, beta, mu1, mu0, sigma1 = 1, sigma0 = 1, 
                   nmin = 10, nmax = 5000, sims = 10000)
}
\arguments{
  \item{alpha}{Significance level (Type I error rate).}
  \item{beta}{Type II error rate (1 - power).}
  \item{mu1}{Mean under the alternative hypothesis.}
  \item{mu0}{Mean under the null hypothesis.}
  \item{sigma1}{Standard deviation of the treatment group (default is 1).}
  \item{sigma0}{Standard deviation of the control group (default is 1).}
  \item{nmin}{Minimum sample size per group to check (default is 10).}
  \item{nmax}{Maximum sample size per group to consider (default is 5000).}
  \item{sims}{Number of simulations per sample size (default is 10000).}
}
\details{
  For each sample size in the range from \code{nmin} to \code{nmax}, the function simulates independent samples under both null and alternative hypotheses. Welch’s t-test is used to calculate test statistics and error rates.
}
\value{
  Returns the smallest sample size per group such that both Type I and Type II error constraints are satisfied.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Rachel Zhuang
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
Two_Arm_t_test_sim(alpha = 0.05, beta = 0.2, mu1 = 1, mu0 = 0, sigma1 = 1, sigma0 = 1)
}