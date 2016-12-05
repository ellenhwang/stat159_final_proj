library(testthat)

source("../functions/functions.R")

context("testing data cleaning functions")

test_that("replacing NULL strings works as expected", {
  
  L3 <- LETTERS[1:3]
  L6 <- LETTERS[4:6]
  test_df <- data.frame(1, 1:10, sample(L3, 10, replace = TRUE), sample(L6, 10, replace = TRUE), stringsAsFactors=F)
  names(test_df) <- c("L1", "L2", "Char1", "Char2")
  test_df$Char1[4] <- "NULL"
  test_df$Char2[7] <- "NULL"
  test_df$Char1[8] <- "PrivacySuppressed"
  test_df$Char2[2] <- "PrivacySuppressed"
  null_removed <- remove_null_and_privsup(test_df)
  expect_false(is.na(test_df$Char2[7]))
  expect_true(is.na(null_removed$Char2[7]))
  expect_false(is.na(test_df$Char2[2]))
  expect_true(is.na(null_removed$Char2[2]))
  
})



test_that("Checking row null-count works as expected", {
  
  L3 <- LETTERS[1:3]
  L6 <- LETTERS[4:6]
  test_df <- data.frame(1, 1:10, sample(L3, 10, replace = TRUE), sample(L6, 10, replace = TRUE), stringsAsFactors=F)
  names(test_df) <- c("L1", "L2", "Char1", "Char2")
  test_df$L2[2] <- NA
  test_df$L2[4] <- NA
  test_df$L2[6] <- NA
  test_df$L2[8] <- NA
  test_df$L2[10] <- NA
  
  test_df$Char1[2] <- NA
  test_df$Char1[4] <- NA
  test_df$Char1[6] <- NA
  test_df$Char1[8] <- NA
  
  test_df$Char2[3] <- NA
  test_df$Char2[6] <- NA
  test_df$Char2[9] <- NA
  
  expect_true(keep_row(test_df$L1))
  expect_false(keep_row(test_df$L2))
  expect_false(keep_row(test_df$Char1))
  expect_true(keep_row(test_df$Char2))

  
})
test_that("Replacing NAs with averages works as expected", {
  
  c3 <- c(1:3)
  c6 <- c(4:3)
  test_df <- data.frame(1, 1:10, sample(c3, 10, replace = TRUE), sample(c6, 10, replace = TRUE), stringsAsFactors=F)
  names(test_df) <- c("L1", "L2", "num1", "num2")
  test_df$num1[4] <- NA
  test_df$num2[2] <- NA
  
  col1sum <- mean(test_df$num1, na.rm=T)
  col2sum <- mean(test_df$num2, na.rm=T)
  
  expect_true(is.na(sum(test_df[2,])))
  expect_false(is.na(sum(test_df[3,])))
  expect_true(is.na(sum(test_df[4,])))
  
  col_avgs <- c(1, 5.5, col1sum, col2sum)
  
  
  expect_true(is.na(mean(test_df$num1)))
  expect_true(is.na(mean(test_df$num2)))
  expect_false(is.na(col1sum))
  expect_false(is.na(col2sum))
  
  col_avgs <- c(1, 5.5, col1sum, col2sum)
  
  replace_nas <- function(row) {
    row[is.na(row)] <- col_avgs[is.na(row)]
    row
  }
  
  test_df[2,] <- replace_nas(test_df[2,])
  test_df[3,] <- replace_nas(test_df[3,])
  test_df[4,] <- replace_nas(test_df[4,])
  
  expect_false(is.na(sum(test_df[2,])))
  expect_false(is.na(sum(test_df[3,])))
  expect_false(is.na(sum(test_df[4,])))
  
  expect_equal(test_df[4,3], col1sum)
  expect_equal(test_df[2,4], col2sum)
  
})
