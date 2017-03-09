#' @export
#'
#' @title checkConvergence - Check the convergence of a mcmc.list object
#'
#' @description Run various diagnostic procedures in the \code{coda} package
#' to check convergence of a set of mcmc chains.
#'
#' @param obj An mcmc.list object from the \code{rjags} package.  These are output
#' by the \code{coda.samples} function. This mcmc.list must contain 2 or more chains.
#'
#' @param quiet Whether to print any output on screen.
#'
#' @details This routine runs the Gelman and Rubin (1992) diagnostic for
#' a set of MCMC chains by calling \code{gelman.diag} in the \code{coda} package.
#'
#' @return A list with the following components
#' \list{
#'   \item converged: If the uppper limits of the  'potential scale
#'   reduction factors' associated with all parameters are less than
#'   \code{criterion}, the chain is declared converged and this is TRUE.
#'   Otherwise, this component of the returns is FALSE.
#'   \item Rhats: the 'potential scale reduction factors' or Rhats
#'   associated with all parameters.
#'  }
#'
#' @author Trent McDonald
#'
#' @references
#' Gelman, A and Rubin, DB (1992) Inference from iterative simulation
#' using multiple sequences, Statistical Science, 7, 457-511.
#'
#' @seealso \link{\code{gelman.diag}}
#'
#' @examples
#' \dontrun{
#' jags = jags.model(file="someJAGSFile.txt",
#'    data=someJAGS.data, inits=someJAGS.inits,
#'    n.chains=3,n.adapt=100)
#' update(jags, n.iter=1000)
#' out = coda.samples(jags,
#'    variable.names=c("someParameter"),
#'    n.iter=1000,
#'    thin=2)
#'
#' conf <- chechConvergence(out)
#' }


checkConvergence <- function(obj, criterion=1.1, quiet=FALSE){

  Rhats <- gelman.diag(out.coefs)
  if(!quiet){
    cat(paste0(paste(rep("-",4),collapse="")," Coefficient convergence:\n"))
    print(Rhats)
  }
  Rhats <- Rhats$psrf[,"Upper C.I."]
  if( any(Rhats > criterion) ){
    if(!quiet){
      cat("The following coefficients probably did not converge (Rhat > 1.1):\n")
      cat("Try increasing nburns and/or nthins or informing the coefficient's priors.\n")
      print(names(Rhats)[Rhats > criterion])
    }
    ans <- FALSE
  } else {
    if(!quiet){
      cat("The model converged. All Rhats < 1.1\n")
    }
    ans <- TRUE
  }

  ans <- list(converged=ans, Rhats=Rhats)

}
