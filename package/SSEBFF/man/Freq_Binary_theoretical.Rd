\name{Freq_Binary_theoretical}
\alias{Freq_Binary_theoretical}
\title{Frequentist Sample Size Calculation for Binary Outcomes}
\description{
Calculates the required sample size per arm for a binary outcome test (either one-sample or two-sample), using frequentist normal approximation formulas.
}
\usage{
Freq_Binary_theoretical(alpha, beta, theta1, theta0, type = "two.sample")
}
\arguments{
  \item{alpha}{Significance level (type I error rate), e.g., 0.05.}
  \item{beta}{Type II error rate (1 - power), e.g., 0.2.}
  \item{theta1}{Expected proportion in the treatment group.}
  \item{theta0}{Proportion under the null hypothesis (or in the control group).}
  \item{type}{Type of test: \code{"one.sample"} or \code{"two.sample"}.}
}
\details{
Uses normal approximation for proportions:
\itemize{
  \item Two-sample formula uses pooled variance across treatment and control groups.
  \item One-sample formula uses variance of the treatment group only.
}
If an invalid type is provided, a warning is issued.
}
\value{
An integer: the calculated sample size per group (or for the total in a one-sample test).
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
Freq_Binary_theoretical(alpha = 0.05, beta = 0.2, theta1 = 0.6, theta0 = 0.5)
}