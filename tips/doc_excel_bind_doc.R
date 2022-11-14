library(readxl)
library(data.table)

file.list <- list.files(pattern = '*.xlsx')
file.list <- setNames(file.list, file.list)
df.list <- lapply(file.list, read_excel, sheet = 1, skip = 0)
df.list <- Map(function(df, name) {
  df$source_name <- name
  df
}, df.list, names(df.list))
df <- rbindlist(df.list, idcol = "id")