###############################################
######## Tidyverse: Data Wrangling 101 ########
########    **Tidy data with tidyr**   ########
########_______________________________########

# - Wide vs long tables ----
# wide table example
billboard

# long table example
fish_encounters

# - pivot_longer() ----
colnames(billboard)
head(billboard)
?billboard

# data of 2 variables spread across all wk* columns
  # 1) all wk* columns can be condensed to 'week'
  # 2) all contents of wk* columns can be condensed to 'rank'
# => decrease number of variables, increase number of rows

# wide -> long #1
billboard %>%
  pivot_longer(
    cols = starts_with("wk"), # -c(artist, track, date.entered)
    names_to = "week",
    values_to = "rank"
  )

?pivot_longer

# wide -> long #2
billboard %>%
  pivot_longer(
    cols = starts_with("wk"), # or -c(artist, track, date.entered)
    names_to = "week",
    names_prefix = "wk",
    names_transform = list(week = as.integer),
    values_to = "rank",
    values_drop_na = TRUE,
  )

# - pivot_wider() ----
# => increase number of variables, decrease number of rows
# specific use cases (e.g. displaying in a table)

# create long table from billboard
billboard_long <- billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

# long -> wide #1
billboard_long %>%
  pivot_wider(
    names_from = "week",
    values_from = "rank"
  )

# more advanced pivot_longer()
billboard_long <- billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    names_transform = list(week = as.integer),
    values_to = "rank",
    values_drop_na = TRUE,
  )

# long -> wide #2
billboard_long %>%
  pivot_wider(
    names_from = "week",
    values_from = "rank",
    names_prefix = "wk",
    values_fill = NA
  )

# An additional note on pivoting ----
my_data <- tibble(
  plot = rep(c(LETTERS[1:3]), 2),
  num = seq_along(plot)
)

my_data

# pivot to wide: warning!
my_data %>%
  pivot_wider(
    names_from = plot,
    values_from = num
  )

# we need a column that uniquely identifies each row within each group
my_data %>%
  group_by(plot) %>%
  mutate(ID = row_number()) %>%
  ungroup()  %>%
  pivot_wider(
    names_from = plot,
    values_from = num,
  )

# - Exercises ----
# EXCERCISE 1: The `relig_income` dataset results from a survey.
#             1) Use ?relig_income to find out more about the dataset
#                Feel free to use head() and glimpse(), as well.
#             2) Pivot the dataset to a long format using reasonable column names.


# EXERCISE 2: The fish_encounters dataset is a long table that contains info
#             about fish swimming down a river, passing autonomous monitoring
#             stations.
#             1) Use ?fish_encounters to learn more about the data.
#                Feel free to use head() and glimpse(), as well.
#             2) Pivot the dataset to a wide format with each station as a column.
#             3) Summarize all columns to a single row containing the column sums.


