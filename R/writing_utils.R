#' Write object to s3 using a specific function
#'
#' @param object R object to be saved
#' @param bucket_name name of the bucket without s3://
#' @param object_key function to use for writing, ex saveRDS or write.csv
#' @param write_function location of inputs for the batch
#' @param write_args optionsl, list of args to pass to the write_function ex row.names=F
#' @param s3_init output of paws::s3() to use for credentials
#'
#' @return Message of these locations match, prevents improper runs
#'
#' @export

#
paws_writeusing <- function(object, bucket_name, object_key, write_function, write_args = list(),s3_init) {
  # Create a temporary file
  temp_file <- tempfile()

  # Write the object to the temporary file using the specified write function
  do.call(write_function, c(list(object, temp_file), write_args))

  # Upload the file to the specified S3 bucket
  s3_init$put_object(
    Bucket = bucket_name,
    Key = object_key,
    Body = temp_file
  )

  # Remove the temporary file
  unlink(temp_file)

  cat("Object successfully saved to S3 bucket:", bucket_name, "with key:", object_key, "\n")
}
