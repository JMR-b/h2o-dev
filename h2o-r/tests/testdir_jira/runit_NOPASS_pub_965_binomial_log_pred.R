##
# NOPASS TEST: The following bug is associated with JIRA PUB-965 
# 'Determine 'correct' behavior for link functions'
# Testing GLM on prostate dataset with BINOMIAL family and log link
##

setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')


test.linkFunctions <- function(conn) {

	print("Read in prostate data.")
	prostate.data = h2o.importFile(conn, locate("smalldata/prostate/prostate_complete.csv.zip"), key="prostate.data")
	
	print("Run test/train split at 20/80.")
	prostate.data$split <- ifelse(h2o.runif(prostate.data)>0.8, yes=1, no=0)
	prostate.train <- h2o.assign(prostate.data[prostate.data$split == 0, c(2:10)], key="prostate.train")
	prostate.test <- h2o.assign(prostate.data[prostate.data$split == 1, c(2:10)], key="prostate.test")

	print("Testing for family: BINOMIAL")
	print("Set variables for h2o.")
	myY = "CAPSULE"
	myX = c("AGE","RACE","DCAPS","PSA","VOL","DPROS","GLEASON")
	
	print("Create model with link: LOG")
	model.h2o.binomial.log <- h2o.glm(x=myX, y=myY, data=prostate.train, family="binomial", link="log",alpha=0.5, lambda=0, nfolds=0)
	
	print("Predict")
	prediction.h2o.binomial.log <- h2o.predict(model.h2o.binomial.log, prostate.test)
	print(head(prediction.h2o.binomial.log))
	
	print("Check strength of predictions all within [0,1] domain")
	ouside.domian <- prediction.h2o.binomial.log[,prediction.h2o.binomial.log$"0"<0 | prediction.h2o.binomial.log$"0">1]
	stopifnot(dim(outside.domain)[1] == 0) # There should be no predictions with strength less than 0 or greater than 1

testEnd()
}

doTest("Testing GLM on prostate dataset with BINOMIAL family and log link", test.linkFunctions)


