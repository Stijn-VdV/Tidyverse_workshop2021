###############################################
######## Tidyverse: Data Wrangling 101 ########
########    **Exercises: solutions**   ########
########_______________________________########

# - 1 - Introduction to tidyverse ----
# EXERCISE 1: Rewrite the following lines of code using %>%
round(pi, 2)
sum(1, 5, 20)
as_tibble(mtcars)


pi %>% round(2)
2 %>% round(pi, .)

1 %>% sum(5) %>% sum(20)
1 %>% sum(5, 20)

mtcars %>% as_tibble
mtcars %>% as_tibble()


# EXERCISE 2: The following block of code is difficult to read because of multiple
#             layers of nesting. Improve the readability of the code using %>%.
storms_clean <- summarize(
  group_by(
    filter(storms, name == "Sandy"), day),
  average_wind = mean(wind),
  sd_wind = sd(wind))

storms_clean <- storms %>%
  filter(name == "Sandy") %>%
  group_by(day) %>%
  summarize(
    average_wind = mean(wind),
    sd_wind = sd(wind)
  )

# EXERCISE 3: Do the following datasets follow the rules of 'tidy data'?
#             Why (not)?
as_tibble(mtcars)
mtcars
relig_income
billboard

# mtcars
# YES, but ...
# YES: Each column is a variable, and each row an observation
# but: Car names found in row names --> need to be moved to actual column
#      Try running as_tibble(mtcars), and find the car names

# relig_income
# NO
# religion, stored in the rows,
# BUT income spread across the column names, and count stored in the cell values.

# billboard
# NO
# artist, track and date.entered correctly stored in separate variable and rows
# BUT weeks spread across the column names, and rank stored in the cell values

# - 2 - Data manipulation with dplyr pt. 1 ----
# EXERCISE 1: Use the 'starwars' dataset to:
#             1) Select all character columns, along with height
#             2) Find all characters that are:
#                   - taller than 150 cm and a maximum height of 210 cm
#                   - have blond or no hair colour ("none")
#                   - are of the Human species
#                   - not born on planets Bespin, Coruscant or Haruun Kal

starwars %>%
  select(height, where(is.character)) %>%
  filter(height > 150, height <= 210,
         hair_color == "blond" | hair_color == "none",
         species == "Human",
         !homeworld %in% c("Bespin", "Coruscant", "Haruun Kal")
  )

# EXERCISE 2: Use the `starwars` dataset to calculate the average and stdev of
#             weight per sex.
#             HINT 1: average -> mean()
#             HINT 2: standard deviation -> sd()
#             HINT 3: na.rm = TRUE!

starwars %>%
  # select(name:species) %>%
  group_by(sex) %>%
  summarize(
    avg_weight = mean(mass, na.rm = TRUE),
    sd_weight = sd(mass, na.rm = TRUE)
  )

# EXERCISE 3: Using the `starwars` dataset, figure out a way to:
#             1) Count the number of individuals that identify with each gender
#                in the dataset.
#             2) Figure out which characters have a missing (NA) gender
#             HINT: This exercise can be broken up in two separate code blocks.
starwars %>%
  count(gender)

starwars %>%
  filter(is.na(gender))


# EXERCISE 4: ADVANCED
#             Using the `storms` dataset (?storms):
#             1) Find the maximum windspeed for each storm
#             2) Make sure you have only 1 row for each storm
#             3) Arrange all storms by wind speed, in descending order
#             4) Filter to keep only storms since the year 2000, and
#                a Safirr-Simpson storm category of at least 4
#             5) Modify the `name` column to contain
#                "Hurrican *name of storm*", e.g. "Hurricane Alberto"
#                 HINT: use paste() (`?paste()`)
#             6) Keep only the columns: name, year, month, day, category and wind
#             You can start with the code provided below

storms %>%
  filter(!str_detect(name, "AL|Al2")) %>%
  group_by(name) %>%
  slice_max(wind) %>%
  slice_head(n = 1) %>%
  arrange(desc(wind)) %>%
  ungroup() %>%
  filter(year >= 2000,
         category > 4) %>%
  mutate(name = paste("Hurricane", name)) %>%
  select(name:day, category, wind)

# - 3 - Data manipulation with dplyr pt. 2 ----
# data for exercises
rock_members <- tibble::tribble(
  ~artist,            ~band,
  "John Lennon",      "The Beatles",
  "Paul McCartney",   "The Beatles",
  "George Harrison",  "The Beatles",
  "Ringo Starr",      "The Beatles",
  "Chris Martin",     "Coldplay",
  "Jonny Buckland",   "Coldplay",
  "Guy Berryman",     "Coldplay",
  "Will Champion",    "Coldplay",
  "Phil Harvey",      "Coldplay",
  "John Fogerty",     "Creedence Clearwater Revival",
  "Tom Fogerty",      "Creedence Clearwater Revival",
  "Stu Cook",         "Creedence Clearwater Revival",
  "Doug Clifford",    "Creedence Clearwater Revival"
)

rock_instruments <- tibble::tribble(
  ~name,              ~instrument,
  "John Lennon",      "guitar",
  "Paul McCartney",   "bass",
  "George Harrison",  "guitar",
  "Ringo Starr",      "drums",
  "Mick Jagger",      "silly dance moves",
  "Keith Richards",   "guitar",
  "Ronnie Wood",      "bass",
  "Charlie Watts",    "drums",
  "John Fogerty",     "singer",
  "Tom Fogerty",      "guitar",
  "Stu Cook",         "bass",
  "Doug Clifford",    "drums"
)

# EXERCISE 1: Join tables to retain only rows that appear in both datasets
rock_members %>% inner_join(rock_instruments, by = c("artist" = "name"))

# EXERCISE 2: Find out which band members were dropped from `rock_instruments` EX.1
rock_instruments %>% anti_join(rock_members, by = c("name" = "artist"))

# EXERCISE 3: Using the result of EX.2, modify the `band` column by adding a band name
rock_instruments %>%
  anti_join(rock_members, by = c("name" = "artist")) %>%
  mutate(band = "The Rolling Stones")

# - 4 - Tidy data with tidyr ----
# EXCERCISE 1: The `relig_income` dataset results from a survey.
#             1) Use ?relig_income to find out more about the dataset
#                Feel free to use head() and glimpse(), as well.
#             2) Pivot the dataset to a long format using reasonable column names.

relig_income %>%
  pivot_longer(!religion,
               names_to = "income",
               values_to = "count")

# EXERCISE 2: The fish_encounters dataset is a long table that contains info
#             about fish swimming down a river, passing autonomous monitoring
#             stations.
#             1) Use ?fish_encounters to learn more about the data.
#                Feel free to use head() and glimpse(), as well.
#             2) Pivot the dataset to a wide format with each station as a column.
#             3) Summarize all columns to a single row containing the column sums.
#                Hint: We want to summarize how many fish passed by each station.

fish_encounters %>%
  pivot_wider(names_from = station,
              values_from = seen) %>%
  summarize(across(where(is.integer), ~sum(.x, na.rm = TRUE)))

# - 5 - Dataviz using ggplot2 ----
# EXERCISE 1
# We'll be creating another graph, but using TidyTuesday's Olympics data.
# Download all necessary information using the codeblock below
tuesdata <- tidytuesdayR::tt_load('2021-07-27')
olympics <- tuesdata$olympics
tuesdata

# In RStudio, you can access this dataset's information by running the
# `tuesdata` object. If you're not using RStudio, please browse to following URL:
# https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-07-27/readme.md

# Read through the information above, look at the data (head, glimpse, ...) and
# get ready for data wrangling and dataviz! Make sure to check your result every
# step of the way. Check to see whether your result matches your expectations!

# Step 1: Filter a sport of your choosing (I'm going for Archery) - Hint: unique(olympics$sport)
# Step 2: Summarize the number of gold/silver/bronze medals per NOC, call it `medal_num`
#         Hint: group_by() %>% summarize()
#         Hint: Because `medal` is stored as characters, try `medal_num = length(medal)`
# Step 3: Drop all NA values from `medal`
# Step 4: Create a variable called `total_medals`, which contains the total number
#         of medals per NOC.
# Step 5: Modify variables:
#         noc -> reorder it according to the `total_medals` column (Hint: fct_reorder())
#         medal -> reorder it to `levels = "Gold", "Silver", "Bronze"` (Hint: fct_relevel())
# Step 6: Create a new `label` variable
#         This variable contains text for each NOC: "x medals", where x is
#         the number of medals of a given NOC. (Hint: paste(total_medals, "medals"))
# Step 7: Time to start plotting. Initialize your ggplot
# Step 8: Create a barplot where `x` is your NOC, `y` the medals and fill `medal`
#         Hint: Think about whether to use geom_bar() or geom_col()!
# Step 9: Add a text geom where you add the `label` variable as text to the plot.
#         You'll need to supply `x`, `y` and `label = label`
# Step 10: Use a coordinate function to flip the x- and y-axes.
# Step 11: We have a lot of whitespace that we can fill with some information.
#          For Archery, I'm filling it with text copied from Wikipedia:
#          geom_label(
#             label = "Archery is the sport, practice, or skill of using a bow to shoot arrows.
#               The word comes from the Latin arcus, meaning bow. Historically, archery has been
#               used for hunting and combat. In modern times, it is mainly a competitive sport
#               and recreational activity. A person who practices archery is typically called an
#               archer or a bowman, and a person who is fond of or an expert at archery is
#               sometimes called a toxophilite or a marksman. (Wikipedia)",
#             x = 10, y = 45
#           )
# Step 12: Manually change the fill colours (`scale_*_*()`) of the medals to
#          gold, silver and bronze. (Hint: values = c("#AF9500", "#B4B4B4", "#6A3805"))
# Step 13: Add a theme function.
# Step 14: Add a scale function for the y-axis (continuous!) and add following arguments:
#          --> expand = c(0, 0)
#          --> limits = c(0, 80) (use a number higher than `total_medals`)
# Step 15: Add a title and a caption. No x- or y-titles needed (x = "", y = "").
# BONUS: Use `theme()` to customize the plot further to your heart's content!
#        see `?theme` to find

olympics %>%
  filter(sport == "Archery") %>%
  group_by(noc, medal) %>%
  summarise(
    medal_num = length(medal)
  ) %>%
  ungroup() %>%
  drop_na(medal) %>%
  group_by(noc) %>%
  mutate(total_medals = sum(medal_num)) %>%
  ungroup() %>%
  mutate(
    noc = fct_reorder(noc, total_medals),
    medal = fct_relevel(medal, levels = "Gold", "Silver", "Bronze"),
    label = paste0(total_medals, " medals")
  ) %>%
  ggplot() +
  geom_col(
    aes(x = noc, y = medal_num, fill = medal), col = "black"
  ) +
  geom_text(
    aes(x = noc, y = total_medals, label = label),
    hjust = -0.15, col = "grey25", size = 3
  ) +
  coord_flip() +
  geom_label(
    label = "Archery is the sport, practice, or skill of using a bow to shoot arrows.
    The word comes from the Latin arcus, meaning bow. Historically, archery has been
    used for hunting and combat. In modern times, it is mainly a competitive sport
    and recreational activity. A person who practices archery is typically called an
    archer or a bowman, and a person who is fond of or an expert at archery is
    sometimes called a toxophilite or a marksman. (Wikipedia)",
    x = 10, y = 45
  ) +
  scale_fill_manual(
    values = c("#AF9500", "#B4B4B4", "#6A3805")
  ) +
  theme_classic() +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 80)
  ) +
  labs(
    title = "Olympic medals won in Archery",
    x = "",
    y = "",
    caption = "Olympics data from Kaggle, supplied by TidyTuesday | DataViz by ... ."
  ) +
  theme(
    axis.line = element_blank(),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_line(colour = "grey50"),
    axis.text.x = element_blank(),
    axis.text.y = element_text(colour = "black", face = "italic"),
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    plot.caption = element_text(colour = "grey50"),
    plot.background = element_rect(colour = NA, fill = "grey95"),
    panel.background = element_rect(colour = NA, fill = "grey95")
  )

