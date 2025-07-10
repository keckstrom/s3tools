#' List files in a given bucket + prefix that matches a specific pattern, with pagination + option to specify max keys searched
#'
#' @param bucket_name name of the bucket without s3:// 
#' @param file_pattern name of the bucket without s3://
#' @param prefix prefix path to search, ex studyid/ngs/outdata
#' @param s3_init output of fetch_paws_creds or paws::s3() to use for credentials
#' @param max_keys numeric, number of keys to pass to MaxKeys in list_objects_v2. Default = 1000
#'
#' @importFrom stringr str_detect
#' @importFrom paws paginate
#'
#' @return set logic for rest of function, if s3 or local loading should be used
#'
#' @export


list_s3_files <- function(bucket_name, file_pattern, prefix = "", s3_init, max_keys = 1000) {
  # Initialize an empty vector to store matching file names
  matching_files <- c()

  # Use paginate to handle pagination automatically
  paginator <- paginate(s3_init$list_objects_v2(Bucket = bucket_name, Prefix = prefix,MaxKeys = max_keys))

  # Process each page returned by the paginator
  for (response in paginator) {
    if (!is.null(response$Contents)) {
      # Loop through the contents and match the file pattern
      for (object in response$Contents) {
        file_name <- object$Key
        if (str_detect(file_name, file_pattern)) {
          matching_files <- c(matching_files, file_name)
        }
      }
    }
  }

  if (length(matching_files) == 0) {
    message("No objects found in the bucket with the specified prefix and pattern.")
  }

  return(matching_files)
}
