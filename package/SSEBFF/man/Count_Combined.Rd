\encoding{UTF-8}
\name{Count_combined}
\alias{Count_Post_Prob}
\alias{Count_Sample_Size}
\title{
  Count Outcome: Gamma-Poisson Model for One and Two-Arm Trials
}
\description{
  The posterior probability is the probability of the alternative hypothesis: in this case, that the count of the treatment group has a higher event rate than count control.\cr
  1. Post Prob: Computes the posterior probability that the treatment event rate exceeds the control rate by a threshold using Gamma priors and Poisson likelihoods.\cr
  2. Sample Size: Computes the minimum sample size needed to achieve a posterior probability of superiority greater than or equal to a critical threshold, under a Gamma-Poisson model for count outcomes.
}
\usage{
Count_Post_Prob(type = "one.sample",
                threshold,
                sample_size,
                count_treat = NULL,
                count_ctrl = NULL,
                total_count = NULL,
                a_t = 0.5, b_t = 0.5,
                a_c = 0.5, b_c = 0.5,
                quant = 0.5,
                simulations = 10000)
Count_Sample_Size(type = "one.sample",
                  threshold,
                  crit,
                  effect_size,
                  a_t = 0.5, b_t = 0.5,
                  a_c = 0.5, b_c = 0.5,
                  min_n = 5, max_n = 100,
                  quant = 0.5,
                  sim = 10000, s_reps = 1000)
}
\arguments{
  \item{type}{Character string. Type of test: \code{"one.sample"} or \code{"two.sample"}.}
  \item{effect_size}{Assumed difference in means between treatment and control.}
  \item{sample_size}{Sample size per arm.}
  \item{threshold}{Minimum difference in rates to be declared effective.}
  \item{a_t}{Shape parameter for the Gamma prior on treatment group rate.}
  \item{b_t}{Rate parameter for the Gamma prior on treatment group rate.}
  \item{a_c}{Shape parameter for the Gamma prior on control group rate.}
  \item{b_c}{Rate parameter for the Gamma prior on control group rate.}
  \item{quant}{Weighting factor for quantile posterior adjustment (default is 0.5, i.e., no adjustment).}
  \item{s_reps}{Number of simulations for prior sampling (default 10000).}
  \item{sim}{Number of posterior simulations per trial (default 10000).}
  \item{count_treat}{Number of events in the treatment group.}
  \item{count_ctrl}{Number of events in the control group.}
  \item{total_count}{Total combined count for one-sample testing.}
  \item{simulations}{Number of posterior draws.}
  \item{crit}{Minimum acceptable posterior probability for design success.}
  \item{min_n}{Minimum sample size to consider (default 5).}
  \item{max_n}{Maximum sample size to consider (default 100).}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  A scalar (posterior probability) for \code{Count_Post_Prob}, or a list for \code{Count_Sample_Size} containing:
  \describe{
    \item{\code{n}}{The smallest sample size for which the posterior probability exceeds \code{crit}.}
    \item{\code{yd}}{The expected number of events under the chosen sample size.}
    \item{\code{n_seq}}{Vector of all \code{n} values evaluated from \code{min_n} to \code{max_n}.}
    \item{\code{prob_h1_vec}}{Posterior probabilities for each evaluated \code{n}.}
    \item{\code{yd_vec}}{Vector of expected total event counts for each \code{n}.}
    \item{\code{y1_vec, y2_vec}}{(Two-arm only) Event counts in treatment and control arms achieving the minimal posterior for each \code{n}.}
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
# One-arm
Count_Post_Prob(type = "one.sample", total_count = 45, sample_size = 20,
                threshold = 2.5, a_t = 0.5, b_t = 0.5)

# Two-arm
Count_Post_Prob(type = "two.sample", count_treat = 30, count_ctrl = 20,
                sample_size = 20, threshold = 1.5,
                a_t = 0.5, b_t = 0.5, a_c = 0.5, b_c = 0.5)
                
# One-arm count sample size
Count_Sample_Size(type = "one.sample",
                  threshold = 2,
                  crit = 0.8,
                  effect_size = 0.15,
                  a_t = 0.5, b_t = 0.5)

# Two-arm count sample size
Count_Sample_Size(type = "two.sample",
                  threshold = 1,
                  crit = 0.9,
                  effect_size = 0.25,
                  a_t = 0.5, b_t = 0.5, a_c = 0.5, b_c = 0.5)
}