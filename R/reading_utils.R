
#' Read a non-serialized file from s3 with a specified function
#'
#' @param bucket_name name of the bucket without s3://,
#' @param object_key key for object to be read
#' @param read_function function to use for reading, ex read.delim
#' @param s3_init output of paws::s3() to use for credentials
#' @param read_args optional, additional arguments used by the read_function if needed
#'
#' @importFrom magrittr %>%
#'
#' @return object in format of the function used
#'
#' @export

paws_readusing <- function(bucket_name, object_key, read_function, s3_init, read_args = list()) {
  s3_download <- s3_init$get_object(Bucket = bucket_name, Key = object_key)
  # Check if the file is gzip-compressed based on its extension
  compressed <- grepl("\\.gz$", object_key, ignore.case = TRUE)
  
  if (compressed) {
    # Generate temporary directory and file
    tmp_dir <- fs::file_temp() |> fs::dir_create()
    local_file_path <- file.path(tmp_dir, basename(object_key))
    
    # Download file
    s3_cli$download_file(Bucket = bucket_name, Key = object_key, Filename = local_file_path)
    
    # Pass additional arguments to the read_function
    obj <- do.call(read_function, c(list(local_file_path), read_args))
  } else {
    obj <- s3_download$Body %>% 
      rawToChar %>% 
      {tmp <- tempfile(); writeLines(., tmp); do.call(read_function, c(list(tmp), read_args))}
  }
  
  return(obj)
}


#' Read a serialized file (.rds) from s3
#'
#' @param bucket_name name of the bucket without s3://
#' @param object_key key for object to be read
#' @param s3_init output of paws::s3() to use for credentials
#'
#' @return object in format of the function used
#'
#' @export

paws_readRDS <- function(bucket_name,object_key,s3_init) {
  s3_download <- s3_init$get_object(Bucket=bucket_name,Key=object_key)
  obj <- s3_init$get_object(Bucket=bucket_name,Key=object_key)$Body %>% rawConnection() %>% gzcon %>% readRDS
  return(obj)
}
