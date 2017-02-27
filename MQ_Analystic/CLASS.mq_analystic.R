# library(compiler)
# library(R6)
# compilePKGS(T)
# 
# 
# #### @UPDATE IDEA@ ####
# ## 2017-02-22: 
# 
# #### @PATCH NOTE@ ####
# ## 2017-02-22: Version 0.1

library(RMitekeLab)
library(R6)

MQ_ANALYSTIC <- R6Class(
  classname = 'MetaQuote Analystic',
  public = list(
    initialize = function() {
      private$SYMBOLS.SETTING <- SYMBOLS.SETTING
      private$MYSQL.SETTING <- MYSQL.SETTING
      private$DB.OPEN.FUN <- DB.O
      private$DB.OHLC.FUN <- DB.OHLC
    },
    #### ACTIONS ####
    add.files = function(files, parallel=private$PARALLEL.THRESHOLD.READ.FILES) {
      files.data <- read.mq.file(files, parallel)
      mismatch.index <-
        sapply(files.data, is.character) %>% which
      if (length(mismatch.index)) {
        self$append('mismatch', unlist(files.data[mismatch.index]))
        self$append('report', files.data[-mismatch.index])
      } else {
        self$append('report', files.data)
      }
    },
    clear.files = function() {
      private$selected.index = c()
      private$mismatch <- c()
      private$report <- list()
      private$merged.report <- NULL
    },
    
    
    output.report = function(report=private$report[[2]], markdown=private$MARKDOWNS[1]) {
      output.report(report, markdown, file.type='HTML')
    },
    
    #### PHASES ####
    phase2 = function(report.phase1, index) {
      reports.PHASE2(report.phase1, index,
                     private$DEFAULT.CURRENCY, private$DEFAULT.LEVERAGE, private$DB.OPEN.FUN,
                     private$MYSQL.SETTING, private$TIMEFRAME.TICKVALUE, private$SYMBOLS.SETTING,
                     private$PARALLEL.THRESHOLD.GENERATE.TICKETS)
    },
    phase3 = function(report.phase2, set.init.money=NULL, include.middle=TRUE) {
      reports.PHASE3(report.phase2,
                     set.init.money, include.middle, private$DEFAULT.INIT.MONEY,
                     private$DEFAULT.CURRENCY, private$DB.OPEN.FUN, private$TIMEFRAME.TICKVALUE,
                     private$DB.OHLC.FUN, private$TIMEFRAME.REPORT, private$PARALLEL.THRESHOLD.DB.SYMBOLS,
                     private$SYMBOLS.SETTING, private$PARALLEL.THRESHOLD.GENERATE.TICKETS)
    },
    
    #### GETTER & SETTER ####
    get.report = function(member, index, set.init.money=NULL, include.middle=TRUE) {
      if (missing(index)) {
        index <- 1:length(private$report)
      }
      if (missing(member)) {
        return(private$report[index])
      }
      if (all(member %in% CONTENT.PHASE1)) {
        return(private$get.report.simple(member, index))
      }
      if (any(member %in% c(CONTENT.PHASE2, CONTENT.PHASE3))) {
        null.sub.index <- sapply(private$report[index], function(r) r$PHASE == 1) %>% which
        if (length(null.sub.index)) {
          null.index <- index[null.sub.index]
          self$set.report(index = null.index, value = self$phase2(private$report[null.index], null.index))
        }
      }
      if (any(member %in% CONTENT.PHASE3)) {
        null.sub.index <- sapply(private$report[index], function(r) r$PHASE == 2) %>% which
        if (length(null.sub.index)) {
          null.index <- index[null.sub.index]
          self$set.report(index = null.index, value = self$phase3(private$report[null.index],
                                                                  set.init.money, include.middle))
        }
      }
      return(private$get.report.simple(member, index))
    },
    set.report = function(member, index, value) {
      if (missing(index)) {
        index <- 1:length(private$report)
      }
      if (missing(member)) {
        return(private$report[index] <- value)
      }
      private$report[index] <-
        mapply(function(r, m, v) {
          r %>% inset(m, v)
        }, r = private$report[index], v = value, MoreArgs = list(m = member))
    },
    get.merged.report = function(member) {
      if (missing) {
        private$merged.report
      } else {
        private$merged.report[[member]]
      }
    },
    set.merged.report = function(member, value) {
      if (missing) {
        private$merged.report
      } else {
        private$merged.report[[member]] <- value 
      }
    },
    get = function(member) {
      private[[member]]
    },
    set = function(member, value) {
      private[[member]] <- value
    },
    append = function(member, value) {
      private[[member]] %<>% c(value)
    }
  ),
  private = list(
    SYMBOLS.SETTING = NULL,
    PARALLEL.THRESHOLD.READ.FILES = 200,
    PARALLEL.THRESHOLD.GENERATE.TICKETS = 6,
    PARALLEL.THRESHOLD.DB.SYMBOLS = 6,
    DEFAULT.LEVERAGE = 100,
    DEFAULT.CURRENCY = 'USD',
    DEFAULT.INIT.MONEY = 10000,
    TIMEFRAME.TICKVALUE = 'M1',
    TIMEFRAME.REPORT = 'H1',
    MYSQL.SETTING =NULL,
    DB.OPEN.FUN = NULL,
    DB.OHLC.FUN = NULL,
    
    MARKDOWNS = c('./markdown/output.report.Rmd'),
    
    selected.index = c(),
    mismatch = c(),
    report = list(),
    merged.report = NULL,
    
    build.merged.report = function(index=private$selected.index,
                                   default.currency=private$DEFAULT.CURRENCY,
                                   default.leverage=private$DEFAULT.LEVERAGE,
                                   get.open.fun=private$DB.OPEN.FUN,
                                   mysql.setting=private$MYSQL.SETTING,
                                   timeframe=private$TIMEFRAME.TICKVALUE,
                                   symbols.setting=private$SYMBOLS.SETTING,
                                   parallel=private$PARALLEL.THRESHOLD.GENERATE.TICKETS) {
      if (length(index) < 2) {
        return(NULL)
      }
      within(list(), {
        INFOS <- self$get.report('INFOS', index) %>% rbindlist
        CURRENCY <- report.currency(INFOS, default.currency)
        LEVERAGE <- report.leverage(INFOS, default.leverage)
        TICKETS.RAW <- self$get.report('TICKETS.RAW', index, default.currency, default.leverage,
                                       get.open.fun, mysql.setting, timeframe, symbols.setting,
                                       parallel) %>% rbindlist
        ITEM.SYMBOL.MAPPING <- item.symbol.mapping(TICKETS.RAW, symbols.setting[, SYMBOL])
        SUPPORTED.ITEM <- supported.items(ITEM.SYMBOL.MAPPING)
        UNSUPPORTED.ITEM <- unsupported.items(ITEM.SYMBOL.MAPPING)
        TICKETS.SUPPORTED <- tickets.supported(TICKETS.RAW, ITEM.SYMBOL.MAPPING) %>% rbindlist
        PHASE <- 2
      })
    },
    
    #### GETTER & SETTER ####
    get.report.simple = function(member, index) {
      if (length(member) == 1) {
        lapply(private$report[index], function(r) r[[member]])
      } else {
        lapply(private$report[index], function(r) r[member])
      }
    }
  )
)
