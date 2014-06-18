# set directory to where the shared library is stored
setwd("~/ParallelDecisionTree/src/")

# load the shared libraries compiled in Fortran
dyn.load("~/ParallelDecisionTree/src/grow_predict_rwrapper.dll")
is.loaded("grow_predict_rwrapper")

# define data
n = 100
p = 2

datamat = matrix( c(
   0.01000,       0.01000,      0,
   0.01000,       0.02000,      0,
   0.01000,       0.03000,      0,
   0.01000,       0.04000,      1,
   0.01000,       0.05000,      1,
   0.01000,       0.06000,      1,
   0.01000,       0.07000,      1,
   0.01000,       0.08000,      1,
   0.01000,       0.09000,      1,
   0.01000,       0.10000,      1,
   0.02000,       0.01000,      0,
   0.02000,       0.02000,      0,
   0.02000,       0.03000,      0,
   0.02000,       0.04000,      1,
   0.02000,       0.05000,      1,
   0.02000,       0.06000,      1,
   0.02000,       0.07000,      1,
   0.02000,       0.08000,      1,
   0.02000,       0.09000,      1,
   0.02000,       0.10000,      1,
   0.03000,       0.01000,      0,
   0.03000,       0.02000,      0,
   0.03000,       0.03000,      0,
   0.03000,       0.04000,      1,
   0.03000,       0.05000,      1,
   0.03000,       0.06000,      1,
   0.03000,       0.07000,      1,
   0.03000,       0.08000,      1,
   0.03000,       0.09000,      1,
   0.03000,       0.10000,      1,
   0.04000,       0.01000,      0,
   0.04000,       0.02000,      0,
   0.04000,       0.03000,      0,
   0.04000,       0.04000,      1,
   0.04000,       0.05000,      1,
   0.04000,       0.06000,      1,
   0.04000,       0.07000,      1,
   0.04000,       0.08000,      1,
   0.04000,       0.09000,      1,
   0.04000,       0.10000,      1,
   0.05000,       0.01000,      0,
   0.05000,       0.02000,      0,
   0.05000,       0.03000,      0,
   0.05000,       0.04000,      1,
   0.05000,       0.05000,      1,
   0.05000,       0.06000,      1,
   0.05000,       0.07000,      1,
   0.05000,       0.08000,      1,
   0.05000,       0.09000,      1,
   0.05000,       0.10000,      1,
   0.06000,       0.01000,      1,
   0.06000,       0.02000,      1,
   0.06000,       0.03000,      0,
   0.06000,       0.04000,      1,
   0.06000,       0.05000,      1,
   0.06000,       0.06000,      1,
   0.06000,       0.07000,      1,
   0.06000,       0.08000,      1,
   0.06000,       0.09000,      1,
   0.06000,       0.10000,      1,
   0.07000,       0.01000,      1,
   0.07000,       0.02000,      1,
   0.07000,       0.03000,      1,
   0.07000,       0.04000,      1,
   0.07000,       0.05000,      1,
   0.07000,       0.06000,      1,
   0.07000,       0.07000,      1,
   0.07000,       0.08000,      1,
   0.07000,       0.09000,      1,
   0.07000,       0.10000,      1,
   0.08000,       0.01000,      1,
   0.08000,       0.02000,      1,
   0.08000,       0.03000,      1,
   0.08000,       0.04000,      1,
   0.08000,       0.05000,      1,
   0.08000,       0.06000,      1,
   0.08000,       0.07000,      1,
   0.08000,       0.08000,      1,
   0.08000,       0.09000,      1,
   0.08000,       0.10000,      1,
   0.09000,       0.01000,      1,
   0.09000,       0.02000,      1,
   0.09000,       0.03000,      1,
   0.09000,       0.04000,      1,
   0.09000,       0.05000,      1,
   0.09000,       0.06000,      1,
   0.09000,       0.07000,      1,
   0.09000,       0.08000,      1,
   0.09000,       0.09000,      1,
   0.09000,       0.10000,      1,
   0.10000,       0.01000,      1,
   0.10000,       0.02000,      1,
   0.10000,       0.03000,      1,
   0.10000,       0.04000,      1,
   0.10000,       0.05000,      1,
   0.10000,       0.06000,      1,
   0.10000,       0.07000,      1,
   0.10000,       0.08000,      1,
   0.10000,       0.09000,      1,
   0.10000,       0.10000,      1
   ), nrow=n, ncol=(p+1), byrow=TRUE)

xtrain = datamat[,c(1,2)]
ytrain = datamat[,3]


# TODO: make sure that xtrain and xtest are DOUBLE matrices

# fit data to tree, and make sure that predicted values on same data
# is the same as was inputted
ret = .Fortran("grow_predict_rwrapper",
	n=as.integer(n), p=as.integer(p),
	xtrain=as.matrix(xtrain), ytrain=as.integer(ytrain),
	xtest=as.matrix(xtrain),ytesthat=integer(n))

if(!all(ret$ytrain==ret$ytesthat)) {
   stop("Test failed.")
}

