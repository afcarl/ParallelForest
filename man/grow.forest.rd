\name{grow.forest}
\alias{grow.forest}
\title{Growing random decision forest classifier}
\description{
	Growing random decision forest classifier
}
\usage{
grow.forest(formula, data, subset, na.action,
    impurity.function = "gini", 
    model = FALSE, x = FALSE, y = FALSE,
    min_node_obs, max_depth, 
    numsamps, numvars, numboots)
}
\arguments{
  \item{formula}{an object of class \code{"\link{formula}"} (or one that
    can be coerced to that class): a symbolic description of the
    model to be fitted.}

  \item{data}{an optional data frame, list or environment (or object
    co\\-ercible by \code{\link{as.data.frame}} to a data frame) containing
    the variables in the model.  If not found in \code{data}, the
    variables are taken from \code{environment(formula)},
    typically the environment from which \code{grow.forest} is called.}

  \item{subset}{an optional vector specifying a subset of observations
    to be used in the fitting process.}

  \item{na.action}{a function which indicates what should happen
    when the data contain \code{NA}s.  The default is set by
    the \code{na.action} setting of \code{\link{options}}, and is
    \code{\link{na.fail}} if that is unset.  The \sQuote{factory-fresh}
    default is \code{\link{na.omit}}.  Another possible value is
    \code{NULL}, no action.}

	\item{impurity.function}{the impurity function to be used to fit decision trees, currently only \code{impurity.function = "gini"} is supported.}

  \item{model, x, y}{logicals.  If \code{TRUE} the corresponding
    components of the fit (the model frame, the model matrix, the
    response) are returned.
  }

	\item{min_node_obs}{the minimum number of observations required for a node to be split.}
	\item{max_depth}{the deepest that a tree should be fit (root node is at depth 0).}
	\item{numsamps}{number of samples to draw with replacement for each tree in the forest (bootstrapped sample).}
	\item{numvars}{number of variables to be randomly selected without replacement for each tree in the forest.}
	\item{numboots}{number of trees in the forest.}
}
\details{
  Bootstrapped samples will be automatically balanced between dependent variable classes. Dependent variable must be automatically coercible to 0 and 1. Predictor variables should only be continuous, ordinal, or categorical with only two categories (do not include nominal/categorical variables with three or more categories). Numsamps will be increased as necessary to achieve a number that can divide the number of dependent variable classes so that bootstrapped samples will be balanced.
}
