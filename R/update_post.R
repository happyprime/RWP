#' @title update_post
#'
#' @description Renders an R Markdown document into an HTML fragment and
#' publishes the HTML as a post in WordPress using the WordPress REST API.
#'
#' @param file The path and file name of an R Markdown document.
#' @param post_title The title that should be used for the post.
#' @param post_id A post ID to update with the HTML content.
#' @param post_status The WordPress post status to assign. Default "publish".
#' @param output Whether to output post ID/link or return a response object.
#'
#' @return No return by default. Response from httr::POST request if specified.
#' @examples
#' update_post(file = 'current_file.Rmd', post_title = 'My post title')
#' @export
#' @importFrom rmarkdown render
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom httr content
#' @importFrom httr verbose
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @importFrom xfun file_string
update_post <- function(
    file,
    post_title,
    post_id = 0,
    post_status = "publish",
    output = TRUE
) {
    html_content <- render(
        file,
        output_format = "html_fragment"
    )

    rest_post_url <- getOption(
        "RESTPostURL",
        stop("Set a site URL with set_rest_credentials")
    )

    # If a post ID is specified, we'll assume this is an update and append
    # the value to the REST URL.
    if (post_id > 0) {
        rest_post_url <- glue("{rest_post_url}/{post_id}")
    }

    body <- list(
        title = post_title,
        content = file_string(html_content),
        status = post_status,
        meta = list(rwp_generated = TRUE)
    )

    auth_key <- getOption(
        "RESTAuthHeader",
        stop("Set an authentication header with set_REST_credentials")
    )

    response <- POST(
        rest_post_url,
        body = body,
        encode = "json",
        add_headers(
            Authorization = glue("Basic {auth_key}")
        )
    )

    # It was feeling like content() was taking quite a while to generate JSON
    # data from the response and using jsonlite _felt_ better.
    text_response <- content(response, as = "text")
    json_response <- fromJSON(text_response)

    # For large documents, this content property gets very heavy as there are
    # rendered and raw versions included. By nulling it out, we can clear a
    # bit of memory, I think.
    json_response$content <- NULL

    if (output == TRUE) {
        cat(
            glue("Post ID: {json_response$id}"),
            glue("Link: {json_response$link}"),
            sep = "\n"
        )
    } else {
        return(json_response)
    }
}
