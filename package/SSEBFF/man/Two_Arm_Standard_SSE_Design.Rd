\name{Two_Arm_Standard_SSE_Design}
\alias{Two_Arm_Standard_SSE_Design}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Standard Frequentist Two‑Arm Design with Optional Interim Bayesian Stop}
\description{
Simulates a two‑arm clinical trial with binary outcomes.  
The design supports an optional interim look that applies a Bayesian error‑spending rule; otherwise, the final decision is based on a traditional frequentist z‑test against a non‑inferiority/superiority margin.
}
\usage{
Two_Arm_Standard_SSE_Design(
  n_f, theta_H, theta_L, theta_s, alpha,
  interim = FALSE, n_0 = NA,
  a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
  q = 0.5, c = 0.7, c_s = 0.3
)
}
\arguments{
  \item{n_f}{Final (maximum) sample size per arm.}
  \item{theta_H}{True success probability in the \emph{treatment} arm.}
  \item{theta_L}{True success probability in the \emph{control} arm.}
  \item{theta_s}{Clinically meaningful difference (margin) to be added to the z‑statistic.  
                 Positive values test superiority of treatment over control by at least \code{theta_s}.}
  \item{alpha}{One‑sided Type I error rate for the final frequentist test.}
  \item{interim}{Logical; \code{TRUE} performs a Bayesian interim analysis after \code{n_0} patients/arm.}
  \item{n_0}{Interim sample size per arm (required only if \code{interim = TRUE}).}
  \item{a1, b1}{Beta(\code{a1},\code{b1}) prior parameters for the treatment arm.}
  \item{a2, b2}{Beta(\code{a2},\code{b2}) prior parameters for the control arm.}
  \item{q}{Prior probability that the treatment is superior (\code{H1}); used in the Bayesian interim look.}
  \item{c}{Posterior‑probability threshold for early success at interim.}
  \item{c_s}{Posterior‑probability threshold for early futility at interim.}
}
\value{
A numeric vector of length 4:  
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
## one simulated study without interim look
Two_Arm_Standard_SSE_Design(
  n_f     = 100,
  theta_H = 0.65,
  theta_L = 0.50,
  theta_s = 0.10,
  alpha   = 0.025
)

## same design with a Bayesian interim at 50 patients/arm
Two_Arm_Standard_SSE_Design(
  n_f     = 100,
  theta_H = 0.65,
  theta_L = 0.50,
  theta_s = 0.10,
  alpha   = 0.025,
  interim = TRUE,
  n_0     = 50
)
}