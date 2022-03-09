# RWP

## Installation

```
library("devtools")
install_github("happyprime/RWP")
library("RWP")
```

Note: the `devtools` package is only required so that `install_github()` is available. This requirement will drop once this package is officially published.

## Usage

RWP provides two functions: `set_rest_credentials` and `update_post`.

### Set REST credentials

Use `set_rest_credentials` to store the site URL, username, and application password you'll use to publish content through WordPress.

```
set_rest_credentials( 'https://example.com', 'rwpuser', 'a1b2 Cdef GHi8 jKlm nOPQ VWX9' )
```

[Application passwords in WordPress](https://make.wordpress.org/core/2020/11/05/application-passwords-integration-guide/) allow you to provide and revoke access to applications without sharing your actual user password.

1. Navigate to the WordPress dashboard (`/wp-admin/`).
2. Navigate to **Users** -> **Profile**.
3. Scroll to the **Application Passwords** section of your profile.
4. Enter a **New Application Password Name** (e.g. "RWP").
5. Click **Add New Application Password**.
6. Copy the generated application password, which should be formatted like `a1b2 Cdef GHi8 jKlm nOPQ VWX9`.
7. Store the application password in a password manager and enter with `set_rest_credentials`.

### Update post

Use `update_post` to publish R Markdown documents in WordPress and to update existing R Markdown posts.

By default, `update_post` will create a post on your site and set the post status to "publish" so that it is publicly viewable.

```
update_post( 'filename.Rmd', 'The post title' )
```

The post status can be adjusted to "draft" or "private" by adding the `post_status` parameter.

```
update_post( 'filename.Rmd', 'The post title', post_status = 'draft )
```

When the post has been saved successfully, the console will output a **Post ID** and **Link** at which the new post is avaialble.

```
Post ID: 49995
Link: https://example.com/the-post-title/
```

To edit an existing post, add the `post_id` parameter.

```
update_post( 'filename.Rmd', 'The post title', post_id = 49995, post_status = 'draft' )
```

### Companion WordPress plugin

An [RWP Companion](https://github.com/happyprime/rwp-companion) plugin is available that adds additional support for R Markdown documents on your WordPress site. It is currently in development and backward compatibility is not yet guaranteed.

## Development

A few libraries are required to aid with development of this package.

```
install.packages("devtools")
install.packages("roxygen2")
install.packages("lintr")

library("devtools")
library("roxygen2")
library("lintr")

install_local("./")
library("RWP")

document()
lint("R/update_post.R")
lint("R/set_rest_credentials.R")
```

### Caveats

* I had a weird issue in Mac OS Monterey and had to `brew install libgit2` before `devtools` (specifically `usethis`) would install.

### Local testing

```
unload( "RWP" )
install_local( "./" )
library( "RWP" )
```

## History

This was originally a fork of [Duncan Temple Lang's RWordPress package](https://github.com/duncantl/RWordPress) for R, which uses XML-RPC to publish content. Once I established that I could pretty quickly switch to the REST API, I removed all of the original code. The version control history still contains this code as it very much inspired the creation of this project.
