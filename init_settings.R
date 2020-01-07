dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, ifelse(.Platform$OS.type == "windows", "Makevars.win", "Makevars"))
if (!file.exists(M)) file.create(M)
cat("\nCXX14FLAGS=-O3 -march=native -mtune=native",
    if( grepl("^darwin", R.version$os)) "CXX14FLAGS += -arch x86_64 -ftemplate-depth-256" else 
      if (.Platform$OS.type == "windows") "CXX11FLAGS=-O3 -march=native -mtune=native" else
        "CXX14FLAGS += -fPIC",
    file = M, sep = "\n", append = TRUE)

require(lobstr)
require(ggridges)
require(loo)
require(rethinking)
require(tidyr)
require(tidyverse)
require(dplyr)
require(ggplot2)
require(tidyr)
require(tidybayes)
require(bayesplot)
require(brms)
require(broom)
library(lubridate)
require(imputeTS)
require(smooth)
require(Mcomp)
require(hash)
require(rlist)
require(feather)
require(modelr)
require(gridExtra)
require(scales)
require(ggrepel)
require(posterior)
require(cmdstanr)

options(warnPartialMatchDollar = TRUE)
Sys.setenv("_R_CHECK_LENGTH_1_CONDITION_" = "true")

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

options(stringsAsFactors = FALSE)