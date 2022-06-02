library(bslib)
library(tidyverse)
library(lubridate)
library(plotly)
library(markdown)


# Load and clean up data ----

# Load original data
collisions_raw_df <- read.csv("seattle-collisions.csv", stringsAsFactors = F)

# Remove unnecessary columns
collisions_df <- collisions_raw_df %>%
  select(
    -INCKEY:-INTKEY, -EXCEPTRSNCODE, -EXCEPTRSNDESC, -INATTENTIONIND,
    -PEDROWNOTGRNT:-HITPARKEDCAR
  )

# Add NA to blank cells
collisions_df <- collisions_df %>%
  mutate_all(na_if, "")

# Save dates
dates <- as.Date(collisions_df$INCDATE)

# Remove the year 2003 and 2022
collisions_df <- collisions_df %>%
  mutate(YEAR = year(INCDATE)) %>%
  filter(YEAR != 2003, YEAR != 2022)

# Update dates
dates <- as.Date(collisions_df$INCDATE)

# Introduction ----

# Introduction tab panel
intro_tab <- tabPanel(
  "Introduction",
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel("About Us", includeMarkdown("introduction.md")),
    )
  )
)

# Chart 1 ----

# Widget
chart1_widget <- sidebarPanel(
  selectizeInput(
    inputId = "year_selection",
    label = h6("Select up to 4 years"),
    choices = sort(unique(collisions_df$YEAR)),
    options = list(maxItems = 4, placeholder = "Select a year"),
    selected = "2004",
    multiple = T
  )
)

# Plot
chart1_plot <- mainPanel(
  plotlyOutput(outputId = "chart1")
)

# Visualization tab
chart1_tab <- tabPanel(
  "Chart 1",
  sidebarLayout(
    chart1_widget,
    chart1_plot
  )
)

# Chart 2 ----

# Widget
chart2_widget <- sidebarPanel(
  checkboxGroupInput(
    inputId = "casualty_selection",
    label = h6("Select a casualty type"),
    choices = list(
      "Injuries" = "Injuries",
      "Serious Injuries" = "Serious Injuries",
      "Fatalities" = "Fatalities"
    ),
    selected = "Injuries"
  )
)

# Plot
chart2_plot <- mainPanel(
  plotlyOutput(outputId = "casualty_chart")
)

# Visualization tab
chart2_tab <- tabPanel(
  "Casualties from Collisions",
  sidebarLayout(
    chart2_widget,
    chart2_plot
  )
)

# Chart 3 ----

# Widget
chart3_widget <- sidebarPanel(
  radioButtons(
    inputId = "condition_selection",
    label = h6("Select a condition"),
    choices = list(
      "Weather" = 1,
      "Road" = 2,
      "Light" = 3
    ),
    selected = 1
  )
)

# Plot
chart3_plot <- mainPanel(
  plotlyOutput(outputId = "chart3")
)

# Visualization tab
chart3_tab <- tabPanel(
  "Chart 3",
  sidebarLayout(
    chart3_widget,
    chart3_plot
  )
)

# Conclusion ----

# Conclusion tab panel
conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    h1("Key Takeaways", align = "center"),
    includeMarkdown("conclusion.md")
  )
)

# 6. UI ----

# Theme
my_theme <- bs_theme(bootswatch = "cerulean")

# User interface
ui <- navbarPage(
  theme = my_theme,
  "Seattle Collisions",
  intro_tab,
  chart1_tab,
  chart2_tab,
  chart3_tab,
  conclusion_tab
)
