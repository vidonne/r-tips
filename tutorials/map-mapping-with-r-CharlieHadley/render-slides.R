library(fs)
library(pagedown)
library(tidyverse)
library(knitr)
library(rmarkdown)

rmd_files <- dir_ls(path = "slides/",
                    recurse = TRUE,
                    regexp = ".Rmd")

walk(rmd_files, ~safely({render(.x, params = list(pandoc_args = "--self-contained"))
  print(.x)}))

html_files <- dir_ls(path = "slides",
                     recurse = TRUE,
                     regexp = ".html$")

walk(html_files, ~chrome_print(.x, timeout = 60))

beepr::beep()
