# SSEBFF

SSEBFF provides sample size calculations and posterior probabilities for
one-arm and two-arm trials with binary, continuous, and count outcomes.

The main entry points are `Freq_Binary_theoretical()`,
`t_test_sim_sample_size()`, `Freq_Count_Combined()`, `Post_Prob_Bayes()`,
`BESS_unified()`, `Count_Post_Prob()`, `Count_Sample_Size()`, and
`BESS_SSR_Design()`. See the function help for prior parameter mappings and
the direction of each treatment comparison.

```r
library(SSEBFF)

Freq_Binary_theoretical(
  alpha = 0.05, beta = 0.2, theta1 = 0.7, theta0 = 0.5
)

BESS_unified(
  theta0 = 0.1, c = 0.95, e = 0.2,
  type = "one.sample", outcome = 1, a = 1, b = 1
)

vignette("Bayesian", package = "SSEBFF")
vignette("Frequentist", package = "SSEBFF")
```

The sample size searches use the specified outcome models, priors, margins,
and search ranges. Simulation-based results depend on the random draws and
the simulation budget. Bayesian sample size criteria are evaluated
conditional on the assumed evidence. Repeated trial simulations can assess
frequentist operating characteristics for a chosen design.

The Bayesian sample size framework is described by Bi and Ji (2024),
[BESS, a Bayesian Estimator of Sample Size](https://doi.org/10.48550/arXiv.2404.07923).

The package uses the CC0 license.

## Development

Open the package directory before running development commands. Documentation
is maintained in `R/documentation.R`; regenerate the help pages and namespace
with `devtools::document()`. Edit that source rather than generated `man/` files.

The vignettes use knitr and markdown. Install these suggested packages before
building. A full check with `manual = TRUE` also requires a LaTeX installation.
