library(htmlTable)
library(rmarkdown)
library(ggvis)

#### @UPDATE IDEA@ ####
## 2017-02-17: 

#### @PATCH NOTE@ ####
## 2017-02-21: Version 0.1


#### REPORT ####
output.report <- function(report, markdown, file.type='HTML') {
  switch(
    file.type,
    'HTML' = output.report.html(report, markdown)
  )
}

output.report.html <- function(report, markdown) {
  windowsFonts(CON = windowsFont("Consolas"))
  with(report, {
    # output.INFOS <- output.report.html.infos(INFOS)
    
    output.report.html.render(markdown, output.file.name(INFOS, 'REPORT'), environment())
  })
}

output.report.html.render <- function(markdown, file.name, envir) {
  # ''' report output file '''
  # 2017-01-30: Version 1.0
  Sys.setlocale(locale = 'us')
  render(markdown, html_document(), output_file = file.name, quiet = T, envir = envir)
  Sys.setlocale(locale = 'Chinese')
} # FINISH




#### + REPORT INFOS ####
output.report.html.infos <- function(infos) {
  # ''' infos for output '''
  # 2016-08-11: Version 1.0
  copy(infos) %>%
    extract(
      j = TIME := time.numeric.to.posixct(TIME)
    ) %>%
    htmlTable(css.table = "width: 100%; margin-top: 1em; margin-bottom: 1em;",
              rnames = F)
} # FINISH

#### + EQUITY ACCOUNT ####
output.report.html.equity.account <- function(timeseries.account) {
  
}

