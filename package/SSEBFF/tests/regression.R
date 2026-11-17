library(SSEBFF)

assert_equal <- function(actual, expected, tolerance = 1e-8) {
  stopifnot(isTRUE(all.equal(actual, expected, tolerance = tolerance, scale = 1)))
}

# The beta(1, 1) prior and two successes give beta(3, 1).
assert_equal(One_Arm_Post_Prob_Theta(2, 0.5, 1, 1, 1, 1), 7 / 8)

# Count means above one and negative continuous observations are valid.
assert_equal(
  One_Arm_Post_Prob_H1(20, 2, 3, 3, 1, 1),
  stats::pgamma(2, shape = 61, rate = 21, lower.tail = FALSE)
)
assert_equal(
  One_Arm_Post_Prob_H1(10, -1, -0.5, 2, 0, 1, sig = 2),
  One_Arm_Normal_Post_Prob(10, -1, -0.5, 0, 1, 2)
)
assert_equal(
  One_Arm_BESS(0.5, 0.9, 0.7, 1, 1, 1, n_min = 5L, n_max = 50L),
  One_Arm_BESS(0.5, 0.9, 0.7, 1, 1, 1, n_min = 5, n_max = 50)
)

# Observed two-arm counts contain the evidence needed by this calculation.
set.seed(42)
observed <- Post_Prob_Bayes("two.sample", n = 20, delta = 0,
                           outcome = 1, Y_t = 8, Y_c = 13)
set.seed(42)
expected <- Two_Arm_Post_Prob_H1(8, 13, 20, 0)
assert_equal(observed, expected)

# Compare the simulated interim result with the analytic normal posterior.
set.seed(17)
normal_trial <- BESS_SSR_Design(
  "two.sample", theta_H = 3, theta_L = 3, theta_s = 0,
  c = 0.99, c_s = 0.01, n0 = 8, outcome = 2,
  a1 = 0, b1 = 2, a2 = 1, b2 = 3, sig = 2, n_min = 2, n_max = 3
)
variance_c <- 1 / (1 / 2^2 + 8 / 2^2)
variance_t <- 1 / (1 / 3^2 + 8 / 2^2)
mean_c <- variance_c * sum(normal_trial$y_L_n0) / 2^2
mean_t <- variance_t * (1 / 3^2 + sum(normal_trial$y_H_n0) / 2^2)
expected <- stats::pnorm((mean_t - mean_c) / sqrt(variance_c + variance_t))
assert_equal(normal_trial$pH1_int, expected, tolerance = 0.02)
stopifnot(normal_trial$bess_int_dec == 2, normal_trial$n_s %in% 2:3)

# Check the final posterior against a single update using all observations.
total_n <- 8 + normal_trial$n_s
variance_c <- 1 / (1 / 2^2 + total_n / 2^2)
variance_t <- 1 / (1 / 3^2 + total_n / 2^2)
mean_c <- variance_c * sum(c(normal_trial$y_L_n0, normal_trial$y_L_ns)) / 2^2
mean_t <- variance_t * (1 / 3^2 + sum(c(normal_trial$y_H_n0, normal_trial$y_H_ns)) / 2^2)
expected <- stats::pnorm((mean_t - mean_c) / sqrt(variance_c + variance_t))
assert_equal(normal_trial$pH1_s, expected, tolerance = 0.02)

# Unequal priors make swapped treatment/control hyperparameters detectable.
set.seed(19)
binary_trial <- BESS_SSR_Design(
  "two.sample", theta_H = 0.8, theta_L = 0.2, theta_s = 0,
  c = 0.95, c_s = 0.1, n0 = 10, outcome = 1,
  a1 = 2, b1 = 5, a2 = 8, b2 = 2, n_min = 2, n_max = 3
)
expected <- Two_Arm_Post_Prob_H1(
  sum(binary_trial$y_H_n0), sum(binary_trial$y_L_n0), 10, 0,
  alpha1 = 8, beta1 = 2, alpha2 = 2, beta2 = 5, iterations = 20000
)
assert_equal(binary_trial$pH1_int, expected, tolerance = 0.02)

# Negative rate differences must still produce nonnegative event totals.
set.seed(23)
count_minimum <- Two_Arm_Count_Min_Effect(
  -2, 5, -3, a_t = 1, b_t = 1, a_c = 1, b_c = 1,
  s_reps = 10, reps = 200
)
stopifnot(count_minimum$y1 >= 0, count_minimum$y2 >= 0,
          count_minimum$y1 - count_minimum$y2 == -10,
          is.finite(count_minimum$prob),
          count_minimum$prob >= 0, count_minimum$prob <= 1)

# Exercise the count continuation branch and its total sample size cap.
set.seed(11)
count_trial <- BESS_SSR_Design(
  "one.sample", theta_H = 3, theta_s = 3,
  c = 1, c_s = 0, n0 = 8, outcome = 3,
  n_min = 2, n_max = 3, cap = TRUE, n_cap = 10
)
stopifnot(count_trial$bess_int_dec == 2, count_trial$n_s == 2,
          length(count_trial$y_ns) == 2, is.finite(count_trial$pH1_s))
cap_error <- tryCatch(
  BESS_SSR_Design("one.sample", theta_H = 3, theta_s = 3,
                 c = 1, c_s = 0, n0 = 8, outcome = 3,
                 cap = TRUE, n_cap = 8),
  error = conditionMessage
)
stopifnot(is.character(cap_error), grepl("greater than n0", cap_error))

type_error <- tryCatch(
  Freq_Binary_theoretical(0.05, 0.2, 0.7, 0.5, "invalid"),
  error = conditionMessage
)
stopifnot(is.character(type_error), grepl("choose from", type_error))

# A normal one-arm continuation must preserve the original prior information.
set.seed(31)
one_normal <- BESS_SSR_Design(
  "one.sample", theta_H = 3, theta_s = 3, c = 1, c_s = 0,
  n0 = 3, outcome = 2, a = 1, b = 2, n_min = 1, n_max = 1
)
stopifnot(one_normal$bess_int_dec == 2, one_normal$n_s == 1)
all_data <- c(one_normal$y_n0, one_normal$y_ns)
expected <- One_Arm_Normal_Post_Prob(length(all_data), 3, mean(all_data),
                                     prior_mean = 1, prior_sd = 2, sigma = 1)
assert_equal(one_normal$pH1_s, expected)

# Exercise a two-arm count continuation with a short search.
set.seed(32)
two_counts <- BESS_SSR_Design(
  "two.sample", theta_H = 2, theta_L = 3, theta_s = 0,
  c = 1, c_s = 0, n0 = 2, outcome = 3, n_min = 1, n_max = 1
)
stopifnot(two_counts$bess_int_dec == 2, two_counts$n_s == 1,
          length(two_counts$y_H_ns) == 1, length(two_counts$y_L_ns) == 1,
          is.finite(two_counts$pH1_s))

# The combined entry points agree with the individual analytic functions.
assert_equal(Freq_Binary_theoretical(0.05, 0.2, 0.7, 0.5, "one.sample"),
             One_Arm_Freq_theory(0.05, 0.2, 0.7, 0.5))
assert_equal(Freq_Binary_theoretical(0.05, 0.2, 0.7, 0.5),
             Two_Arm_Freq_theory(0.05, 0.2, 0.7, 0.5))
assert_equal(
  Two_Arm_Combined_Post_Prob("continuous", 20, 0.2, effect_size = 0.4,
                            prior_mean = 0, prior_sd = 1, sigma = 2),
  Two_Arm_Cont_Post_Prob(20, 0.2, 0.4, 0, 1, 2)
)
