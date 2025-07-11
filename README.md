# s3tools, a wrapper for common tasks utilizing s3 storage

## Overview

s3tools is an extension of functions provided by [Paws](https://github.com/paws-r/paws)

Disclaimer: s3tools is not a product of or supported by Amazon Web Services.

The functions require setting AWS credentials, in particular those passed into the environment via SSO with a specific IAM role. This access pattern is not always user friendly, and the motivation for this package was to make this seamless for users to authorize their session and perform common tasks such as listing or reading files without needing to understand the underlying AWS SDK or API structure.

## Credentials

`public` and `private` bucket access is supported, with examples in the [introduction](https://github.com/keckstrom/s3tools/blob/main/vignettes/introduction.Rmd)

In order to use credentials from SSO, users can login in via aws cli as described in the [documentation here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#sso-configure-profile-token-auto-sso)

**Example:**

Setup profile in \~/.aws/config

```         
[profile development]
sso_account_id = 123456
sso_role_name = common-usecase-pwrusr
region = us-west-2
output = json
#
sso_start_url = https://my-sso-portal.awsapps.com/start
sso_region = us-west-2
```

From the RStudio terminal

```         
aws sso login --profile development --no-browser
export AWS_PROFILE="development"
```

Then move on to the `fetch_paws_creds()` setting the profile to `development`
