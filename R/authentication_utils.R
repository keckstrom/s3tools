#' Credentials for Jira API
#'
#' @param type public or private type of access, if private provide profile name. 
#' @param aws_profile name of profile to use from ~/.aws/config
#' @param region region of the s3 bucket, defaults to us-west-2
#'
#' @importFrom paws s3
#'
#' @return credentials required for access to s3 resources based on the supplied aws profile, ex. janus or customized profile
#'
#' @export
#'

fetch_paws_creds <- function(type="",aws_profile="", region=""){
  if(type == "public") {
    s3_init = paws::s3(list(credentials = list(anonymous = T), region = "us-west-2"))
  } else if(type == "private") {
    Sys.setenv(AWS_PROFILE=aws_profile)
    s3_init <- paws::s3()
  } else {
    print("Type of access needs to be provided, either public or private.")
  }
  
  return(s3_init)
}

