appName <- Sys.getenv("DASH_APP_NAME")

if (appName != "") {
  pathPrefix <- sprintf("/%s/", appName)
  Sys.setenv(DASH_ROUTES_PATHNAME_PREFIX = pathPrefix,
             DASH_REQUESTS_PATHNAME_PREFIX = pathPrefix)
  setwd(sprintf("/app/apps/%s", appName))
}

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

PLOTLY_LOGO <- "https://images.plot.ly/logo/new-branding/plotly-logomark.png"

app <- Dash$new(name = "DashR NLP",
                external_stylesheets = "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
                )

navbar <- htmlDiv(
  children=htmlA( children = list(
        htmlDiv(className = "align-items-center no-gutters row", children = list (
          htmlDiv(className ="col", htmlImg(src=PLOTLY_LOGO, height="30px")),
          htmlDiv(className="col", htmlSpan("Bank Customer Complaints", className="ml-2 navbar-brand"))
       ))
      ),
      href="https://plot.ly"
    ),
  className="navbar navbar-expand-md navbar-dark bg-dark sticky-top"
)

sidebar <- htmlDiv(
  className = "col-md-4 jumbotron",
  children = list(
    htmlH4(children="Select bank & dataset size", className="display-5"),
    htmlHr(className="my-2"),
    htmlLabel("Select a bank", className="lead"),
    htmlP(
      "(You can use the dropdown or click the barchart on the right)",
       className="small-label"
    ),
    dccDropdown(
      id="bank-drop"
    ),
    htmlLabel("Select time frame", className="lead"),
    htmlDiv(dccRangeSlider(id="time-window-slider")),
    htmlP(
      "(You can define the time frame down to month granularity)",
       className="small-label"
    )
  )
)

top_banks_plot <- htmlDiv(className="col-md-8", children = (htmlDiv(className="card", children = list (
  htmlH5("Top 10 banks by number of complaints", className="card-header"),
  htmlDiv(className="card-body", children = list 
    (
      dccLoading(
        id="loading-banks-hist",
        children=list(dccGraph(id="bank-sample")),
        type="default",
      )
    )
  )
)
)))

  
app$layout(
  navbar,
  htmlDiv(
    className = 'mt-12 container',
    children = list(
      htmlDiv(className = "row top", children=
                list(
                  sidebar,
                  top_banks_plot
                ))
    )
  )
)

#if (appName != "") {
#  app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050)) 
#} else {
app$run_server(debug = TRUE)
#}
