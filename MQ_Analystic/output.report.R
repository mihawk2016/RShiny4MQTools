library(htmlTable)
library(rmarkdown)
library(ggplot2)

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

#### + OUTPUT EVALUATION ####


#### OTHERS ####
yield.calendar <- function(dt, percent=TRUE, digits=2) {
  setkey(dt, TIME)
  tb <- dt[, .(TIME, RETURN, YM = format(TIME, '%Y%m'))]
  years <- year(tb[1, TIME]):year(tb[.N, TIME])
  calendar <- matrix(data = NA, nrow = length(years), ncol = 13,
                     dimnames = list(years, c(strftime(seq.Date(as.Date("2000-01-01"), length.out = 12, by = "months"), format = "%b"), 'TOTAL')))
  tb[, {
    year <- substr(YM[1], 1, 4)
    month <- as.numeric(substr(YM[1], 5, 6))
    calendar[year, month] <<- cum.return(RETURN) %>%
      extract(length(.))
  }, by = YM]
  tb[, {
    year <- substr(YM[1], 1, 4)
    calendar[year, 13] <<- cum.return(RETURN) %>%
      extract(length(.))
  }, by = substr(YM, 1,4)]
  calendar %>%
    as.data.table(keep.rownames=TRUE) %>%
    setnames(1, 'YIELD(%)')
} # FINISH

mddp.calendar <- function(dt, percent=TRUE, digits=2) {
  setkey(dt, TIME)
  tb <- dt[, .(TIME, RETURN, YM = format(TIME, '%Y%m'))]
  years <- year(tb[1, TIME]):year(tb[.N, TIME])
  calendar <- matrix(data = NA, nrow = length(years), ncol = 13,
                     dimnames = list(years, c(strftime(seq.Date(as.Date("2000-01-01"), length.out = 12, by = "months"), format = "%b"), 'TOTAL')))
  tb[, {
    year <- substr(YM[1], 1, 4)
    month <- as.numeric(substr(YM[1], 5, 6))
    RETURN[is.na(RETURN)] <- 0
    return.serie <- cumprod(RETURN + 1)
    calendar[year, month] <<- return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO] / return.serie[.$FROM]
      } %>% {
        if (percent) {
          (.) %>% multiply_by(100)
        } else {
          .
        }
      } %>%
      round(digits)
  }, by = YM]
  tb[, {
    year <- substr(YM[1], 1, 4)
    RETURN[is.na(RETURN)] <- 0
    return.serie <- cumprod(RETURN + 1)
    calendar[year, 13] <<- return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO] / return.serie[.$FROM]
      } %>% {
        if (percent) {
          (.) %>% multiply_by(100)
        } else {
          .
        }
      } %>%
      round(digits)
  }, by = substr(YM, 1,4)]
  calendar %>%
    as.data.table(keep.rownames=TRUE) %>%
    setnames(1, 'MaxDD(%)')
} # FINISH

sharpe.ratio <- function(x) {
  # ''' calculate sharpe ratio '''
  # 2016-08-19: Done
  mean(x) / sd(x)
} # 2016-08-19: Done

score.yearly.return <- function(yearly.return) {
  if (yearly.return <= 0) {
    return(0)
  }
  if (yearly.return >= 40) {
    return(100)
  }
  round(yearly.return * 2.5, 0)
}
score.mddp <- function(mddp) {
  if (mddp >= 30) {
    return(0)
  }
  round(100 - yearly.return * 10 / 3, 0)
}
level <- function(score) {
  if (score >= 80) {
    'A'
  } else if (score >= 60) {
    'B'
  } else if (score >= 40) {
    'C'
  } else if (score >= 20) {
    'D'
  } else {
    'E'
  }
}