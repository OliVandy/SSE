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
\describe{
  \item{\code{mean_treat}}{Observed proportion of successes in the treatment arm.}
  \item{\code{mean_ctrl}}{Observed proportion of successes in the control arm.}
  \item{\code{decision}}{Final decision indicator: \code{1} = success, \code{0} = futility.}
  \item{\code{n_total}}{Total sample size actually observed (may be \code{n_0} if stopped early).}
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A numeric vector of length 4:  
\details{
\strong{Without interim look} (\code{interim = FALSE}):  
All \code{n_f} patients per arm are enrolled.  A one‑sided z‑test is computed
\deqn{Z = \frac{\bar{Y}_{\mathrm{ctrl}} - \bar{Y}_{\mathrm{treat}} + \theta_s}
            {\sqrt{\frac{\bar{Y}_{\mathrm{ctrl}}(1-\bar{Y}_{\mathrm{ctrl}}) +
                         \bar{Y}_{\mathrm{treat}}(1-\bar{Y}_{\mathrm{treat}})}{n_f}}}}
and treatment is declared superior if \code{pnorm(Z, lower.tail = FALSE) < alpha}.

\strong{With interim look} (\code{interim = TRUE}):  
After \code{n_0} patients/arm, a Bayesian posterior probability
\eqn{P(H_1 \mid \text{data})} is computed with a Beta–Binomial model
(using \code{Two_Arm_Post_Prob_H1_Sim}).  
\itemize{
  \item If the posterior \(\ge c\): stop early for success.  
  \item If the posterior \(\le c_s\): stop early for futility.  
  \item Otherwise, enrol to \code{n_f} per arm and apply the same z‑test as above.  
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