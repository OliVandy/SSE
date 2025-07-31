\encoding{UTF-8}
\name{BESS_SSR_Design}
\alias{BESS_SSR_Design}
\title{Bayesian Error Spending Strategy with Sample Size Re-Estimation for one and two-arm trials}
\description{
  Implements an adaptive Bayesian sample size re-estimation (SSR) design for both one-arm and two-arm trials with support for binary, continuous, and count outcomes. This function performs an interim analysis and determines whether the trial should stop early for success or futility, or continue with an updated sample size based on posterior predictive evidence.
}
\usage{
BESS_SSR_Design(type = "two.sample",
                theta_H = NULL, theta_L = NULL, theta_s,
                c, c_s, n0,
                outcome = NULL,
                a = 0.5, b = 0.5, sig = 1,
                a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
                q = 0.5, n_min = 1, n_max = 200,
                cap = FALSE, n_cap = 200)
}
\arguments{
  \item{type}{Character string. Trial type: either \code{"one.sample"} or \code{"two.sample"}.}
  \item{theta_H}{True success probability in the treatment group.}
  \item{theta_L}{True success probability in the control group.}
  \item{theta_s}{Clinically meaningful difference (margin) between treatment and control.}
  \item{c}{Posterior probability threshold for early success.}
  \item{c_s}{Posterior probability threshold for early futility.}
  \item{n0}{Initial sample size per group for interim analysis.}
  \item{a, b}{Numerics. Prior hyperparameters for one-arm models. Used in binary and count models as Beta/Gamma priors.}
  \item{a1}{Alpha hyperparameter for Beta prior of the control group (default 0.05).}
  \item{b1}{Beta hyperparameter for Beta prior of the control group (default 0.05).}
  \item{a2}{Alpha hyperparameter for Beta prior of the treatment group (default 0.05).}
  \item{b2}{Beta hyperparameter for Beta prior of the treatment group (default 0.05).}
  \item{sig}{Standard deviation of the outcome for continuous-type models. Used when \code{type = "continuous"}.}
  \item{q}{Prior belief (weight) for treatment effect being positive (default 0.5).}
  \item{n_min}{Minimum sample size to be considered in re-estimation (default 1).}
  \item{n_max}{Maximum sample size allowed in re-estimation (default 200).}
  \item{cap}{Logical. Whether to cap the total sample size at \code{n_cap}.}
  \item{n_cap}{Maximum total sample size if \code{cap = TRUE} (default 200).}
  \item{outcome}{Integer. Type of outcome:
    \itemize{
      \item \code{1}: Binary outcome
      \item \code{2}: Continuous outcome
      \item \code{3}: Count outcome
    }
  }
}
\details{
  The function simulates an interim analysis of the trial using posterior probabilities under a Bayesian framework. Depending on the calculated posterior probability of the treatment being superior to control (or exceeding a threshold in one-arm trials), the function:
  \itemize{
    \item Stops early for success if posterior probability \code{>= c}
    \item Stops early for futility if posterior probability \code{<= c_s}
    \item Otherwise, continues enrollment with a newly calculated additional sample size using a BESS utility
  }
  Outcome types:
  \itemize{
    \item Binary outcomes use the Beta-binomial model
    \item Continuous outcomes assume Normal likelihood and Normal prior
    \item Count outcomes assume Poisson-Gamma conjugacy
  }

  For two-arm designs, each arm’s posterior is updated separately. For one-arm designs, only the treatment arm is modeled.
}
\value{
  A list with elements depending on the design type:
  
  \describe{
    \item{One-sample design}{
      \describe{
        \item{\code{y_n0}}{Observed interim data}
        \item{\code{pH1_int}}{Posterior probability at interim}
        \item{\code{bess_int_dec}}{Interim decision: 1 = stop for success, 0 = stop for futility, 2 = continue}
        \item{\code{y_ns}}{Simulated additional data (if continued)}
        \item{\code{e_s}}{Posterior mean after interim}
        \item{\code{n_s}}{Re-estimated additional sample size}
        \item{\code{pH1_s}}{Posterior probability at final}
        \item{\code{bess_fin_dec}}{Final decision: 1 = success, 0 = futility}
      }
    }
    
    \item{Two-sample design}{
      \describe{
        \item{\code{y_H_n0}, \code{y_L_n0}}{Observed interim data for experimental/control groups}
        \item{\code{pH1_int}}{Posterior probability at interim}
        \item{\code{bess_int_dec}}{Interim decision: 1 = stop for success, 0 = stop for futility, 2 = continue}
        \item{\code{y_H_ns}, \code{y_L_ns}}{Simulated additional data (if continued)}
        \item{\code{e_s}}{Posterior mean difference after interim}
        \item{\code{n_s}}{Re-estimated additional sample size}
        \item{\code{pH1_s}}{Posterior probability at final}
        \item{\code{bess_fin_dec}}{Final decision: 1 = success, 0 = futility}
      }
    }
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
\seealso{
\code{\link{Post_Prob_Bayes}}
}
\examples{
BESS_SSR_Design(type = "two.sample", theta_H = 0.7, theta_L = 0.5,
                theta_s = 0.1, c = 0.9, c_s = 0.2, n0 = 50,
                outcome = 1)

# One-arm count outcome
BESS_SSR_Design(type = "one.sample", theta_H = 5,
                theta_s = 4, c = 0.95, c_s = 0.1, n0 = 60,
                outcome = 3)
}