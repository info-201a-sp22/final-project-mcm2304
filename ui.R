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

# Collision types
collision_types <- collisions_df %>%
  group_by(COLLISIONTYPE) %>%
  tally() %>%
  na.omit()

# Introduction ----

# Introduction tab panel
intro_tab <- tabPanel(
  "Home Page",
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "About the Project",
        includeMarkdown("text-files/about-the-project.md")
      ),
      tabPanel(
        "Dataset",
        includeMarkdown("text-files/dataset.md")
      ),
      tabPanel(
        "Limitations and Challenges",
        includeMarkdown("text-files/limit-challenge.md")
      ),
      tabPanel(
        "About Us",
        includeMarkdown("text-files/about-us.md")
      ),
    )
  )
)

# Chart 1 ----

# Widget
chart1_widget <- sidebarPanel(
  selectizeInput(
    inputId = "year1_selection",
    label = h6("Select up to 4 years to compare"),
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

# Chart 2 ----

# Widget
chart2_widget <- sidebarPanel(
  checkboxGroupInput(
    inputId = "casualty_selection",
    label = h6("Select a casualty type(s)"),
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
  plotlyOutput(outputId = "chart2")
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

# Chart 4 ----

# Widget
chart4_widget <- sidebarPanel(
  sliderInput(
    inputId = "year4_selection",
    label = h6("Select a year"),
    min = min(collisions_df$YEAR),
    max = max(collisions_df$YEAR),
    value = 2010,
    sep = ""
  ),
  checkboxGroupInput(
    inputId = "coltype_selection",
    label = h6("Select a collision type(s)"),
    choices = collision_types$COLLISIONTYPE,
    selected = collision_types$COLLISIONTYPE[1:5]
  )
)

# Plot
chart4_plot <- mainPanel(
  plotlyOutput(outputId = "chart4")
)

# Visualization tab ----

viz_tab <- navbarMenu(
  "Visualization",
  tabPanel(
    "Collision Trends Over Time",
    sidebarLayout(chart1_widget, chart1_plot),
    hr(),
    includeMarkdown("text-files/about-us.md")
  ),
  tabPanel(
    "Casualties from Collisions",
    sidebarLayout(chart2_widget, chart2_plot)
  ),
  tabPanel(
    "Conditions during Accidents",
    sidebarLayout(chart3_widget, chart3_plot)
  ),
  tabPanel(
    "Collision Types Comparison",
    sidebarLayout(chart4_widget, chart4_plot)
  )
)

# Conclusion ----

# Table panel
table_panel <- sidebarPanel(
  tableOutput(outputId = "table"),
  width = 5
)

# Table summary
summary_panel <- mainPanel(
  includeMarkdown("text-files/table-summary.md"),
  width = 7
)

# Conclusion tab panel
conclusion_tab <- tabPanel(
  "Insights",
  tabsetPanel(
    type = "tabs",
    tabPanel(
      "Key Takeaways", 
      includeMarkdown("text-files/insights.md")),
    tabPanel(
      "Table Summary",
      sidebarLayout(
        summary_panel,
        table_panel,
        position = c("left", "right"),
        fluid = T
      )
    )
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
  viz_tab,
  conclusion_tab
)
