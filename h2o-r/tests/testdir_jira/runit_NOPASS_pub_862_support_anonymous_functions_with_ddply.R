setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

test.pub_862_support_anonymous_functions_with_ddply <- function(H2Oserver) {

covtype.hex <- h2o.importFile(H2Oserver, normalizePath(locate("smalldata/covtype/covtype.20k.data")), "cov")

covtype.local = as.data.frame(covtype.hex)

# Are we in the right universe?
expect_equal(20000, dim(covtype.local)[1])
expect_equal(55, dim(covtype.local)[2])

###########################################################
# execs
###########################################################

h2o.ddply(covtype.hex, c(2), function(x) { mean( x[,2]) })

testEnd()

}

doTest("PUB-862 ddply should support anonymous functions.", test.pub_862_support_anonymous_functions_with_ddply)

