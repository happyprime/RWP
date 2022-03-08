# RWP

## Installation

```
library("devtools")
install_github("happyprime/RWP")
library("RWP")
```

## Development

```
install.packages("devtools")
install.packages("roxygen2")
library("devtools")
library("roxygen2")
install_local("./")
library("lintr")
document();
lintr("R/update_post.R")
lintr("R/set_rest_credentials.R")
```


`brew install libgit2`

## Unique Functions

### set_rest_credentials( site_url, site_user, site_password )

### update_post( file, post_title, post_id = 0, post_status = "publish" )

## History

This was originally a fork of [Duncan Temple Lang's RWordPress package](https://github.com/duncantl/RWordPress) for R, which uses XML-RPC to publish content. Once I established that I could pretty quickly switch to the REST API, I removed all of the original code. The version control history still contains this code as it very much inspired the creation of this project.
