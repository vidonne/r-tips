library("tidyverse")
library("fs")
library("tools")

rmds_tib <- tibble(rmd_file = list.files(pattern = ".Rmd", full.names = TRUE, recursive = TRUE))

rmds_tib <- rmds_tib %>%
  mutate(rmd_base_name = file_path_sans_ext(path_sanitize(basename(rmd_file), replacement = "-")),
         rmd_path = path_dir(rmd_file),
         html_folder = file.path(rmd_path, paste0(rmd_base_name, "_files")),
         cache_folder = file.path(rmd_path, paste0(rmd_base_name, "_cache")),
         libs_folder = file.path(rmd_path, paste0("libs")),
         rproj_folder = file.path(rmd_path, paste0(".Rproj.user")),
         html_file = file.path(rmd_path, paste0(rmd_base_name, ".html")),
         icon_file = file.path(rmd_path, paste0("Icon?")))

map(c(rmds_tib$html_folder,
  rmds_tib$html_file,
  rmds_tib$cache_folder,
  rmds_tib$libs_folder,
  rmds_tib$rproj_folder,
  rmds_tib$icon_file),
  ~unlink(.x, recursive = TRUE))

# Done