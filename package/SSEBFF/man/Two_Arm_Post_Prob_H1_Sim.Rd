\name{Two_Arm_Post_Prob_H1_Sim}
\alias{Two_Arm_Post_Prob_H1_Sim}
\title{Posterior Probability Simulation for Two-Arm Bayesian Comparison}
\description{
  Estimates the posterior probability that the treatment group has a higher success rate than the control group by more than a given threshold \code{delta}, using simulation.
}
\usage{
Two_Arm_Post_Prob_H1_Sim(Y_t, Y_c, n, delta, 
                         a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, 
                         q = 0.5, sim = 10000)
}
\arguments{
  \item{Y_t}{Number of successes in the treatment group.}
  \item{Y_c}{Number of successes in the control group.}
  \item{n}{Sample size per group.}
  \item{delta}{The minimum clinically meaningful difference (threshold) to test.}
  \item{a1}{Alpha parameter of the Beta prior for the treatment group.}
  \item{b1}{Beta parameter of the Beta prior for the treatment group.}
  \item{a2}{Alpha parameter of the Beta prior for the control group.}
  \item{b2}{Beta parameter of the Beta prior for the control group.}
  \item{q}{Prior belief that the alternative hypothesis is true (default 0.5).}
  \item{sim}{Number of Monte Carlo simulations (default 10000).}
}
\details{
  Uses Beta posteriors for both groups, simulates samples, and estimates the proportion of simulations where the treatment effect exceeds \code{delta}.
}
\value{
  Returns the posterior probability \code{Pr(p1 - p2 > delta | data)}. If \code{q != 0.5}, returns a weighted posterior odds ratio based on prior \code{q}.
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
Two_Arm_Post_Prob_H1_Sim(Y_t = 30, Y_c = 20, n = 50, delta = 0.05)
}