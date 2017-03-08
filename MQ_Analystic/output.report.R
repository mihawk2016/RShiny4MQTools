library(htmlTable)
library(rmarkdown)
library(ggplot2)

#### @UPDATE IDEA@ ####
## 2017-02-17: 

#### @PATCH NOTE@ ####
## 2017-02-21: Version 0.1


#### REPORT ####
output.report <- function(report, file, markdown, file.type='HTML') {
  switch(
    file.type,
    'HTML' = output.report.html(report, file, markdown)
  )
}

output.report.html <- function(report, file.name, markdown) {
  windowsFonts(CON = windowsFont("Consolas"))
  with(report, {
    output.report.html.render(markdown, file.name, environment())
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
  tb <- dt[, .(TIME, RETURN, YM = format(TIME, '%Y%m'), Y = format(TIME, '%Y'))]
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
    calendar[Y[1], 13] <<- cum.return(RETURN) %>%
      extract(length(.))
  }, by = Y]
  calendar %>%
    as.data.table(keep.rownames=TRUE) %>%
    setnames(1, 'YIELD(%)')
} # FINISH

mddp.calendar <- function(dt, percent=TRUE, digits=2) {
  setkey(dt, TIME)
  tb <- dt[, .(TIME, RETURN, YM = format(TIME, '%Y%m'), Y = format(TIME, '%Y'))]
  years <- year(tb[1, TIME]):year(tb[.N, TIME])
  calendar <- matrix(data = NA, nrow = length(years), ncol = 13,
                     dimnames = list(years, c(strftime(seq.Date(as.Date("2000-01-01"), length.out = 12, by = "months"), format = "%b"), 'TOTAL')))
  tb[, {
    year <- substr(YM[1], 1, 4)
    month <- as.numeric(substr(YM[1], 5, 6))
    RETURN[is.na(RETURN)] <- 0
    return.serie <- cumprod(RETURN + 1)
    calendar[year, month] <<-
      return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO][1] / return.serie[.$FROM][1]
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
    RETURN[is.na(RETURN)] <- 0
    return.serie <- cumprod(RETURN + 1)
    calendar[Y[1], 13] <<- return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO][1] / return.serie[.$FROM][1]
      } %>% {
        if (percent) {
          (.) %>% multiply_by(100)
        } else {
          .
        }
      } %>%
      round(digits)
  }, by = Y]
  calendar %>%
    as.data.table(keep.rownames=TRUE) %>%
    setnames(1, 'MaxDD(%)')
} # FINISH

balance.mddp.calendar <- function(tickets.edited, tickets.money, percent=TRUE, digits=2) {
  tb <-
    tickets.edited %>%
    rbind(copy(tickets.money) %>% extract(j = c('NPROFIT', 'CTIME') := list(PROFIT, time.numeric.to.posixct(OTIME))),
          use.names=TRUE, fill=TRUE) %>%
    setkey(CTIME) %>%
    extract(
      j = diff.ratio := {
        bal <- cumsum(NPROFIT)
        NPROFIT / c(0, bal[-length(bal)]) + 1
      }
    ) %>%
    extract(
      i = GROUP != 'MONEY',
      j = .(TIME = CTIME, diff.ratio, YM = format(CTIME, '%Y%m'), Y = format(CTIME, '%Y'))
    )
  years <- year(tb[1, TIME]):year(tb[.N, TIME])
  calendar <- matrix(data = NA, nrow = length(years), ncol = 13,
                     dimnames = list(years, c(strftime(seq.Date(as.Date("2000-01-01"), length.out = 12, by = "months"), format = "%b"), 'TOTAL')))
  tb[, {
    year <- substr(YM[1], 1, 4)
    month <- as.numeric(substr(YM[1], 5, 6))
    diff.ratio[is.na(diff.ratio)] <- 0
    return.serie <- cumprod(diff.ratio)
    calendar[year, month] <<-
      return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO][1] / return.serie[.$FROM][1]
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
    diff.ratio[is.na(diff.ratio)] <- 0
    return.serie <- cumprod(diff.ratio)
    calendar[Y[1], 13] <<- return.serie %>%
      maxdrawdown %>% {
        1 - return.serie[.$TO][1] / return.serie[.$FROM][1]
      } %>% {
        if (percent) {
          (.) %>% multiply_by(100)
        } else {
          .
        }
      } %>%
      round(digits)
  }, by = Y]
  calendar %>%
    as.data.table(keep.rownames=TRUE) %>%
    setnames(1, 'MaxDD(%)')
}

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
  yearly.return * 2.5
}
score.mddp <- function(mddp) {
  if (mddp >= 30) {
    return(0)
  }
  100 - mddp * 10 / 3
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

myAssetsCorImagePlot <- function (x, labels = TRUE, show = c("cor", "test"),
                                  use = c("pearson", "kendall", "spearman"), abbreviate = 3, ...) {
  R = x
  show = match.arg(show)
  use = match.arg(use)
  R = na.omit(R, ...)
  Names = colnames(R) = substring(colnames(R), 1, abbreviate)
  R = as.matrix(R)
  n = NCOL(R)
  if (show == "cor") {
    corr <- cor(R, method = use)
    if (show == "test") {
      test = corr * NA
      for (i in 1:n) for (j in 1:n) test[i, j] = cor.test(R[, 
                                                            i], R[, j], method = use)$p.value
    }
  }
  else if (show == "robust") {
    stop("robust: Not Yet Implemented")
  }
  else if (show == "shrink") {
    stop("robust: Not Yet Implemented")
  }
  corrMatrixcolors <- function(ncolors) {
    k <- round(ncolors/2)
    r <- c(rep(0, k), seq(0, 1, length = k))
    g <- c(rev(seq(0, 1, length = k)), rep(0, k))
    b <- rep(0, 2 * k)
    res <- (rgb(r, g, b))
    res
  }
  ncolors <- 10 * length(unique(as.vector(corr)))
  image(x = 1:n, y = 1:n, z = corr[, n:1], col = corrMatrixcolors(ncolors), 
        axes = FALSE, main = "", xlab = "", ylab = "", ...)
  if (show == "cor") 
    X = t(corr)
  else X = t(test)
  coord = grid2d(1:n, 1:n)
  for (i in 1:(n * n)) {
    text(coord$x[i], coord$y[n * n + 1 - i], round(X[coord$x[i], 
                                                     coord$y[i]], digits = 2), col = "white", cex = 0.7)
  }
  if (labels) {
    axis(2, at = n:1, labels = Names, las = 2, font = 11, pos = 0.5, tick = FALSE, cex.axis = 0.8)
    axis(1, at = 1:n, labels = Names, las = 2, font = 11, pos = 0.5, tick = FALSE, cex.axis = 0.8)
    Names = c(pearson = "Pearson", kendall = "Kendall", spearman = "Spearman")
    if (show == "test") 
      Test = "Test"
    else Test = ""
    title(main = 'Symbols Yiels Correlations')
    # mText = paste("Method:", show)
    # mtext(mText, side = 4, adj = 0, col = "grey", cex = 0.7)
  }
  box()
  invisible()
}