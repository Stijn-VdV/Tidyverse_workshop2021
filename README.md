# Tidyverse workshop 2021
## Target audience
This course is targeted at Master’s and Ph.D. students with a basic understanding of the R programming language, but want to manipulate (large) datasets with more ease than using spreadsheet software. In other words, being comfortable with basic R operations is a required.

Please make sure you can answer the following questions without much of a hassle:
* What does the `<-` operator do?
* How to create a vector with the values `"this"`, `"is"`, `"a"`, `"vector"`?
* How to access R’s built-in help files (also referred to as “R documentation”) for the function `shapiro.test`?
* How to install and load a new package into your R session?
* Why *doesn’t* the following piece of code work (run code in an R session to check):
```r
   foobar <- data.frame(x = 1:10, y = rnorm(10, 5, 1))
   plot(FOOBAR)
```

In case you had trouble with any of these questions, please take some time to get comfortable with some R basics. As we have a lot of ground to cover, it would be unwise to jump in unprepared! I strongly recommend the `swirl` package, which interactively introduces you to R (see [swirl’s website](https://swirlstats.com/students.html) for more information). To get started with `swirl` right away, install the package using `install.packages("swirl")`, load it into your session with `library(swirl)` and jump-start your journey with `swirl()`. Going through the first chapter (`1: Basic Building Blocks`) should suffice, but don’t let that stop you from learning moRe!

## Preparations
Please go through all of the steps below before attending the workshop!!

Make sure to have at least `R version 4.1.0` installed on your computer. Additionally, I strongly recommend installing RStudio, as I will be using this as my Integrated Development Environment (IDE) throughout this course.

Installing R: https://www.r-project.org/
Installing RStudio: https://www.rstudio.com/products/rstudio/download/#download
Finally, install tidyverse using `install.packages("tidyverse")`.
