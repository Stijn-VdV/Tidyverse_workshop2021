###############################################
######## Tidyverse: Data Wrangling 101 ########
########      **DataViz: ggplot2**     ########
########_______________________________########

" Description of ggplot2:
A system for 'declaratively' creating graphics, based on 'The Grammar of Graphics'.
You provide the data, tell 'ggplot2' how to map variables to aesthetics, what
graphical primitives to use, and it takes care of the details. "

# - Your first plot ----
# initialize ggplot object with starwars data
ggplot(data = starwars)

# same, but written using %>%
starwars %>%
  ggplot()

# empty plot --> add a geometric object (geom)
starwars %>%
  ggplot() +
  geom_point()

# Oof, an error!
# => map variables to aesthetics of our plot
starwars %>%
  ggplot() +
  geom_point(
    mapping = aes(x = height, y = mass)
  )

# - Building blocks of a ggplot ----
  # REQUIRED
ggplot() +
  geom_function() +

    # NOT REQUIRED
  coordinate_function() +
  facet_function() +
  scale_function() +
  theme_function()

# - Data preparation ----
# moving away from Star Wars, and into Animal Rescues!
install.packages("tidytuesdayR")
tuesdata <- tidytuesdayR::tt_load('2021-06-29')
animal_rescues_raw <- tuesdata$animal_rescues
tuesdata

# dataviz: number of animals rescues in the last couple of years
# prepare animal_rescues for dataviz
animal_rescues <- animal_rescues_raw %>%
    # select and rename only columns of interest
  select(
    "animal" = animal_group_parent,
    "year" = cal_year,
    "cost" = incident_notional_cost
  ) %>%
    # keep only data for the years 2016 to 2021
  filter(year >= 2016) %>%
    # keep only distinct animal names
  filter(!str_detect(animal, "Unknown")) %>%
    # change all animal names to lowercase (preventing separate counts of e.g. Cat vs cat)
  mutate(
    across(animal, ~tolower(.x)),
    across(cost, ~as.numeric(.x))
  ) %>%
    # keep only animals with at least 5 incidents
  group_by(animal) %>%
  filter(n() >= 5) %>%
  ungroup()


# - Building the plot ----
# basic bar plot => each bar represent group counts
ggplot() +
  geom_bar(data = animal_rescues, mapping = aes(x = animal))

# alternative: geom_col => data values represent bar height
ggplot() +
  geom_col(data = animal_rescues, mapping = aes(x = animal, y = cost))

# coordinate systems
ggplot() +
  geom_bar(data = animal_rescues, mapping = aes(x = animal)) +
  coord_flip()

# faceting
ggplot() +
  geom_bar(data = animal_rescues, mapping = aes(x = animal)) +
  coord_flip() +
  facet_wrap(~year)

ggplot() +
  geom_bar(data = animal_rescues, mapping = aes(x = animal)) +
  coord_flip() +
  facet_grid(rows = vars(animal), cols = vars(year))

# scales #1
ggplot() +
  geom_bar(
    data = animal_rescues,
    mapping = aes(x = animal, fill = animal), colour = "black"
  ) +
  coord_flip() +
  facet_wrap(~year)

# scales #2
ggplot() +
  geom_bar(
    data = animal_rescues,
    mapping = aes(x = animal, fill = animal), colour = "black"
  ) +
  coord_flip() +
  facet_wrap(~year) +
  scale_fill_brewer(palette = "Set3")

# themes
ggplot() +
  geom_bar(
    data = animal_rescues,
    mapping = aes(x = animal, fill = animal), colour = "black"
  ) +
  coord_flip() +
  facet_wrap(~year) +
  scale_fill_brewer(palette = "Set3") +
  theme_classic()

# - Final edits ----
# our plot so far (slightly rewritten)
animal_rescues %>%
  ggplot(aes(y = animal, fill = animal)) +
  geom_bar(colour = "black") +
  facet_wrap(~year) +
  scale_fill_brewer(palette = "Set3") +
  theme_classic()

# four things to improve:
  # 1) lump least frequently observed animals
  # 2) reordering bars
  # 3) add count labels to each bar
  # 4) improve plot's general look and feel

# 1 + 2: lump least frequently observed animals + reordering bars
animal_rescues %>%
  mutate(
      # lump least frequent groups
    animal = fct_lump_n(animal, n = 7),
      # reorder variable according to number of observations
    animal = fct_infreq(tolower(animal)),
      # reverse ordering to show bars in descending order
    animal = fct_rev(animal)
  ) %>%
  ggplot(aes(y = animal, fill = animal)) +
  geom_bar(colour = "black") +
  facet_wrap(~year) +
  scale_fill_brewer(palette = "Set3", direction = -1) +
  theme_classic()

# 3: add count labels to bars
animal_rescues %>%
  mutate(
      # lump least frequent groups
    animal = fct_lump_n(animal, n = 7),
      # reorder variable according to number of observations
    animal = fct_infreq(tolower(animal)),
      # reverse ordering to show bars in descending order
    animal = fct_rev(animal)
  ) %>%
  ggplot(aes(y = animal, fill = animal)) +
  geom_bar(colour = "black") +
  geom_text(stat = "count", aes(label = ..count..)) +
  facet_wrap(~year) +
  scale_fill_brewer(palette = "Set3", direction = -1) +
  theme_classic()

# 4: finishing up - perfectionism!
animal_rescues %>%
  mutate(
      # lump least frequent groups
    animal = fct_lump_n(animal, n = 7),
      # reorder variable according to number of observations
    animal = fct_infreq(tolower(animal)),
      # reverse ordering to show bars in descending order
    animal = fct_rev(animal)
  ) %>%
  ggplot(aes(y = animal, fill = animal)) +
  geom_bar(colour = "black") +
  geom_text(
    stat = 'count',
    aes(label = ..count..),
    hjust = -0.15, col = "grey50", size = 3) +
  facet_wrap(~year) +
  scale_fill_brewer(
    palette = "Set3", direction = -1) +
  scale_x_continuous(
    limits = c(0, 390),
    expand = c(0, 0)) +
  theme_classic() +
  labs(
    x = "Number of incidents",
    y = "",
    title = "Animal Rescues in London",
    subtitle = "The animals most commonly saved by the London Fire Brigade",
    caption = "
    Other: hamster, snake and rabbit | TidyTuesday data provided by London.gov | DataViz by Stijn Van de Vondel."
  ) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(face = "italic", hjust = 0.5),
    axis.title = element_text(face = "bold", size = 12, colour = "grey30"),
    plot.caption = element_text(size = 10, colour = "grey50", hjust = 0.5),
    strip.background = element_rect(colour = NA),
    strip.text = element_text(face = "bold", colour = "#660000"),
    plot.background = element_rect(colour = NA, fill = "grey95"),
    panel.background = element_rect(colour = NA, fill = "grey95"),
    strip.background.x = element_rect(colour = NA, fill = "grey95")
  )

# - Saving a plot ----
some_plot <- some_data %>%
  ggplot() +
  geom_point()

# save plot
ggsave(
  filename = "PATH/my_plot.png", plot = some_plot,
  device = "png", units = "in", #inches
  width = 8, height = 6, dpi = 500
)

# save plot (in case it can be retrieved from your session)
ggsave(
  filename = "PATH/my_plot.png", plot = last_plot(),
  device = "png", units = "in", #inches
  width = 8, height = 6, dpi = 500
)

# for our plot specifically
dir.create("graphs")

ggsave(
  filename = "graphs/animal_rescues.png", plot = last_plot(),
  device = "png", units = "in",
  width = 12, height = 6, dpi = 500
)

# - Exercises ----
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




