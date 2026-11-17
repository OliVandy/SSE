# SSEBFF 0.1.0

* Prepared metadata for the first CRAN submission with Rachel Zhuang as maintainer.
* Added help entries for all exported functions and corrected parameter,
  return-value, comparison-direction, and simulation descriptions.
* Corrected outcome-specific evidence validation and accepted integer sample
  size bounds in the one-arm Bayesian search.
* Removed the unused evidence requirement from two-arm binary posterior calls.
* Corrected continuous means, prior updates, and treatment/control parameter
  mapping in adaptive sample size re-estimation.
* Handled adaptive search boundaries and validated total sample size caps.
* Kept count configurations nonnegative for negative rate differences.
* Removed duplicate combined-function definitions superseded during package loading.
* Added base R regression tests covering these corrections.
* Built reproducible HTML vignettes using knitr and markdown and shortened
  simulation examples.

* Unified roxygen documentation sources and added UTF-8 metadata.
* Passed the specified observation standard deviation to adaptive two-arm
  posterior calculations.
