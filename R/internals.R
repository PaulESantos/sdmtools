###
#' @keywords internal
unload_dll <- function(package) {
  # Always run garbage collector to force any deleted external pointers to
  # finalise
  gc()

  # Special case for devtools - don't unload DLL because we need to be able
  # to access nsreg() in the DLL in order to run makeNamespace. This means
  # that changes to compiled code in devtools can't be reloaded with
  # load_all -- it requires a reinstallation.
  if (package == "pkgload") {
    return(invisible())
  }

  ###
  loaded_dlls <- function(package) {
    libs <- .dynLibs()
    matchidx <- vapply(libs, "[[", character(1), "name") == package
    libs[matchidx]
  }
  ###
  pkglibs <- loaded_dlls(package)

  for (lib in pkglibs) {
    dyn.unload(lib[["path"]])
  }

  # Remove the unloaded dlls from .dynLibs()
  libs <- .dynLibs()
  .dynLibs(libs[!(libs %in% pkglibs)])

  invisible()
}


###

.onUnload <- function (libpath) {
# unload_dll("sdmtools")
 unload_dll("sdmtools")

# library.dynam.unload( 'sdmtools', libpath )

}

#' @keywords internal
"_PACKAGE"


#' @useDynLib SDMTools, .registration = TRUE
NULL

SDMTools_env <- new.env(parent = emptyenv())


# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
