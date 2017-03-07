

# con.monthly.loss <-
#   AAA %>%
#   setkey(TIME) %>%
#   extract(
#     j = .(TIME, BALANCE.DELTA = c(0, BALANCE.DELTA) %>% diff, YM = format(TIME, '%Y%m'))
#   ) %T>% print %>%
#   extract(
#     j = .(M.PROFIT = sum(BALANCE.DELTA)),
#     by = YM
#   ) %>% print


xx <- data.table(x = 1:4, y = c('xaaa', 'xbbb', 'xccc', 'xddd'))


xx[1:2, print(x), by = (substr(y, 1, 4))]


# columns <- c('FILE')
# groups <- c('CLOSED')
# # columns
# REPORT$TICKETS.EDITING %>%
#   setkey(GROUP) %>%
#   extract(
#     j = c('OTIME', 'CTIME') := list(time.numeric.to.posixct(OTIME), time.numeric.to.posixct(CTIME))
#   ) %>%
#   extract(
#     i = groups,
#     j = c('TICKET', 'OTIME', 'TYPE', 'VOLUME', 'ITEM', 'OPRICE', 'SL', 'TP',
#           'CTIME', 'CPRICE', 'COMMISSION', 'TAXES', 'SWAP', 'PROFIT', columns),
#     nomatch = 0,
#     with = F
#   ) %T>% print# %>%
#   # write.csv(file = 'abc.csv')



# # output.evaluation <- function() {
# #   
# #   
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
# # }
# 
# 
# # A <- data.table(X = 1:3, Y = 4:6) %>% setkey(X)
# # B <- data.table(X = 1:3, Z = 4:6)  %>% setkey(X)
# # 
# # B[A]
# 
# 
# time.numeric.to.posixct(123)
# 
# as.period(interval(time.numeric.to.posixct(0), time.numeric.to.posixct(1230)))

