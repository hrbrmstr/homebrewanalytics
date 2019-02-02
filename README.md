
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

For formulae info:

  - `brew_formulae`: Retrieve formulae metadata for all homebrew-core
    formulae

For info on “events”:

  - `brew_analytics_events`: Retrieve Analytics Events for Homebrew
    Formulae for a Given Category

These are just convenience and legacy API support wrappers for
`brew_analytics_events()`

  - `brew_build_error_events`: Retrieve Analytics Events for Homebrew
    Formulae for a build-error events
  - `brew_cask_install_events`: Retrieve Analytics Events for Homebrew
    Formulae for a cask-install events
  - `brew_install_events`: Retrieve Analytics Events for Homebrew
    Formulae for a install events
  - `brew_install_on_request_events`: Retrieve Analytics Events for
    Homebrew Formulae for install-on-request events
  - `brew_os_version_events`: Retrieve Analytics Events for Homebrew
    Formulae for a OS
events

## Installation

``` r
devtools::install_git("https://git.sr.ht/~hrbrmstr/homebrewanalytics")
# or
devtools::install_gitlab("hrbrmstr/homebrewanalytics")
# or
devtools::install_github("hrbrmstr/homebrewanalytics")
```

## Usage

``` r
library(homebrewanalytics)
library(tibble) # for printing

# current verison
packageVersion("homebrewanalytics")
## [1] '0.2.0'
```

### Formulae info

All:

``` r
brew_formulae()
## # A tibble: 4,694 x 24
##    name  full_name oldname aliases versioned_formu… desc  homepage versions$stable $devel $head $bottle revision
##  * <chr> <chr>     <chr>   <list>  <list>           <chr> <chr>    <chr>           <lgl>  <chr> <lgl>      <int>
##  1 a2ps  a2ps      <NA>    <chr [… <chr [0]>        Any-… https:/… 4.14            NA     <NA>  TRUE           0
##  2 a52d… a52dec    <NA>    <chr [… <chr [0]>        Libr… https:/… 0.7.4           NA     <NA>  TRUE           0
##  3 aacg… aacgain   <NA>    <chr [… <chr [0]>        AAC-… https:/… 1.8             NA     <NA>  TRUE           0
##  4 aalib aalib     <NA>    <chr [… <chr [0]>        Port… https:/… 1.4rc5          NA     <NA>  TRUE           1
##  5 aama… aamath    <NA>    <chr [… <chr [0]>        Rend… http://… 0.3             NA     <NA>  TRUE           0
##  6 aap   aap       <NA>    <chr [… <chr [0]>        Make… http://… 1.094           NA     <NA>  TRUE           0
##  7 aard… aardvark… <NA>    <chr [… <chr [0]>        Util… http://… 1.0             NA     <NA>  TRUE           0
##  8 abcde abcde     <NA>    <chr [… <chr [0]>        Bett… https:/… 2.9.2           NA     HEAD  TRUE           1
##  9 abcl  abcl      <NA>    <chr [… <chr [0]>        Arme… https:/… 1.5.0           NA     HEAD  TRUE           1
## 10 abcm… abcm2ps   <NA>    <chr [… <chr [0]>        ABC … http://… 8.14.2          NA     <NA>  TRUE           0
## # … with 4,684 more rows, and 30 more variables: version_scheme <int>, bottle$stable$rebuild <int>, $$cellar <chr>,
## #   $$prefix <chr>, $$root_url <chr>, $$files$mojave$url <chr>, $$$$sha256 <chr>, $$$high_sierra$url <chr>,
## #   $$$$sha256 <chr>, $$$sierra$url <chr>, $$$$sha256 <chr>, $$$el_capitan$url <chr>, $$$$sha256 <chr>,
## #   $$$yosemite$url <chr>, $$$$sha256 <chr>, $$$mavericks$url <chr>, $$$$sha256 <chr>, keg_only <lgl>, options <list>,
## #   build_dependencies <list>, dependencies <list>, recommended_dependencies <list>, optional_dependencies <list>,
## #   requirements <list>, conflicts_with <list>, caveats <chr>, installed <list>, linked_keg <lgl>, pinned <lgl>,
## #   outdated <lgl>
```

One:

``` r
brew_formulae("curl")
## # A tibble: 1 x 25
##   name  full_name oldname aliases versioned_formu… desc  homepage versions revision version_scheme bottle keg_only
##   <chr> <chr>     <I(lis> <I(lis> <I(list)>        <chr> <chr>    <I(list>    <int>          <int> <I(li> <lgl>   
## 1 curl  curl      <NULL>  <list … <list [0]>       Get … https:/… <list […        0              0 <list… FALSE   
## # … with 13 more variables: options <I(list)>, build_dependencies <chr>, dependencies <I(list)>,
## #   recommended_dependencies <I(list)>, optional_dependencies <I(list)>, requirements <I(list)>,
## #   conflicts_with <I(list)>, caveats <I(list)>, installed <I(list)>, linked_keg <I(list)>, pinned <lgl>,
## #   outdated <lgl>, analytics <I(list)>
```

Two:

``` r
brew_formulae(c("curl", "wget"))
## # A tibble: 2 x 25
##   name  full_name oldname aliases versioned_formu… desc  homepage versions revision version_scheme bottle keg_only
##   <chr> <chr>     <I(lis> <I(lis> <I(list)>        <chr> <chr>    <I(list>    <int>          <int> <I(li> <lgl>   
## 1 curl  curl      <NULL>  <list … <list [0]>       Get … https:/… <list […        0              0 <list… FALSE   
## 2 wget  wget      <NULL>  <list … <list [0]>       Inte… https:/… <list […        3              0 <list… FALSE   
## # … with 13 more variables: options <I(list)>, build_dependencies <chr>, dependencies <I(list)>,
## #   recommended_dependencies <I(list)>, optional_dependencies <I(list)>, requirements <I(list)>,
## #   conflicts_with <I(list)>, caveats <I(list)>, installed <I(list)>, linked_keg <I(list)>, pinned <lgl>,
## #   outdated <lgl>, analytics <I(list)>
```

Errant name but still retrieves the rest:

``` r
brew_formulae(c("curl", "wget", "doesnotexist"))
## # A tibble: 2 x 25
##   name  full_name oldname aliases versioned_formu… desc  homepage versions revision version_scheme bottle keg_only
##   <chr> <chr>     <I(lis> <I(lis> <I(list)>        <chr> <chr>    <I(list>    <int>          <int> <I(li> <lgl>   
## 1 curl  curl      <NULL>  <list … <list [0]>       Get … https:/… <list […        0              0 <list… FALSE   
## 2 wget  wget      <NULL>  <list … <list [0]>       Inte… https:/… <list […        3              0 <list… FALSE   
## # … with 13 more variables: options <I(list)>, build_dependencies <chr>, dependencies <I(list)>,
## #   recommended_dependencies <I(list)>, optional_dependencies <I(list)>, requirements <I(list)>,
## #   conflicts_with <I(list)>, caveats <I(list)>, installed <I(list)>, linked_keg <I(list)>, pinned <lgl>,
## #   outdated <lgl>, analytics <I(list)>
```

### Analytic Events

Retrieve formlua install events for the past 30, 90 or 365 days. We’ll
juse use the default:

``` r
brew_install_events()
## # A tibble: 10,000 x 9
##    number formula   count percent category start_date end_date   total_items total_count
##  *  <int> <chr>     <dbl>   <dbl> <chr>    <date>     <date>           <int>       <int>
##  1      1 readline 502756  0.0306 install  2019-01-03 2019-02-02       14585    16417871
##  2      2 openssl  495728  0.0302 install  2019-01-03 2019-02-02       14585    16417871
##  3      3 python   478566  0.0291 install  2019-01-03 2019-02-02       14585    16417871
##  4      4 sqlite   478056  0.0291 install  2019-01-03 2019-02-02       14585    16417871
##  5      5 node     347418  0.0212 install  2019-01-03 2019-02-02       14585    16417871
##  6      6 icu4c    296464  0.0181 install  2019-01-03 2019-02-02       14585    16417871
##  7      7 gdbm     289269  0.0176 install  2019-01-03 2019-02-02       14585    16417871
##  8      8 xz       234537  0.0143 install  2019-01-03 2019-02-02       14585    16417871
##  9      9 libpng   219181  0.0134 install  2019-01-03 2019-02-02       14585    16417871
## 10     10 glib     196391  0.012  install  2019-01-03 2019-02-02       14585    16417871
## # … with 9,990 more rows
```

### Install On Request Events

Retrieve formlua install-on-request events for the past 30, 90 or 365
days

``` r
brew_install_on_request_events()
## # A tibble: 10,000 x 9
##    number formula      count percent category           start_date end_date   total_items total_count
##  *  <int> <chr>        <dbl>   <dbl> <chr>              <date>     <date>           <int>       <int>
##  1      1 python      264769  0.0451 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  2      2 node        260559  0.0444 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  3      3 wget        166510  0.0284 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  4      4 git         119313  0.0203 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  5      5 yarn        114583  0.0195 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  6      6 youtube-dl   87835  0.015  install_on_request 2019-01-03 2019-02-02       13747     5872029
##  7      7 imagemagick  83740  0.0143 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  8      8 vim          78656  0.0134 install_on_request 2019-01-03 2019-02-02       13747     5872029
##  9      9 cmake        75337  0.0128 install_on_request 2019-01-03 2019-02-02       13747     5872029
## 10     10 postgresql   74322  0.0127 install_on_request 2019-01-03 2019-02-02       13747     5872029
## # … with 9,990 more rows
```

### Build Error Events Events

Retrieve formlua build error events for the past 30

``` r
brew_build_error_events()
## # A tibble: 2,476 x 9
##    number formula              count percent category   start_date end_date   total_items total_count
##  *  <int> <chr>                <dbl>   <dbl> <chr>      <date>     <date>           <int>       <int>
##  1      1 libimobiledevice     22705  0.341  BuildError 2019-01-03 2019-02-02        2476       66646
##  2      2 qt                    3846  0.0577 BuildError 2019-01-03 2019-02-02        2476       66646
##  3      3 node                  1699  0.0255 BuildError 2019-01-03 2019-02-02        2476       66646
##  4      4 go                    1540  0.0231 BuildError 2019-01-03 2019-02-02        2476       66646
##  5      5 graphite2             1526  0.0229 BuildError 2019-01-03 2019-02-02        2476       66646
##  6      6 valgrind              1515  0.0227 BuildError 2019-01-03 2019-02-02        2476       66646
##  7      7 usbmuxd               1296  0.0194 BuildError 2019-01-03 2019-02-02        2476       66646
##  8      8 python                1224  0.0184 BuildError 2019-01-03 2019-02-02        2476       66646
##  9      9 openssl               1217  0.0183 BuildError 2019-01-03 2019-02-02        2476       66646
## 10     10 facebook/fb/fbsimctl  1036  0.0155 BuildError 2019-01-03 2019-02-02        2476       66646
## # … with 2,466 more rows
```

``` r
cloc::cloc_pkg_md()
```

| Lang | \# Files |  (%) | LoC | (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | --: | ----------: | ---: | -------: | ---: |
| R    |        6 | 0.86 | 143 | 0.9 |          49 | 0.56 |       84 | 0.58 |
| Rmd  |        1 | 0.14 |  16 | 0.1 |          39 | 0.44 |       61 | 0.42 |

## Code of Conduct

Please note that the ‘homebrewanalytics’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
