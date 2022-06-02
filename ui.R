library(bslib)
library(plotly)
library(markdown)


my_theme <- bs_theme(bootswatch = "cerulean")


# 1. Introduction ----

# Introduction tab panel
intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    h1("Introduction", align = "center"),
    includeMarkdown("introduction.md")
  )
)

# 2. Chart 1 ----

# Visualization tab
chart1_tab <- tabPanel(
  "Chart 1"
)

# 3. Chart 2 ----

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

# 4. Chart 3 ----

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
  plotlyOutput(outputId = "condition_chart")
)

# Visualization tab
chart3_tab <- tabPanel(
  "Chart 3",
  sidebarLayout(
    chart3_widget,
    chart3_plot
  )
)

# 5. Conclusion ----

# Conclusion tab panel
conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    h1("Key Takeaways", align = "center")
  )
)

# 6. UI ----

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