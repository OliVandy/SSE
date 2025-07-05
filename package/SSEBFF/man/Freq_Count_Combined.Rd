\name{Freq_Count_Combined}
\alias{Freq_Count_Combined}
\title{
Frequentist Sample Size Estimation for Count Data (Gamma-Poisson) 
}
\description{
Performs both theoretical and simulation-based sample size estimation for detecting a difference in means between two Poisson-like count distributions (with optional overdispersion via Gamma-Poisson / Negative Binomial model).
}
\usage{
Freq_Count_Combined(alpha, beta, mu1, mu0, 
                    sig1 = 1, sig0 = 1, 
                    type = "two.sample", 
                    nmin = 10, nmax = 5000, sims = 10000)
}
\arguments{
  \item{alpha}{Significance level (Type I error rate), typically 0.05.}
  \item{beta}{Type II error rate (1 - power), typically 0.2.}
  \item{mu1}{Expected mean count under the alternative hypothesis.}
  \item{mu0}{Mean count under the null hypothesis.}
  \item{sig1}{Dispersion parameter for alternative (mean = mu1, variance = mu1 + mu1^2 / sig1). Default is 1 (Poisson).}
  \item{sig0}{Dispersion parameter for null (mean = mu0, variance = mu0 + mu0^2 / sig0). Default is 1 (Poisson).}
  \item{type}{Type of test: "one.sample" or "two.sample". Default is "two.sample".}
  \item{nmin}{Minimum sample size to consider during simulation.}
  \item{nmax}{Maximum sample size to consider during simulation.}
  \item{sims}{Number of simulation iterations to perform at each sample size.}
}
\details{
This function first computes a theoretical sample size estimate based on normal approximation of the mean difference.

It then performs simulation-based estimation using a Gamma-Poisson (negative binomial) model to generate synthetic data under both the null and alternative hypotheses. The function continues iterating over sample sizes until both Type I and Type II error thresholds are satisfied.

The result includes both the theoretical and empirical (simulation-based) required sample sizes.
}
\value{
A list with the following elements:
  \item{n_theory}{Theoretical sample size estimate based on normal approximation.}
  \item{n_sim}{Estimated sample size from simulations that meets the specified alpha and beta thresholds.}
  \item{type1_error}{Estimated Type I error rate at \code{n_sim}.}
  \item{type2_error}{Estimated Type II error rate at \code{n_sim}.}
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
Freq_Count_Combined(alpha = 0.05, beta = 0.2, 
                    mu1 = 7, mu0 = 5,
                    sig1 = 1, sig0 = 1,
                    type = "two.sample",
                    nmin = 10, nmax = 1000, sims = 5000)

# One-sample test, overdispersed counts
Freq_Count_Combined(alpha = 0.05, beta = 0.1,
                    mu1 = 12, mu0 = 10,
                    sig1 = 0.5, sig0 = 0.5,
                    type = "one.sample",
                    nmin = 5, nmax = 300, sims = 10000)
}