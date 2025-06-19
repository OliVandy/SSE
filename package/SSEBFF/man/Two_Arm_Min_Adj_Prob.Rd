\name{Two_Arm_Min_Adj_Prob}
\alias{Two_Arm_Min_Adj_Prob}
\title{Minimum Adjusted Posterior Probability Across Outcomes for Given Difference}
\description{
Searches all outcome combinations with a fixed success difference and returns the one with the smallest adjusted posterior probability.
}
\usage{
Two_Arm_Min_Adj_Prob(
  diff, sample_size, margin,
  alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
  prior_weight = 0.5, iterations = 10000
)
}
\arguments{
  \item{diff}{Target difference between treatment and control success counts.}
  \item{sample_size}{Sample size per arm.}
  \item{margin}{Superiority margin.}
  \item{alpha1, beta1, alpha2, beta2}{Beta prior parameters for treatment and control arms.}
  \item{prior_weight}{Weight for adjusting the posterior probability.}
  \item{iterations}{Number of posterior samples.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A list with elements:
\itemize{
  \item{\code{treat}}: Number of treatment successes
  \item{\code{ctrl}}: Number of control successes
  \item{\code{min_prob}}: Minimum adjusted posterior probability
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
# Find the outcome with the lowest adjusted posterior prob for a difference of 2
res = Two_Arm_Min_Adj_Prob(
  diff = 2, sample_size = 30, margin = 0.05,
  alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
  prior_weight = 0.5, iterations = 1000
)
print(res)
}