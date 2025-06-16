\name{Two_Arm_Freq_theory}
\alias{Two_Arm_Freq_theory}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Theoretical Sample Size for Two-Arm Test (Proportions)}
\description{
  Computes the theoretical minimum sample size per group required for a two-arm comparison of binomial proportions using a normal approximation.
}
\usage{
Two_Arm_Freq_theory(alpha, beta, theta1, theta0)
}
\arguments{
  \item{alpha}{Significance level (Type I error rate), typically 0.05.}
  \item{beta}{Type II error rate (1 - power), typically 0.2 for 80\% power.}
  \item{theta1}{Proportion under the alternative hypothesis.}
  \item{theta0}{Proportion under the null hypothesis.}
}
\details{
  This function uses the normal approximation for binomial distributions to derive the required sample size analytically for a two-arm test of proportions.
}
\value{
  Returns an integer: the theoretical minimum sample size per group needed to detect a difference between \code{theta1} and \code{theta0} with the specified error rates.
}
\examples{
Two_Arm_Freq_theory(alpha = 0.05, beta = 0.2, theta1 = 0.6, theta0 = 0.5)
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Rachel Zhuang <rachel-zhuang1@hotmail.com>
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
Two_Arm_Freq_theory(alpha = 0.05, beta = 0.2, theta1 = 0.6, theta0 = 0.5)
}