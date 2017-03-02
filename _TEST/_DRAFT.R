# output.evaluation <- function() {
#   
#   
#   threshold <- c(0, 2, 1, 30, 50)
#   result.char <- c('FAIL', 'OK')
#   data.table(
#     THEME = c('Net Profit',
#               'Monthly Yield',
#               'Trades per Day',
#               'Max Drawdown Percent',
#               'Win Percent'),
#     DESCRIPTION = c(sprintf(' greater than %.2f $', threshold[1]),
#                     sprintf(' no more than %i Loss in a row', threshold[2]),
#                     sprintf(' greater than %.2f trades per day', threshold[3]),
#                     sprintf(' less than %.2f %%', threshold[4]),
#                     sprintf(' greater than %.2f %%', threshold[5])),
#     RESULT = c(sprintf('%.2f $', net.profit),
#                sprintf('max %i', con.monthly.loss),
#                sprintf('%.2f', trades.per.day),
#                sprintf('%.2f %%', mdd.portfolio),
#                sprintf('%.2f %%', win.percent)),
#     EVALUATION = result.char[c(net.profit > threshold[1],
#                                con.monthly.loss <= threshold[2],
#                                trades.per.day > threshold[3],
#                                mdd.portfolio < threshold[4],
#                                win.percent > threshold[5]) + 1]
#   )
# }


A <- data.table(X = 1:3, Y = 4:6) %>% setkey(X)
B <- data.table(X = 1:3, Z = 4:6)  %>% setkey(X)

B[A]
