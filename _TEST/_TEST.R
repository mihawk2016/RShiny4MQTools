rm(list = ls())

package.list <- search()
if ('package:RMitekeLab' %in% package.list) {
  detach('package:RMitekeLab', unload = TRUE)
}
library(RMitekeLab)
source('./MQ_Analystic/CLASS.mq_analystic.R')
source('./MQ_Analystic/output.report.R')


files <- file.path('./_TEST/_FILES', dir('./_TEST/_FILES')) %>%
  extract(1:10)

TEST <- MQ_ANALYSTIC$new()
TEST$add.files(files)
time1 <- system.time({
  # TEST$output.report()
  TEST
})
print(time1)