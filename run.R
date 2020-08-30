
library(markmyassignment)
lab_path <- "https://raw.githubusercontent.com/STIMALiU/AdvRCourse/master/Labs/Tests/lab1.yml"
set_assignment(lab_path)

source_solution <- function(path, local) {
  # execute
  error_message <- warning_message <- NULL
  tryCatch({
    source(path, local = local)
  # warning handling
  }, warning = function(message) {
    warning_message <<- message
  # error handling
  }, error = function(message) {
    error_message <<- message
  }, finally = {
    # cleanup
  })
  
  list(
    error = error_message,
    warning = warning_message
  )
}

mark_solution <- function() {
  # execute
  res <- mark_my_assignment(quiet = T)
  
  # initialize output
  outf <- paste(liuid, ".txt", sep = "")
  sink(file = file.path("results",outf), type="output")
  # output
  print(res)
  # clean output
  sink()
}

run <- function() {
  dir.create("solutions", showWarnings = FALSE)
  dir.create("results", showWarnings = FALSE)
  # read all files
  solutions <- list.files(path = "solutions", pattern = ".*\\.R")
  for(f in solutions) {
    # prepare
    stopifnot(!('run_solution' %in% search()))
    x <- attach(what = NULL, name='run_solution') # attach new environment
    
    # source
    res <- source_solution(file.path("solutions", f), local = x)
    
    # error in code
    err <- F
    if(!is.null(res$error)) {
      print("error on source()")
      print(res$error$message)
      detach(name = 'run_solution', character.only = TRUE)
      next
    }
    if(!is.null(res$warning)) {
      print("warning on source()")
      print(res$error$warning)
    }
    # code ok, check liuid and name
    if(!('liuid' %in% ls('run_solution'))) {
      print("No LIU ID found!")
      detach(name = 'run_solution', character.only = TRUE)
      next
    }
    if(!('name' %in% ls('run_solution'))) {
      print("No name found!")
      detach(name = 'run_solution', character.only = TRUE)
      next
    }
    
    # execute
    result <- mark_solution()
    
    # clean
    detach(name = 'run_solution', character.only = TRUE)
    stopifnot(!('run_solution' %in% search()))
  }
}

run()

