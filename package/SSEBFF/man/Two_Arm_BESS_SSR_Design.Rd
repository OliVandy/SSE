\name{Two_Arm_BESS_SSR_Design}
\alias{Two_Arm_BESS_SSR_Design}
\title{Bayesian Error Spending Strategy with Sample Size Re-Estimation for Binary Two-Arm Trials}
\description{
  Performs a Bayesian Estimator of Sample Size (BESS) with interim analysis and optional sample size re-estimation for a binary outcome two-arm clinical trial.
}
\usage{
Two_Arm_BESS_SSR_Design(theta_H, theta_L, theta_s, c, c_s, n0,
                        a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
                        q = 0.5, n_min = 1, n_max = 200, cap = FALSE, n_cap = 200)
}
\arguments{
  \item{theta_H}{True success probability in the treatment group.}
  \item{theta_L}{True success probability in the control group.}
  \item{theta_s}{Clinically meaningful difference (margin) between treatment and control.}
  \item{c}{Posterior probability threshold for early success.}
  \item{c_s}{Posterior probability threshold for early futility.}
  \item{n0}{Initial sample size per group for interim analysis.}
  \item{a1}{Alpha hyperparameter for Beta prior of the control group (default 0.05).}
  \item{b1}{Beta hyperparameter for Beta prior of the control group (default 0.05).}
  \item{a2}{Alpha hyperparameter for Beta prior of the treatment group (default 0.05).}
  \item{b2}{Beta hyperparameter for Beta prior of the treatment group (default 0.05).}
  \item{q}{Prior belief (weight) for treatment effect being positive (default 0.5).}
  \item{n_min}{Minimum sample size to be considered in re-estimation (default 1).}
  \item{n_max}{Maximum sample size allowed in re-estimation (default 200).}
  \item{cap}{Logical. Whether to cap the total sample size at \code{n_cap}.}
  \item{n_cap}{Maximum total sample size if \code{cap = TRUE} (default 200).}
}
\details{
  This function conducts a BESS-based two-arm trial with:
  \enumerate{
    \item Interim analysis using initial sample \code{n0}.
    \item Stopping for success if posterior probability > \code{c}, or futility if < \code{c_s}.
    \item If continuing, it estimates additional sample size required via the \code{Two_Arm_BESS_Binary} procedure.
    \item Final analysis decision is based on posterior probability from the additional data.
  }
}
\value{
  A list containing:
  \itemize{
    \item{\code{y_H_n0}}{Vector of simulated successes in the treatment group from interim.}
    \item{\code{y_L_n0}}{Vector of simulated successes in the control group from interim.}
    \item{\code{pH1_int}}{Posterior probability of superiority at interim.}
    \item{\code{bess_int_dec}}{Interim decision: 1 = success, 0 = futility, 2 = continue.}
    \item{\code{y_H_ns}}{Vector of simulated successes in treatment group after re-estimation.}
    \item{\code{y_L_ns}}{Vector of simulated successes in control group after re-estimation.}
    \item{\code{e_s}}{Posterior expected difference used in re-estimation.}
    \item{\code{n_s}}{Additional sample size calculated during re-estimation.}
    \item{\code{pH1_s}}{Posterior probability of superiority at final analysis.}
    \item{\code{bess_fin_dec}}{Final decision: 1 = success, 0 = futility (if interim = 2).}
  }
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
Two_Arm_BESS_SSR_Design(theta_H = 0.6, theta_L = 0.4, theta_s = 0.1,
                        c = 0.95, c_s = 0.05, n0 = 20)
}