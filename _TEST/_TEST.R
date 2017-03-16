rm(list = ls())

package.list <- search()
if ('package:RMitekeLab' %in% package.list) {
  detach('package:RMitekeLab', unload = TRUE)
}
library(RMitekeLab)
library(ggplot2)
library(knitr)
library(htmltools)
# library(fPortfolio)
library(fMultivar)
source('./MQ_Analystic/CLASS.mq_analystic.R')
source('./MQ_Analystic/output.report.R')


files <- file.path('./_TEST/_FILES', dir('./_TEST/_FILES')) %>%
  extract(1:12)

TEST <- MQ_ANALYSTIC$new()
TEST$add.files(files)
# TEST$set('selected.index', 6)
time1 <- system.time({
  # TEST$get.report(member='INFOS')

  TEST$output.report(index = 5)
  # TEST
  # TEST$output.tickets(index = 1)
})
print(time1)

# REPORT <- TEST$get.report(index = 6)[[1]]
# save(REPORT, file = './_TEST/report.rdata')
# load('./_TEST/report.rdata')
