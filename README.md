
# homebrewanalytics

Access ‘Homebrew’ Formluae Analytics Data

## Description

The ‘Homebrew Project’ \<brew.sh\> has a myriad of “recipes” that make
life easier for ‘macOS’ users by enabling them to (mostly) effortlessly
install popular open source libraries, tools, utilities and
applications. The project collectes anonymous metrics from users who
have not opted-out of metrics collection and makes them available via a
‘JSON’ ‘API’.

## What’s Inside The Tin

The following functions are implemented:

  - `brew_build_error_events`: Retrieve Build Errors for the past 30
    days for Homebrew Formulae
  - `brew_install_events`: Retrieve Install Events for Homebrew Formulae
  - `brew_install_on_request_events`: Retrieve Install-on-Requests nts
    for Homebrew Formulae

## Installation

``` r
devtools::install_git("git://gitlab.com/hrbrmstr/homebrewanalytics")
# or
devtools::install_github("hrbrmstr/homebrewanalytics")
```

## Usage

``` r
library(homebrewanalytics)
library(tidyverse)

# current verison
packageVersion("homebrewanalytics")
## [1] '0.1.0'
```

### Install Events

You can get formlua install events for the past 30, 90 or 365 days

``` r
xdf <- brew_install_events(30)

arrange(xdf, desc(count))
## # A tibble: 10,000 x 3
##    formula  opts   count
##    <chr>    <chr>  <dbl>
##  1 openssl  <NA>  478726
##  2 readline <NA>  444381
##  3 gdbm     <NA>  399460
##  4 node     <NA>  320347
##  5 sqlite   <NA>  284261
##  6 python   <NA>  257600
##  7 icu4c    <NA>  240252
##  8 python@2 <NA>  211878
##  9 libpng   <NA>  195502
## 10 xz       <NA>  192186
## # ... with 9,990 more rows

attr(xdf, "meta")
## $category
## [1] "install"
## 
## $start_date
## [1] "2018-07-09"
## 
## $end_date
## [1] "2018-08-08"
```

### Install On Request Events

You can get formlua install-on-request events for the past 30, 90 or 365
days

``` r
xdf <- brew_install_on_request_events(30)

arrange(xdf, desc(count))
## # A tibble: 10,000 x 3
##    formula     opts   count
##    <chr>       <chr>  <dbl>
##  1 node        <NA>  234176
##  2 python      <NA>  171875
##  3 yarn        <NA>   93479
##  4 git         <NA>   84820
##  5 mysql       <NA>   83219
##  6 wget        <NA>   81700
##  7 cmake       <NA>   68105
##  8 openssl     <NA>   67231
##  9 imagemagick <NA>   64171
## 10 coreutils   <NA>   59860
## # ... with 9,990 more rows

attr(xdf, "meta")
## $category
## [1] "install_on_request"
## 
## $start_date
## [1] "2018-07-09"
## 
## $end_date
## [1] "2018-08-08"
```

### Build Error Events Events

You can get formlua build error events for the past 30

``` r
xdf <- brew_build_error_events()

arrange(xdf, desc(count))
## # A tibble: 1,704 x 2
##    build_recipe                      count
##    <chr>                             <dbl>
##  1 openssl                            5017
##  2 ios-webkit-debug-proxy --HEAD      2455
##  3 libimobiledevice --HEAD            1358
##  4 gcc                                 910
##  5 macvim --with-override-system-vim   849
##  6 pkg-config                          684
##  7 mysql                               674
##  8 telnet                              593
##  9 python@2                            566
## 10 python                              560
## # ... with 1,694 more rows

attr(xdf, "meta")
## $category
## [1] "BuildError"
## 
## $start_date
## [1] "2018-07-09"
## 
## $end_date
## [1] "2018-08-08"
```
