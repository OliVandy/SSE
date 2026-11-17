# Documentation sources for the public API.
# Regenerate man/ and NAMESPACE with devtools::document().

#' @name BESS_SSR_Design
#' @rdname BESS_SSR_Design
#' @aliases BESS_SSR_Design
#' @title Bayesian Estimator of Sample Size with Sample Size Re-Estimation for one and two-arm trials
#' @description Implements an adaptive Bayesian sample size re-estimation (SSR) design for both one-arm and two-arm trials with support for binary, continuous, and count outcomes. This function performs an interim analysis and determines whether the trial should stop early for success or futility, or continue with an updated sample size based on posterior predictive evidence.
#' @rawRd \encoding{UTF-8}
#'
#'
#'
#'
#' \usage{
#' BESS_SSR_Design(type = "two.sample",
#'                 theta_H = NULL, theta_L = NULL, theta_s,
#'                 c, c_s, n0,
#'                 outcome = NULL,
#'                 a = 0.5, b = 0.5, sig = 1,
#'                 a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
#'                 q = 0.5, n_min = 1, n_max = 200,
#'                 cap = FALSE, n_cap = 200)
#' }
#' \arguments{
#'   \item{type}{Character string. Trial type: either \code{"one.sample"} or \code{"two.sample"}.}
#'   \item{theta_H}{True treatment success probability, mean, or event rate, according to outcome type.}
#'   \item{theta_L}{True control success probability, mean, or event rate for a two-arm design.}
#'   \item{theta_s}{One-arm threshold or two-arm non-inferiority margin. The two-arm alternative is treatment minus control greater than minus theta_s.}
#'   \item{c}{Posterior probability threshold for early success.}
#'   \item{c_s}{Posterior probability threshold for early futility.}
#'   \item{n0}{Initial sample size per group for interim analysis.}
#'   \item{a, b}{One-arm beta shapes, normal mean and standard deviation, or gamma shape and rate, according to outcome type.}
#'   \item{a1}{Control prior beta shape, normal mean, or gamma shape.}
#'   \item{b1}{Control prior beta shape, normal standard deviation, or gamma rate.}
#'   \item{a2}{Treatment prior beta shape, normal mean, or gamma shape.}
#'   \item{b2}{Treatment prior beta shape, normal standard deviation, or gamma rate.}
#'   \item{sig}{Known common observation standard deviation for continuous outcomes.}
#'   \item{q}{Prior belief (weight) for treatment effect being positive (default 0.5).}
#'   \item{n_min}{Minimum sample size to be considered in re-estimation (default 1).}
#'   \item{n_max}{Maximum sample size allowed in re-estimation (default 200).}
#'   \item{cap}{Logical. Whether to cap the total sample size at \code{n_cap}.}
#'   \item{n_cap}{Maximum total sample size per arm if cap is TRUE. Must be an integer greater than n0.}
#'   \item{outcome}{Integer. Type of outcome:
#'     \itemize{
#'       \item \code{1}: Binary outcome
#'       \item \code{2}: Continuous outcome
#'       \item \code{3}: Count outcome
#'     }
#'   }
#' }
#' \details{
#'   The function simulates an interim analysis of the trial using posterior probabilities under a Bayesian framework. Depending on the calculated posterior probability of the treatment being superior to control (or exceeding a threshold in one-arm trials), the function:
#'   \itemize{
#'     \item Stops early for success if posterior probability \code{>= c}
#'     \item Stops early for futility if posterior probability \code{<= c_s}
#'     \item Otherwise, continues enrollment with a newly calculated additional sample size using a BESS utility
#'   }
#'   Outcome types:
#'   \itemize{
#'     \item Binary outcomes use the Beta-binomial model
#'     \item Continuous outcomes assume Normal likelihood and Normal prior
#'     \item Count outcomes assume Poisson-Gamma conjugacy
#'   }
#'
#'   Each arm's posterior is updated separately. If the re-estimation criterion
#'   is already met at the lower search bound, the lower bound is used. If it is
#'   unmet at the upper bound, the upper bound is used. The cap is then applied
#'   to additional enrollment. The final posterior probability determines success.
#'   Final-stage outputs are NA when the trial stops at interim.
#' }
#' \value{
#'   A list with elements depending on the design type:
#'   
#'   \describe{
#'     \item{One-sample design}{
#'       \describe{
#'         \item{\code{y_n0}}{Observed interim data}
#'         \item{\code{pH1_int}}{Posterior probability at interim}
#'         \item{\code{bess_int_dec}}{Interim decision: 1 = stop for success, 0 = stop for futility, 2 = continue}
#'         \item{\code{y_ns}}{Simulated additional data (if continued)}
#'         \item{\code{e_s}}{Posterior mean after interim}
#'         \item{\code{n_s}}{Re-estimated additional sample size}
#'         \item{\code{pH1_s}}{Posterior probability at final}
#'         \item{\code{bess_fin_dec}}{Final decision: 1 = success, 0 = futility}
#'       }
#'     }
#'     
#'     \item{Two-sample design}{
#'       \describe{
#'         \item{\code{y_H_n0}, \code{y_L_n0}}{Observed interim data for experimental/control groups}
#'         \item{\code{pH1_int}}{Posterior probability at interim}
#'         \item{\code{bess_int_dec}}{Interim decision: 1 = stop for success, 0 = stop for futility, 2 = continue}
#'         \item{\code{y_H_ns}, \code{y_L_ns}}{Simulated additional data (if continued)}
#'         \item{\code{e_s}}{Posterior mean difference after interim}
#'         \item{\code{n_s}}{Re-estimated additional sample size}
#'         \item{\code{pH1_s}}{Posterior probability at final}
#'         \item{\code{bess_fin_dec}}{Final decision: 1 = success, 0 = futility}
#'       }
#'     }
#'   }
#' }
#' \author{
#' Rachel Zhuang
#' }
#' \seealso{
#' \code{\link{Post_Prob_Bayes}}
#' }
#' \examples{
#' BESS_SSR_Design(type = "two.sample", theta_H = 0.2, theta_L = 0.7,
#'                 theta_s = 0.1, c = 0.9, c_s = 0.2, n0 = 50, outcome = 1)
#'
#' # One-arm count outcome
#' BESS_SSR_Design(type = "one.sample", theta_H = 5,
#'                 theta_s = 4, c = 0.95, c_s = 0.1, n0 = 60,
#'                 outcome = 3)
#' }
NULL

#' @name BESS_unified
#' @rdname BESS_unified
#' @aliases BESS_unified
#' @title Bayesian Estimator of Sample Size (BESS) for One- and Two-Sample Designs
#' @description Estimates the minimum required sample size to achieve a desired posterior probability threshold \code{c} based on Bayesian inference, supporting binary and continuous for one-sample designs, and binary and continuous outcomes for two-sample designs. This is based on controlling the posterior probability \code{xi} to exceed a cutoff value \code{c} when the observed treatment effect exceeds a certain proportion \code{e}.
#' @rawRd \usage{
#' BESS_unified(theta0, c, e, type = "one.sample", 
#'              outcome = NULL, a = NULL, b = NULL, sig = 1,
#'              a1 = NULL, b1 = NULL, a2 = NULL, b2 = NULL,
#'              q = 0.5, sim = 10000, n_min = 5, n_max = 100)
#' }
#' \arguments{
#'   \item{theta0}{Threshold value for comparison against the posterior distribution.
#'   One-sample design: is the null value (e.g., a historical mean or proportion) against which the
#'   posterior distribution of the observed parameter (mean, proportion, or rate) is compared.
#'   Two-sample design: represents the minimum clinically meaningful difference between treatment and control groups
#'   (e.g., risk difference in binary outcomes). The design aims to ensure that the posterior probability that the treatment effect exceeds \code{theta0} reaches or exceeds threshold \code{c}.
#'   In other functions in this package, this parameter can also be referred to as \code{threshold}.}
#'   \item{c}{Critical posterior probability level to exceed (e.g., 0.95).}
#'   \item{e}{Evidence level used to simulate observed effect (e.g., observed proportion or mean).
#'   One-sample design: represents the expected true value of the outcome (e.g., response rate, average outcome, or event rate) under the assumed alternative scenario.
#'   Two-sample design: represents the expected effect size between treatment and control (e.g., \code{e = p_t - p_c} for binary outcomes). It is used to generate simulated trial outcomes.}
#'   \item{type}{\code{"one.sample"} or \code{"two.sample"}.}
#'   \item{outcome}{Outcome code, with 1 for binary and 2 for continuous. Required for both design types.}
#'   \item{a, b}{Beta/Gamma/Normal prior parameters for the one-sample case.}
#'   \item{sig}{Standard deviation for continuous outcomes.}
#'   \item{a1, b1, a2, b2}{For binary outcomes, beta shapes for treatment followed by control. For continuous outcomes, normal prior mean and standard deviation for control followed by treatment.}
#'   \item{q}{Weighting parameter for adjusting posterior probabilities.}
#'   \item{sim}{Number of simulations used in two-sample estimation.}
#'   \item{n_min}{Minimum sample size to evaluate.}
#'   \item{n_max}{Maximum sample size to evaluate.}
#' }
#' \details{
#' This function supports unified Bayesian sample size planning under a range of outcome types and model assumptions.
#' The function checks whether the posterior probability (or its adjusted version) exceeds a threshold \code{c} for simulated or observed data, scanning a range of sample sizes to determine the minimum needed.
#' The function iteratively increases the sample size starting from \code{n_min} and computes the minimum posterior probability \code{xi} for an observed difference \code{yd = floor(e * n)} using \code{Two_Arm_Find_Min_Xi}. The smallest sample size for which the posterior probability exceeds \code{c} is returned.
#' }
#' \value{
#'   A list with the following components:
#'   \describe{
#'     \item{\code{n}}{Estimated minimum sample size required.}
#'     \item{\code{vec}}{Posterior probabilities (or minimum \code{xi}) at each evaluated sample size.}
#'     \item{\code{n_seq}}{Sequence of evaluated sample sizes.}
#'     \item{\code{m_vec}}{Observed successes (one-sample binary/count only).}
#'     \item{\code{yd}}{Count of expected treatment-control effect difference.}
#'     \item{\code{yd_vec}}{(Two-arm binary only) Vector of event allocations evaluated at each sample size.}
#'     \item{\code{y1_vec, y2_vec}}{(Two-arm binary only) Event allocations in treatment and control arms that achieve the minimum posterior probability above the threshold.}
#'   }
#' }
#' \examples{
#' # One-sample, binary
#' BESS_unified(theta0 = 0.5, c = 0.95, e = 0.6, type = "one.sample",
#'              outcome = 1, a = 1, b = 1, q = 0.5)
#'
#' # Two-sample, continuous
#' BESS_unified(theta0 = 0.1, c = 0.95, e = 0.6, type = "two.sample",
#'              outcome = 2, a1 = 1, b1 = 1, a2 = 1, b2 = 1, q = 0.5)
#' }
NULL

#' @name Count_combined
#' @rdname Count_Combined
#' @aliases Count_Post_Prob Count_Sample_Size
#' @title Count Outcome: Gamma-Poisson Model for One and Two-Arm Trials
#' @description The posterior probability is the probability of the alternative hypothesis: in this case, that the count of the treatment group has a higher event rate than count control.\cr
#'   1. Post Prob: Computes the posterior probability that the treatment event rate exceeds the control rate by a threshold using Gamma priors and Poisson likelihoods.\cr
#'   2. Sample Size: Computes the minimum sample size needed to achieve a posterior probability of superiority greater than or equal to a critical threshold, under a Gamma-Poisson model for count outcomes.
#' @rawRd \encoding{UTF-8}
#'
#'
#'
#'
#'
#' \usage{
#' Count_Post_Prob(type = "one.sample",
#'                 threshold,
#'                 sample_size,
#'                 count_treat = NULL,
#'                 count_ctrl = NULL,
#'                 total_count = NULL,
#'                 a_t = 0.5, b_t = 0.5,
#'                 a_c = 0.5, b_c = 0.5,
#'                 quant = 0.5,
#'                 simulations = 10000)
#' Count_Sample_Size(type = "one.sample",
#'                   threshold,
#'                   crit,
#'                   effect_size,
#'                   a_t = 0.5, b_t = 0.5,
#'                   a_c = 0.5, b_c = 0.5,
#'                   min_n = 5, max_n = 100,
#'                   quant = 0.5,
#'                   sim = 10000, s_reps = 1000)
#' }
#' \arguments{
#'   \item{type}{Character string. Type of test: \code{"one.sample"} or \code{"two.sample"}.}
#'   \item{effect_size}{Assumed mean event rate for one sample or treatment minus control rate difference for two samples. Must be positive.}
#'   \item{sample_size}{Sample size per arm.}
#'   \item{threshold}{One-sample rate threshold or two-sample threshold for treatment minus control.}
#'   \item{a_t}{Shape parameter for the Gamma prior on treatment group rate.}
#'   \item{b_t}{Rate parameter for the Gamma prior on treatment group rate.}
#'   \item{a_c}{Shape parameter for the Gamma prior on control group rate.}
#'   \item{b_c}{Rate parameter for the Gamma prior on control group rate.}
#'   \item{quant}{Weighting factor for quantile posterior adjustment (default is 0.5, i.e., no adjustment).}
#'   \item{s_reps}{Number of simulated count configurations used in a two-arm search (default 1000).}
#'   \item{sim}{Number of posterior simulations per trial (default 10000).}
#'   \item{count_treat}{Number of events in the treatment group.}
#'   \item{count_ctrl}{Number of events in the control group.}
#'   \item{total_count}{Total combined count for one-sample testing.}
#'   \item{simulations}{Number of posterior draws.}
#'   \item{crit}{Minimum acceptable posterior probability for design success.}
#'   \item{min_n}{Minimum sample size to consider (default 5).}
#'   \item{max_n}{Maximum sample size to consider (default 100).}
#' }
#' \value{
#'   A scalar (posterior probability) for \code{Count_Post_Prob}, or a list for \code{Count_Sample_Size} containing:
#'   \describe{
#'     \item{\code{n}}{The smallest sample size for which the posterior probability exceeds \code{crit}.}
#'     \item{\code{yd}}{The expected number of events under the chosen sample size.}
#'     \item{\code{n_seq}}{Vector of all \code{n} values evaluated from \code{min_n} to \code{max_n}.}
#'     \item{\code{prob_h1_vec}}{Posterior probabilities for each evaluated \code{n}.}
#'     \item{\code{yd_vec}}{Vector of expected total event counts for each \code{n}.}
#'     \item{\code{y1_vec, y2_vec}}{(Two-arm only) Event counts in treatment and control arms achieving the minimal posterior for each \code{n}.}
#'   }
#' }
#' \author{
#' Rachel Zhuang
#' }
#'
#' \examples{
#' # One-arm
#' Count_Post_Prob(type = "one.sample", total_count = 45, sample_size = 20,
#'                 threshold = 2.5, a_t = 0.5, b_t = 0.5)
#'
#' # Two-arm
#' Count_Post_Prob(type = "two.sample", count_treat = 30, count_ctrl = 20,
#'                 sample_size = 20, threshold = 1.5,
#'                 a_t = 0.5, b_t = 0.5, a_c = 0.5, b_c = 0.5)
#'                 
#' # One-arm count sample size
#' Count_Sample_Size(type = "one.sample",
#'                   threshold = 2,
#'                   crit = 0.8,
#'                   effect_size = 0.15,
#'                   a_t = 0.5, b_t = 0.5)
#'
#' # Two-arm count sample size
#' set.seed(42)
#' Count_Sample_Size(type = "two.sample",
#'                   threshold = 1,
#'                   crit = 0.9,
#'                   effect_size = 2,
#'                   a_t = 0.5, b_t = 0.5, a_c = 0.5, b_c = 0.5,
#'                   max_n = 30, sim = 500, s_reps = 30)
#' }
NULL

#' @name Freq_Binary_theoretical
#' @rdname Freq_Binary_theoretical
#' @aliases Freq_Binary_theoretical
#' @title Frequentist Sample Size Calculation for Binary Outcomes
#' @description Calculates the required sample size per arm for a binary outcome test (either one-sample or two-sample), using frequentist normal approximation formulas.
#' @rawRd \usage{
#' Freq_Binary_theoretical(alpha, beta, theta1, theta0, type = "two.sample")
#' }
#' \arguments{
#'   \item{alpha}{Significance level (type I error rate), e.g., 0.05.}
#'   \item{beta}{Type II error rate (1 - power), e.g., 0.2.}
#'   \item{theta1}{Expected proportion in the treatment group.}
#'   \item{theta0}{Proportion under the null hypothesis (or in the control group).}
#'   \item{type}{Type of test: \code{"one.sample"} or \code{"two.sample"}.}
#' }
#' \details{
#' Uses normal approximation for proportions:
#' \itemize{
#'   \item Two-sample formula uses pooled variance across treatment and control groups.
#'   \item One-sample formula uses variance of the treatment group only.
#' }
#' If an invalid type is provided, an error is raised.
#' }
#' \value{
#' An integer: the calculated sample size per group (or for the total in a one-sample test).
#' }
#'
#' \examples{
#' Freq_Binary_theoretical(alpha = 0.05, beta = 0.2, theta1 = 0.6, theta0 = 0.5)
#' }
NULL

#' @name Freq_Count_Combined
#' @rdname Freq_Count_Combined
#' @aliases Freq_Count_Combined
#' @title Frequentist Sample Size Estimation for Count Data (Gamma-Poisson)
#' @description Performs both theoretical and simulation-based sample size estimation for detecting a difference in means between two Poisson-like count distributions (with optional overdispersion via Gamma-Poisson / Negative Binomial model).
#' @rawRd \usage{
#' Freq_Count_Combined(alpha, beta, mu1, mu0, 
#'                     sig1 = 1, sig0 = 1, 
#'                     type = "two.sample", 
#'                     nmin = 10, nmax = 5000, sims = 10000)
#' }
#' \arguments{
#'   \item{alpha}{Significance level (Type I error rate), typically 0.05.}
#'   \item{beta}{Type II error rate (1 - power), typically 0.2.}
#'   \item{mu1}{Expected mean count under the alternative hypothesis.}
#'   \item{mu0}{Mean count under the null hypothesis.}
#'   \item{sig1}{Dispersion parameter for alternative (mean = mu1, variance = mu1 + mu1^2 / sig1). Default is 1. Larger values approach the Poisson limit.}
#'   \item{sig0}{Dispersion parameter for null (mean = mu0, variance = mu0 + mu0^2 / sig0). Default is 1. Larger values approach the Poisson limit.}
#'   \item{type}{Type of test: "one.sample" or "two.sample". Default is "two.sample".}
#'   \item{nmin}{Minimum sample size to consider during simulation.}
#'   \item{nmax}{Maximum sample size to consider during simulation.}
#'   \item{sims}{Number of simulation iterations to perform at each sample size.}
#' }
#' \details{
#' This function first computes a theoretical sample size estimate based on normal approximation of the mean difference.
#'
#' It then performs simulation-based estimation using a Gamma-Poisson (negative binomial) model to generate synthetic data under both the null and alternative hypotheses. The function continues iterating over sample sizes until both Type I and Type II error thresholds are satisfied.
#'
#' The result includes both the theoretical and empirical (simulation-based) required sample sizes.
#' }
#' \value{
#' A list with the following elements:
#'   \item{n_theory}{Poisson normal-approximation sample size estimate. The negative binomial dispersion parameters are used in the simulation.}
#'   \item{n_sim}{Estimated sample size from simulations that meets the specified alpha and beta thresholds.}
#' }
#'
#' \examples{
#' set.seed(42)
#' Freq_Count_Combined(alpha = 0.05, beta = 0.2, 
#'                     mu1 = 7, mu0 = 5,
#'                     sig1 = 1, sig0 = 1,
#'                     type = "two.sample",
#'                     nmin = 10, nmax = 50, sims = 200)
#'
#' # One-sample test, overdispersed counts
#' Freq_Count_Combined(alpha = 0.05, beta = 0.1,
#'                     mu1 = 12, mu0 = 10,
#'                     sig1 = 0.5, sig0 = 0.5,
#'                     type = "one.sample",
#'                     nmin = 5, nmax = 50, sims = 200)
#' }
NULL

#' @name Frequentist_Sample_Size
#' @rdname Frequentist_Sample_Size
#' @aliases One_Arm_Freq_theory Two_Arm_Freq_theory One_Arm_t_test_sim Two_Arm_t_test_sim
#' @title Frequentist Sample Size for Binary and Continuous Outcomes
#' @description Estimate sample sizes for one-sided tests using a normal approximation for
#' binary outcomes or simulated t-tests for continuous outcomes.
#' @rawRd \usage{
#' One_Arm_Freq_theory(alpha, beta, theta, theta_star)
#'
#' Two_Arm_Freq_theory(alpha, beta, theta1, theta0)
#'
#' One_Arm_t_test_sim(alpha, beta, theta, theta_star, sigma = 1,
#'                    nmin = 10, nmax = 5000, sims = 10000)
#'
#' Two_Arm_t_test_sim(alpha, beta, mu1, mu0, sigma1 = 1, sigma0 = 1,
#'                    nmin = 10, nmax = 5000, sims = 10000)
#' }
#' \arguments{
#'   \item{alpha, beta}{Target type I and type II error probabilities, respectively.}
#'   \item{theta}{Assumed outcome proportion in the binary design or mean in the
#'     continuous design under the one-arm alternative.}
#'   \item{theta_star}{Proportion or mean under the one-arm null hypothesis.}
#'   \item{theta1, theta0}{Assumed treatment and control success proportions.}
#'   \item{mu1, mu0}{Assumed treatment and control means.}
#'   \item{sigma}{Observation standard deviation for the one-arm simulation.}
#'   \item{sigma1, sigma0}{Treatment and control standard deviations for the two-arm simulation.}
#'   \item{nmin, nmax}{Inclusive sample size search bounds for the simulations.}
#'   \item{sims}{Number of simulated samples under each hypothesis at each candidate size.}
#' }
#' \value{
#' The total size for a one-arm design or the size per arm for a two-arm design.
#' The simulation functions return \code{NA} if no candidate meets both targets.
#' }
#' \seealso{\code{\link{Freq_Binary_theoretical}}, \code{\link{t_test_sim_sample_size}}}
NULL

#' @name One_Arm_BESS
#' @rdname One_Arm_BESS
#' @aliases One_Arm_BESS One_Arm_Post_Prob_Theta
#' @title One-Arm Bayesian Posterior Probability and Sample Size
#' @description Compute the posterior probability that an outcome parameter exceeds a threshold,
#' or search for a sample size at which the adjusted probability meets a cutoff.
#' @rawRd \usage{
#' One_Arm_Post_Prob_Theta(n, theta0, e, outcome, a, b, sig = 1)
#'
#' One_Arm_BESS(theta0, c, e, outcome, a, b, q = 0.5, sig = 1,
#'              n_min = 5, n_max = 100)
#' }
#' \arguments{
#'   \item{n}{Sample size.}
#'   \item{theta0}{Threshold for the outcome parameter.}
#'   \item{e}{Assumed success proportion, mean, or mean count per observation.
#'     For binary and count outcomes, the observed total is \code{floor(n * e)}.
#'     Binary proportions must be between 0 and 1, count means must be nonnegative,
#'     and continuous means may be any finite real value.}
#'   \item{outcome}{Outcome code, with 1 for binary, 2 for continuous, and 3 for counts.}
#'   \item{a, b}{Beta prior shape parameters for binary outcomes, normal prior
#'     mean and standard deviation for continuous outcomes, or gamma prior shape
#'     and rate for counts.}
#'   \item{sig}{Known observation standard deviation for continuous outcomes.}
#'   \item{c}{Cutoff for the adjusted posterior probability.}
#'   \item{q}{Prior probability of the alternative hypothesis. A value of 0.5
#'     leaves the posterior probability unadjusted.}
#'   \item{n_min, n_max}{Inclusive sample size search bounds.}
#' }
#' \value{
#' \code{One_Arm_Post_Prob_Theta} returns a numeric posterior probability.
#' \code{One_Arm_BESS} returns a list with the selected size \code{n}, search grid
#' \code{n_seq}, probabilities \code{vec}, and, for discrete outcomes, counts
#' \code{m_vec}. It returns a character message for invalid search settings or
#' when the search bounds need adjustment.
#' }
#' \seealso{\code{\link{One_Arm_Post_Prob_H1}}, \code{\link{BESS_unified}}}
NULL

#' @name One_Arm_Normal_Post_Prob
#' @rdname One_Arm_Normal_Post_Prob
#' @aliases One_Arm_Normal_Post_Prob
#' @title Posterior Probability Under Normal-Normal Model
#' @description Computes the posterior probability that a parameter exceeds a threshold using a conjugate normal prior and likelihood model.
#' @rawRd \usage{
#' One_Arm_Normal_Post_Prob(sample_size, threshold, effect_size,
#'   prior_mean, prior_sd, sigma, quant = 0.5)
#' }
#' \arguments{
#'   \item{sample_size}{Number of observations.}
#'   \item{threshold}{Threshold value for hypothesis testing.}
#'   \item{effect_size}{Observed effect.}
#'   \item{prior_mean}{Prior mean.}
#'   \item{prior_sd}{Prior standard deviation.}
#'   \item{sigma}{Standard deviation of data.}
#'   \item{quant}{Prior probability for \code{H1}, between 0 and 1.}
#' }
#' \value{
#' Posterior or transformed probability that parameter exceeds the threshold.
#' }
#'
#' \examples{
#' One_Arm_Normal_Post_Prob(30, 0.5, 0.7, 0, 1, 1)
#' }
NULL

#' @name One_Arm_Normal_Sample_Size
#' @rdname One_Arm_Normal_Sample_Size
#' @aliases One_Arm_Normal_Sample_Size
#' @title Sample Size Estimation for Normal-Normal Posterior
#' @description Finds the minimum sample size such that the posterior probability under the normal-normal model exceeds a specified threshold.
#' @rawRd \usage{
#' One_Arm_Normal_Sample_Size(threshold, crit, effect_size,
#'   prior_mean, prior_sd, min_n = 5, max_n = 100, quant = 0.5, sigma = 1)
#' }
#' \arguments{
#'   \item{threshold}{Critical threshold for testing.}
#'   \item{crit}{Posterior probability cutoff to exceed.}
#'   \item{effect_size}{Observed or assumed effect size.}
#'   \item{prior_mean}{Prior mean.}
#'   \item{prior_sd}{Prior standard deviation.}
#'   \item{min_n}{Minimum sample size to try.}
#'   \item{max_n}{Maximum sample size to try.}
#'   \item{quant}{Prior probability of \code{H1}.}
#'   \item{sigma}{Standard deviation of outcome.}
#' }
#' \value{
#' Returns a list with:
#'   \itemize{
#'     \item \code{n}: Required sample size.
#'     \item \code{prob}: Posterior probability at that sample size.
#'     \item \code{prob_h1_vec}: Vector of posterior probabilities across all n values.
#'   }
#' }
#'
#' \examples{
#' One_Arm_Normal_Sample_Size(0.5, 0.9, 0.6, 0, 1)
#' }
NULL

#' @name One_Arm_Post_Prob_H1
#' @rdname One_Arm_Post_Prob_H1
#' @aliases One_Arm_Post_Prob_H1
#' @title Posterior Probability for H1 Under Different Outcome Types
#' @description Computes a transformed posterior probability of a hypothesis \code{H1} holding, given the probability that \code{theta > theta0}. Applies to binary, continuous, or count outcomes.
#' @rawRd \usage{
#' One_Arm_Post_Prob_H1(n, theta0, e, outcome, a, b, sig = 1, q = 0.5)
#' }
#' \arguments{
#'   \item{n}{Sample size.}
#'   \item{theta0}{Threshold value.}
#'   \item{e}{Evidence/effect size.}
#'   \item{outcome}{1 = binary, 2 = continuous, 3 = count-data.}
#'   \item{a}{Prior parameter.}
#'   \item{b}{Prior parameter.}
#'   \item{sig}{Standard deviation (used if continuous outcome).}
#'   \item{q}{Prior probability of \code{H1}. Must be in (0,1).}
#' }
#' \value{
#' Transformed posterior probability for \code{H1}.
#' }
#'
#' \examples{
#' One_Arm_Post_Prob_H1(50, 0.5, 0.6, 1, 1, 1, q = 0.7)
#' }
NULL

#' @name Post_Prob_Bayes
#' @rdname Post_Prob_Bayes
#' @aliases Post_Prob_Bayes
#' @title Posterior Probability Calculation for One- and Two-Sample Bayesian Settings
#' @description Computes the posterior probability that a parameter exceeds a threshold using Bayesian updating for one-sample or two-sample scenarios. Supports binary and continuous outcomes for one and two-arm tests.
#' @rawRd \usage{
#' Post_Prob_Bayes(type = "one.sample", 
#'                 n, theta0 = NULL, delta = NULL, 
#'                 outcome = NULL, e = NULL, 
#'                 a = 0.5, b = 0.5, sig = 1,
#'                 Y_t = NULL, Y_c = NULL,
#'                 a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
#'                 q = 0.5, sim = 10000)
#' }
#' \arguments{
#'   \item{type}{Type of test: \code{"one.sample"} or \code{"two.sample"}.}
#'   \item{n}{Sample size per group or total sample size (one-sample).}
#'   \item{theta0}{Threshold for posterior probability comparison. Required for \code{one.sample}.}
#'   \item{delta}{Margin threshold for two-sample difference. Required for \code{two.sample}.}
#'   \item{outcome}{Outcome type: 1 = binary, 2 = continuous.}
#'   \item{e}{Observed proportion or mean response for a one-sample calculation.}
#'   \item{a, b}{Prior hyperparameters for one-sample case.}
#'   \item{sig}{Known observation standard deviation for continuous outcomes, common to both arms in a two-sample calculation.}
#'   \item{Y_t, Y_c}{Success counts for binary outcomes or sample means for continuous outcomes in treatment and control.}
#'   \item{a1, b1, a2, b2}{For binary outcomes, beta shapes for treatment followed by control. For continuous outcomes, normal prior mean and standard deviation for control followed by treatment.}
#'   \item{q}{Weighting parameter for adjusting posterior probability.}
#'   \item{sim}{Number of simulations to use in the two-sample posterior estimation.}
#' }
#' \details{
#' \itemize{
#'   \item Binary: uses Beta posterior.
#'   \item Continuous: uses Normal posterior.
#'   \item Posterior probabilities for difference in success rates are estimated using simulation from Beta posteriors.
#' }
#' An optional adjustment based on \code{q} is applied to the raw posterior using a quasi-decision-theoretic rule.
#' }
#' \value{
#' A numeric value representing the posterior probability (possibly adjusted by \code{q}).
#' }
#'
#' \examples{
#' # One-sample binary
#' Post_Prob_Bayes(type = "one.sample", n = 20, theta0 = 0.5, outcome = 1, e = 0.6)
#'
#' # Two-sample binary
#' Post_Prob_Bayes(type = "two.sample", n = 20, delta = 0.1, outcome = 1,
#'                 Y_t = 13, Y_c = 8, a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5, 
#'                 q = 0.5, sim = 10000, e = 0.65)
#' }
NULL

#' @name t_test_sim_sample_size
#' @rdname t_test_sim_sample_size
#' @aliases t_test_sim_sample_size
#' @title Simulation-Based Sample Size Calculation for One- or Two-Sample t-Tests
#' @description Estimate the required sample size per group using Monte Carlo simulation to ensure type I and II errors are below specified thresholds for t-tests.
#' @rawRd \usage{
#' t_test_sim_sample_size(alpha, beta, mu1, mu0,
#'                        sigma1 = 1, sigma0 = 1,
#'                        type = "two.sample",
#'                        nmin = 10, nmax = 5000, sims = 10000)
#' }
#' \arguments{
#'   \item{alpha}{Significance level (type I error), e.g., 0.05.}
#'   \item{beta}{Type II error (1 - power), e.g., 0.2.}
#'   \item{mu1}{Mean under the alternative hypothesis (treatment).}
#'   \item{mu0}{Mean under the null hypothesis (control).}
#'   \item{sigma1}{Standard deviation in treatment group; defaults to 1.}
#'   \item{sigma0}{Standard deviation in control group; defaults to 1.}
#'   \item{type}{\code{"one.sample"} or \code{"two.sample"} Welch t-test.}
#'   \item{nmin}{Minimum sample size to consider.}
#'   \item{nmax}{Maximum sample size to consider.}
#'   \item{sims}{Number of simulations per sample size value.}
#' }
#' \details{
#' Simulates \code{sims} data sets per sample size. For each sample size, it:
#' \itemize{
#'   \item Simulates null and alternative samples.
#'   \item Computes empirical type I and type II error rates via t-tests.
#'   \item Returns the first sample size where both rates are below specified thresholds.
#' }
#' Useful when assumptions of normal-theory calculations are questionable or exact power is needed under heteroskedasticity.
#' }
#' \value{
#' An integer: the smallest sample size per arm (or for the single group in a one-sample test) that meets the desired error thresholds. Returns \code{NA} if no such sample size is found within the search bounds.
#' }
#'
#' \examples{
#' set.seed(42)
#' # Two-sample Welch t-test, normal data
#' t_test_sim_sample_size(alpha = 0.05, beta = 0.2,
#'                        mu1 = 2, mu0 = 1,
#'                        sigma1 = 1, sigma0 = 1, nmax = 50, sims = 200)
#'
#' # One-sample t-test
#' t_test_sim_sample_size(alpha = 0.05, beta = 0.2,
#'                        mu1 = 2, mu0 = 1,
#'                        type = "one.sample", nmax = 50, sims = 200)
#' }
NULL

#' @name Two_Arm_Binary_Bayes
#' @rdname Two_Arm_Binary_Bayes
#' @aliases Two_Arm_Post_Prob_H1_Sim Two_Arm_Find_Min_Xi Two_Arm_BESS_Binary Two_Arm_Post_Prob_H1 Two_Arm_Min_Adj_Prob Two_Arm_Bayes_Sample_Size Two_Arm_Binary_Post_Prob Two_Arm_Binary_Min_Prob BESS_binary
#' @title Two-Arm Bayesian Designs for Binary Outcomes
#' @description Simulate posterior probabilities that the treatment success rate minus the
#' control success rate exceeds a margin, minimize those probabilities over pairs
#' of outcomes with a fixed success-count difference, or search for a sample size
#' using the minimum probability.
#' @rawRd \usage{
#' Two_Arm_Post_Prob_H1_Sim(Y_t, Y_c, n, delta,
#'                          a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
#'                          q = 0.5, sim = 10000)
#'
#' Two_Arm_Find_Min_Xi(yd, n, delta,
#'                    a1 = 0.5, b1 = 0.5, a2 = 0.5, b2 = 0.5,
#'                    q = 0.5, sim = 10000)
#'
#' Two_Arm_BESS_Binary(theta0, c, e, n_min, n_max,
#'                     a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
#'                     q = 0.5, sim = 10000)
#'
#' Two_Arm_Post_Prob_H1(obs_t, obs_c, sample_size, margin,
#'                      alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'                      prior_weight = 0.5, iterations = 10000)
#'
#' Two_Arm_Min_Adj_Prob(diff, sample_size, margin,
#'                      alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'                      prior_weight = 0.5, iterations = 10000)
#'
#' Two_Arm_Bayes_Sample_Size(null_margin, threshold, expected_effect, min_n, max_n,
#'                           alpha1 = 0.05, beta1 = 0.05, alpha2 = 0.05, beta2 = 0.05,
#'                           prior_weight = 0.5, iterations = 10000)
#'
#' Two_Arm_Binary_Post_Prob(obs_t, obs_c, n, margin,
#'                          alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'                          prior_weight = 0.5, iterations = 10000)
#'
#' Two_Arm_Binary_Min_Prob(diff, n, margin,
#'                         alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'                         prior_weight = 0.5, iterations = 10000)
#'
#' BESS_binary(margin, threshold, delta, min_n, max_n,
#'             alpha1 = 0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'             prior_weight = 0.5, iterations = 10000)
#' }
#' \arguments{
#'   \item{Y_t, obs_t}{Number of treatment successes.}
#'   \item{Y_c, obs_c}{Number of control successes.}
#'   \item{n, sample_size}{Number of observations per arm.}
#'   \item{margin, theta0, null_margin}{Threshold for the treatment minus control success rate.}
#'   \item{delta}{Rate difference used as the margin in \code{Two_Arm_Post_Prob_H1_Sim}
#'     and \code{Two_Arm_Find_Min_Xi}, or as the expected effect in \code{BESS_binary}.}
#'   \item{yd, diff}{Treatment minus control success count. Use an integer between
#'     minus the per-arm sample size and the per-arm sample size.}
#'   \item{a1, b1, alpha1, beta1}{Beta prior shape parameters for treatment.}
#'   \item{a2, b2, alpha2, beta2}{Beta prior shape parameters for control.}
#'   \item{q, prior_weight}{Prior probability of the alternative hypothesis.
#'     A value of 0.5 leaves the posterior probability unadjusted.}
#'   \item{sim, iterations}{Number of posterior draws per arm.}
#'   \item{c, threshold}{Posterior probability cutoff for the sample size search.}
#'   \item{e, expected_effect}{Assumed treatment minus control success rate.}
#'   \item{n_min, n_max, min_n, max_n}{Inclusive per-arm sample size search bounds.}
#' }
#' \value{
#' \code{Two_Arm_Post_Prob_H1_Sim}, \code{Two_Arm_Post_Prob_H1}, and
#' \code{Two_Arm_Binary_Post_Prob} return a numeric probability.
#' \code{Two_Arm_Find_Min_Xi} returns \code{y1}, \code{y2}, and \code{min_xi}.
#' \code{Two_Arm_Min_Adj_Prob} returns \code{treat}, \code{ctrl}, and \code{min_prob}.
#' \code{Two_Arm_Binary_Min_Prob} returns \code{tr}, \code{ct}, and \code{min_prob}.
#' The minimum-probability lists give the treatment and control success counts
#' and their estimated probability.
#' \code{Two_Arm_BESS_Binary} and \code{Two_Arm_Bayes_Sample_Size} return
#' the selected per-arm size \code{n}, target count difference \code{yd}, candidate
#' sizes \code{n_seq}, and vectors of evaluated probabilities and counts.
#' \code{BESS_binary} returns \code{n_per_arm}, \code{required_difference}, and
#' \code{worst_case}, which is a list from \code{Two_Arm_Binary_Min_Prob}.
#' The sample size functions return the upper search bound if the cutoff is not met.
#' }
NULL

#' @name Two_Arm_Combined_Post_Prob
#' @rdname Two_Arm_combined_Post_Prob
#' @aliases Two_Arm_Combined_Post_Prob
#' @title Two-Arm Posterior Probability for Binary, Continuous, and Count Outcomes
#' @description Combined_Post_Prob: Computes the posterior probability that the treatment effect exceeds a defined threshold in two-arm Bayesian trials. Supports binary, continuous, and count data types using conjugate priors and optional quantile adjustment.
#' @rawRd \usage{
#' Two_Arm_Combined_Post_Prob(type = c("continuous", "count", "binary"),
#'                  sample_size, threshold, effect_size = NULL, prior_mean
#'                  = NULL, prior_sd = NULL, sigma = 1, count_treat =
#'                  NULL, count_ctrl = NULL, a_t = NULL, b_t = NULL, a_c =
#'                  NULL, b_c = NULL, obs_t = NULL, obs_c = NULL, alpha1 =
#'                  0.5, beta1 = 0.5, alpha2 = 0.5, beta2 = 0.5,
#'                  prior_weight = 0.5, quant = 0.5, simulations = 10000)
#' }
#' \arguments{
#'   \item{type}{Character. Outcome type. Must be one of \code{"binary"}, \code{"continuous"}, or \code{"count"}.}
#'   \item{count_treat}{Total event count in treatment. Required for count outcomes.}
#'   \item{count_ctrl}{Total event count in control. Required for count outcomes.}
#'   \item{sample_size}{Numeric. Sample size per arm. Required for all types.}
#'   \item{threshold}{Numeric. Threshold value (null margin) to compare against posterior difference (e.g. \eqn{\theta_0}).}
#'   \item{effect_size}{Numeric. Observed or assumed effect size. Required for continuous type.}
#'   \item{alpha1, beta1}{Beta prior shapes for treatment in binary outcomes.}
#'   \item{alpha2, beta2}{Beta prior shapes for control in binary outcomes.}
#'   \item{prior_mean}{Numeric. Prior mean for continuous outcomes.}
#'   \item{prior_sd}{Numeric. Prior standard deviation for continuous outcomes.}
#'   \item{sigma}{Scale of the continuous contrast. Its likelihood variance is sigma squared divided by sample_size. For independent groups with common observation standard deviation s, use sqrt(2) times s.}
#'   \item{a_t, b_t}{Numerics. Shape and rate of Gamma prior for treatment group (count outcomes).}
#'   \item{a_c, b_c}{Numerics. Shape and rate of Gamma prior for control group (count outcomes).}
#'   \item{obs_t}{Observed data for the treatment group. Used for posterior updating in Bayesian analysis.}
#'   \item{obs_c}{Observed data for the control group. Used for posterior updating in Bayesian analysis.}
#'   \item{prior_weight}{Prior belief weight for the treatment being superior; used to mix posterior with prior belief. Default is 0.5.}
#'   \item{quant}{Numeric. Posterior quantile correction factor. Default is 0.5 (no correction).}
#'   \item{simulations}{Integer. Number of samples drawn for posterior estimation in binary and count outcomes. Default is 10,000.}
#' }
#' \details{
#' The function uses beta-binomial posteriors for binary outcomes, a normal
#' posterior for a continuous contrast, and gamma-Poisson posteriors for counts.
#' For a raw probability p and weight w, the adjustment is
#' \eqn{wp / (1-w+(2w-1)p)}. Binary calculations apply prior_weight first.
#' The quant adjustment then applies to every outcome type.
#' A weight of 0.5 leaves the corresponding probability unchanged.
#' }
#' \value{
#'   Numeric posterior probability, possibly adjusted, that the treatment minus control contrast exceeds threshold.
#' }
#'
#' \examples{
#' # Binary example
#' Two_Arm_Combined_Post_Prob(
#'   type = "binary",
#'   obs_t = 25,
#'   obs_c = 15,
#'   sample_size = 50,
#'   threshold = 0,
#'   alpha1 = 0.5,
#'   beta1 = 0.5,
#'   alpha2 = 0.5,
#'   beta2 = 0.5,
#'   quant = 0.5
#' )
#'
#' # Continuous example
#' Two_Arm_Combined_Post_Prob(
#'   type = "continuous",
#'   sample_size = 50,
#'   threshold = 0,
#'   effect_size = 0.3,
#'   prior_mean = 0,
#'   prior_sd = 1,
#'   sigma = 1,
#'   quant = 0.5
#' )
#'
#' # Count example
#' Two_Arm_Combined_Post_Prob(
#'   type = "count",
#'   count_treat = 60,
#'   count_ctrl = 40,
#'   sample_size = 50,
#'   threshold = 0,
#'   a_t = 1, b_t = 1,
#'   a_c = 1, b_c = 1,
#'   quant = 0.5)
#' }
NULL

#' @name Two_Arm_Combined_Sample_Size
#' @rdname Two_Arm_Combined_Sample_Size
#' @aliases Two_Arm_Combined_Sample_Size
#' @title Two-Arm Bayesian Sample Size for Binary, Continuous, and Count Outcomes
#' @description Computes the minimum required sample size per arm in a two-arm Bayesian trial design to ensure the posterior probability that the treatment effect exceeds a threshold is at least a specified critical value. This function supports \code{"binary"}, \code{"continuous"}, and \code{"count"} outcomes.
#' @rawRd \usage{
#' Two_Arm_Combined_Sample_Size(type = c("binary", "continuous", "count"),
#'                                  threshold, crit, effect_size,
#'                                  prior_mean = NULL, prior_sd = NULL, sigma = 1,
#'                                  a_t = NULL, b_t = NULL, a_c = NULL, b_c = NULL,
#'                                  alpha1 = 0.5, beta1 = 0.5,
#'                                  alpha2 = 0.5, beta2 = 0.5,
#'                                  prior_weight = 0.5,
#'                                  min_n = 5, max_n = 100,
#'                                  quant = 0.5,
#'                                  s_reps = 1000, sims = 1e4)
#' }
#' \arguments{
#'   \item{type}{Character. Outcome type. Must be one of \code{"binary"}, \code{"continuous"}, or \code{"count"}.}
#'   \item{threshold}{Numeric. The null margin \eqn{\theta_0}. Posterior probabilities are computed for the treatment effect exceeding this value.}
#'   \item{crit}{Numeric. Critical posterior probability (e.g., 0.8). The sample size is chosen to meet or exceed this value.}
#'   \item{effect_size}{Numeric. The expected effect size (treatment minus control).}
#'   
#'   \item{prior_mean}{Numeric. Prior mean for continuous outcomes.}
#'   \item{prior_sd}{Numeric. Prior standard deviation for continuous outcomes.}
#'   \item{sigma}{Scale of the continuous contrast. Its likelihood variance is sigma squared divided by sample size. For independent groups with common observation standard deviation s, use sqrt(2) times s.}
#'   
#'   \item{a_t, b_t}{Numerics. Shape and rate parameters of the Gamma prior for the treatment group in count outcomes.}
#'   \item{a_c, b_c}{Numerics. Shape and rate parameters of the Gamma prior for the control group in count outcomes.}
#'   
#'   \item{alpha1, beta1}{Beta prior shapes for treatment in binary outcomes.}
#'   \item{alpha2, beta2}{Beta prior shapes for control in binary outcomes.}
#'   
#'   \item{prior_weight}{Numeric between 0 and 1. Prior weight for adjusting posterior probability in binary outcomes. Default is 0.5 (no adjustment).}
#'   \item{min_n, max_n}{Integers. The minimum and maximum sample size per arm to search.}
#'   \item{quant}{Numeric. Quantile adjustment for posterior probability (0.5 = no correction).}
#'   \item{s_reps}{Integer. Number of samples for count simulations. Default is 1000.}
#'   \item{sims}{Integer. Number of simulation iterations for binary/count posterior sampling. Default is 10,000.}
#' }
#' \value{
#'   For continuous outcomes, a list containing the selected per-arm size
#'   \code{n}, probability \code{prob}, and vector of candidate probabilities
#'   \code{posterior_prob_margin_exceeded}, or a character message when the
#'   search bounds need adjustment.
#'   For count outcomes, a list containing \code{n}, count difference \code{yd},
#'   and scalar \code{posterior_prob_margin_exceeded}, or a character message
#'   when the criterion is unmet.
#'   For binary outcomes, a list with \code{n_per_arm},
#'   \code{required_difference}, and \code{worst_case}, the list returned by
#'   \code{\link{Two_Arm_Binary_Min_Prob}}. The binary search returns the upper
#'   bound if no candidate meets the cutoff.
#' }
#' \examples{
#' set.seed(42)
#' # Binary outcome example
#' Two_Arm_Combined_Sample_Size(
#'   type = "binary",
#'   threshold = 0,
#'   crit = 0.8,
#'   effect_size = 0.3,
#'   max_n = 30, sims = 500)
#'
#' # Continuous outcome example
#' Two_Arm_Combined_Sample_Size(
#'   type = "continuous",
#'   threshold = 0.2,
#'   crit = 0.9,
#'   effect_size = 0.4,
#'   prior_mean = 0,
#'   prior_sd = 1,
#'   sigma = 1)
#'
#' # Count outcome example
#' Two_Arm_Combined_Sample_Size(
#'   type = "count",
#'   threshold = 0,
#'   crit = 0.85,
#'   effect_size = 1,
#'   a_t = 1, b_t = 1,
#'   a_c = 1, b_c = 1,
#'   max_n = 30, sims = 500, s_reps = 30)
#' }
NULL

#' @name Two_Arm_Continuous_Bayes
#' @rdname Two_Arm_Continuous_Bayes
#' @aliases Two_Arm_Cont_Post_Prob Two_Arm_Cont_Sample_Size
#' @title Two-Arm Bayesian Designs for Continuous Outcomes
#' @description Compute the normal posterior probability of a treatment contrast exceeding a
#' threshold, or search for a sample size at which the probability meets a cutoff.
#' @rawRd \usage{
#' Two_Arm_Cont_Post_Prob(sample_size, threshold, effect_size, prior_mean, prior_sd,
#'                        sigma, quant = 0.5)
#'
#' Two_Arm_Cont_Sample_Size(threshold, crit, effect_size, prior_mean, prior_sd,
#'                          min_n = 5, max_n = 100, quant = 0.5, sigma = 1)
#' }
#' \arguments{
#'   \item{sample_size}{Sample size used to calculate the variance of the observed contrast.}
#'   \item{threshold}{Threshold for the treatment minus control contrast.}
#'   \item{effect_size}{Observed or assumed treatment contrast.}
#'   \item{prior_mean, prior_sd}{Mean and standard deviation of the normal prior for the contrast.}
#'   \item{sigma}{Standard deviation used in the contrast likelihood, whose variance
#'     is \code{sigma^2 / sample_size}.}
#'   \item{quant}{Prior probability of the alternative hypothesis.
#'     A value of 0.5 leaves the posterior probability unadjusted.}
#'   \item{crit}{Posterior probability cutoff for the search.}
#'   \item{min_n, max_n}{Inclusive candidate sample size bounds.}
#' }
#' \value{
#' \code{Two_Arm_Cont_Post_Prob} returns a numeric probability.
#' \code{Two_Arm_Cont_Sample_Size} returns the selected size \code{n}, its
#' probability \code{prob}, and the probabilities across candidate sizes
#' \code{posterior_prob_margin_exceeded}. It returns a character message if
#' a search bound needs adjustment.
#' }
#' \seealso{\code{\link{Two_Arm_Combined_Sample_Size}}}
NULL

#' @name Two_Arm_Count_Bayes
#' @rdname Two_Arm_Count_Bayes
#' @aliases Two_Arm_Gamma_Post_Prob Two_Arm_Gamma_Min_Effect Two_Arm_Gamma_Sample_Size Two_Arm_Count_Post_Prob Two_Arm_Count_Min_Effect
#' @title Two-Arm Bayesian Designs for Count Outcomes
#' @description Simulate posterior probabilities that the treatment event rate exceeds the
#' control event rate by more than a threshold, find the smallest estimated
#' probability among simulated event totals, or search for a sample size.
#' @rawRd \usage{
#' Two_Arm_Gamma_Post_Prob(count_treat, count_ctrl, sample_size, threshold,
#'                         a_t, b_t, a_c, b_c, quant = 0.5, simulations = 10000)
#'
#' Two_Arm_Count_Post_Prob(count_treat, count_ctrl, sample_size, threshold,
#'                         a_t, b_t, a_c, b_c, quant = 0.5, simulations = 1e4)
#'
#' Two_Arm_Gamma_Min_Effect(effect_size, sample_size, threshold, a_t, b_t, a_c, b_c,
#'                          quant = 0.5, s_reps = 10000, reps = 10000)
#'
#' Two_Arm_Count_Min_Effect(effect_size, sample_size, threshold, a_t, b_t, a_c, b_c,
#'                          quant = 0.5, s_reps = 1e4, reps = 1e4)
#'
#' Two_Arm_Gamma_Sample_Size(threshold, crit, effect_size, a_t, b_t, a_c, b_c,
#'                           min_n = 5, max_n = 100, quant = 0.5,
#'                           s_reps = 1000, reps = 10000)
#' }
#' \arguments{
#'   \item{count_treat, count_ctrl}{Total observed counts in the treatment and control arms.}
#'   \item{sample_size}{Number of observations per arm.}
#'   \item{threshold}{Threshold for the treatment minus control event rate.}
#'   \item{a_t, b_t}{Shape and rate of the gamma prior for treatment.}
#'   \item{a_c, b_c}{Shape and rate of the gamma prior for control.}
#'   \item{quant}{Prior probability of the alternative hypothesis.
#'     A value of 0.5 leaves the posterior probability unadjusted.}
#'   \item{simulations, reps}{Number of posterior draws per arm for each probability estimate.}
#'   \item{s_reps}{Number of simulated event totals used to find the minimum probability.}
#'   \item{effect_size}{Assumed rate difference. The treatment total is set to the
#'     control total plus \code{floor(sample_size * effect_size)}. For negative
#'     differences, treatment totals are drawn using the treatment prior and
#'     control totals are obtained by subtracting this difference, ensuring
#'     both totals are nonnegative.}
#'   \item{crit}{Posterior probability cutoff for the sample size search.}
#'   \item{min_n, max_n}{Inclusive per-arm sample size search bounds.}
#' }
#' \value{
#' The posterior functions return a numeric probability.
#' The minimum-effect functions return treatment and control counts \code{y1}
#' and \code{y2} and the minimum estimated probability, named \code{min_xi}
#' in \code{Two_Arm_Gamma_Min_Effect} and \code{prob} in \code{Two_Arm_Count_Min_Effect}.
#' \code{Two_Arm_Gamma_Sample_Size} returns the selected per-arm size \code{n},
#' its count difference \code{yd}, and vectors \code{prob_h1_vec}, \code{yd_vec},
#' \code{y1_vec}, and \code{y2_vec} for the sizes evaluated. It returns a character
#' message if no candidate meets the cutoff.
#' }
#' \seealso{\code{\link{Count_Post_Prob}}, \code{\link{Count_Sample_Size}}}
NULL

#' @name Two_Arm_Standard_SSE_Design
#' @rdname Two_Arm_Standard_SSE_Design
#' @aliases Two_Arm_Standard_SSE_Design
#' @title Standard Frequentist Two-Arm Design with Optional Interim Bayesian Stop
#' @description Simulates a two-arm clinical trial with binary outcomes.  
#' The design supports an optional interim look that applies a Bayesian posterior-probability stopping rule; otherwise, the final decision is based on a traditional frequentist z-test against a non-inferiority/superiority margin.
#' @rawRd \encoding{UTF-8}
#'
#'
#'
#'
#' \usage{
#' Two_Arm_Standard_SSE_Design(n_f, theta_H, theta_L, theta_s, alpha, interim = F,
#'                  n_0 = NA, a1 = 0.05, b1 = 0.05, a2 = 0.05, b2 = 0.05,
#'                  q = 0.5, c = 0.7, c_s = 0.3)
#' }
#' \arguments{
#'   \item{n_f}{Final (maximum) sample size per arm.}
#'   \item{theta_H}{True success probability in reference group H.}
#'   \item{theta_L}{True success probability in experimental group L.}
#'   \item{theta_s}{Clinically meaningful difference (margin) to be added to the z-statistic.  
#'                  The contrast is L minus H and its threshold is minus theta_s. Positive theta_s specifies a non-inferiority margin for group L.}
#'   \item{alpha}{One-sided Type I error rate for the final frequentist test.}
#'   \item{interim}{Logical; \code{TRUE} performs a Bayesian interim analysis after \code{n_0} patients/arm.}
#'   \item{n_0}{Interim sample size per arm (required only if \code{interim = TRUE}).}
#'   \item{a1, b1}{Beta(\code{a1},\code{b1}) prior parameters for the treatment arm.}
#'   \item{a2, b2}{Beta(\code{a2},\code{b2}) prior parameters for the control arm.}
#'   \item{q}{Prior probability that the treatment is superior (\code{H1}); used in the Bayesian interim look.}
#'   \item{c}{Posterior-probability threshold for early success at interim.}
#'   \item{c_s}{Posterior-probability threshold for early futility at interim.}
#' }
#' \value{
#'   A numeric vector with the following elements:
#'   \describe{
#'     \item{mean_H}{Observed mean success rate in reference group H.}
#'     \item{mean_L}{Observed mean success rate in experimental group L.}
#'     \item{decision}{Decision indicator: 1 = success (superiority), 0 = not superior.}
#'     \item{n_total}{Number of subjects used (may be \code{n_0} if stopped early, otherwise \code{n_f}).}
#'   } 
#' }
#' \references{
#' Bi, D. and Ji, Y. (2024). BESS, a Bayesian Estimator of Sample Size.
#' \doi{10.48550/arXiv.2404.07923}
#' }
#' \author{
#' Rachel Zhuang
#' }
#' \examples{
#' ## one simulated study without interim look
#' Two_Arm_Standard_SSE_Design(
#'   n_f     = 100,
#'   theta_H = 0.65,
#'   theta_L = 0.50,
#'   theta_s = 0.10,
#'   alpha   = 0.025
#' )
#'
#' ## same design with a Bayesian interim at 50 patients/arm
#' Two_Arm_Standard_SSE_Design(
#'   n_f     = 100,
#'   theta_H = 0.65,
#'   theta_L = 0.50,
#'   theta_s = 0.10,
#'   alpha   = 0.025,
#'   interim = TRUE,
#'   n_0     = 50
#' )
#' }
NULL

#' @rawNamespace importFrom("stats", "integrate", "qnorm", "rbinom", "pnorm", "rbeta", "rgamma", "rpois", "qbeta","rnorm", "pbeta", "pgamma", "qt", "rnbinom", "sd", "var")
#' importFrom("utils", "tail")
#' export("One_Arm_Post_Prob_Theta")
#' export("One_Arm_Post_Prob_H1")
#' export("One_Arm_BESS")
#' export("One_Arm_Normal_Post_Prob")
#' export("One_Arm_Normal_Sample_Size")
#' export("One_Arm_Freq_theory")
#' export("One_Arm_t_test_sim")
#' export("Two_Arm_t_test_sim")
#' export("Freq_Binary_theoretical")
#' export("t_test_sim_sample_size")
#' export("Two_Arm_Post_Prob_H1_Sim")
#' export("Two_Arm_Find_Min_Xi")
#' export("Two_Arm_BESS_Binary")
#' export("BESS_SSR_Design")
#' export("Two_Arm_Standard_SSE_Design")
#' export("Two_Arm_Post_Prob_H1")
#' export("Two_Arm_Min_Adj_Prob")
#' export("Two_Arm_Bayes_Sample_Size")
#' export("Two_Arm_Gamma_Post_Prob")
#' export("Two_Arm_Gamma_Min_Effect")
#' export("Two_Arm_Gamma_Sample_Size")
#' export("Two_Arm_Cont_Post_Prob")
#' export("Two_Arm_Cont_Sample_Size")
#' export("Two_Arm_Count_Post_Prob")
#' export("Two_Arm_Count_Min_Effect")
#' export("Two_Arm_Binary_Post_Prob")
#' export("Two_Arm_Binary_Min_Prob")
#' export("Two_Arm_Freq_theory") 
#' export("BESS_binary")
#' export("Post_Prob_Bayes")
#' export("BESS_unified")
#' export("Two_Arm_Combined_Sample_Size")
#' export("Two_Arm_Combined_Post_Prob")
#' export("Freq_Count_Combined")
#' export("Count_Post_Prob")
#' export("Count_Sample_Size")
#' @noRd
NULL
