#' Check if files are in s3 or on prem, used within other functions
#'
#' @param char_vec_files list of file locations
#'
#' @return set logic for rest of function, if s3 or local loading should be used
#'
#' @export


location_check <- function(char_vec_files) {
  if(any(stringr::str_detect(char_vec_files, "s3://"))) {
    in_s3 <- TRUE
  } else {
    in_s3 <- FALSE
  }
  return(in_s3)
}
