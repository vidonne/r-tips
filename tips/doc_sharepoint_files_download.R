if (!require("pacman")) install.packages("pacman")

pacman::p_load(RSelenium,
               keyring
)


# unhcr user email  -------------------------------------------------------
unhcr_user_email <- "XXXX@unhcr.org"

# insert list of sharepoint url -------------------------------------------
list_file_sharepoint <- c("https://unhcr365.sharepoint.com/teams/xxxx.xlsx",
                          "https://unhcr365.sharepoint.com/teams/xxxx.csv")

# path to download folder -------------------------------------------------
path_download_folder <- "C:\\Users\\folder1\\folder2"


# set download folder -----------------------------------------------------
eCap <- list("chromeOptions" = list(prefs = list("download.default_directory" = path_download_folder),
                                    args = list('--headless')
)
)


rD <- rsDriver(browser = "chrome",
               port=1245L,
               chromever = "90.0.4430.24",
               extraCapabilities = eCap)


remDr <- rD[["client"]]


# path to sharepoint ------------------------------------------------------
remDr$navigate("https://unhcr365.sharepoint.com")


# login to sharepoint -----------------------------------------------------
### insert email
webElem <-NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = "name", value = "loginfmt")},
                      error = function(e){NULL})
}

remDr$findElement(using = "name", value = "loginfmt")$sendKeysToElement(list(unhcr_user_email))
remDr$findElement(using = "id", value = "idSIButton9")$clickElement()

### insert password
Sys.sleep(1)
remDr$findElement(using = "name", value = "passwd")$sendKeysToElement(list(key_get("",                # Please fill with service information
                                                                                   "XXXX@unhcr.org",  # Please fill with username information
                                                                                   keyring ="")       # Please fill with keyring information
))


### Lock keyring
keyring_lock(keyring = "")                                                                            # Please fill with keyring information
Sys.sleep(1)
remDr$findElement(using = "id", value = "idSIButton9")$clickElement()
Sys.sleep(1)

### stay connect
remDr$findElement(using = "id", value = "idSIButton9")$clickElement()
Sys.sleep(1)


for(i in list_file_sharepoint){
  Sys.sleep(1)
  remDr$navigate(i)
}


rm(path_download_folder, unhcr_user_email,
   list_file_sharepoint,
   remDr, eCap, rD, webElem, i
)
