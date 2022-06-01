library(bslib)


my_theme <- bs_theme(bootswatch = "cerulean")


# Introduction tab panel
intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    h1("Introduction", align = "center"),
    includeMarkdown("introduction.md")
  )
)


# Visualization tab
chart1_tab <- tabPanel(
  "Chart 1"
)



# Visualization tab
chart2_tab <- tabPanel(
  "Chart 2"
)



# Visualization tab
chart3_tab <- tabPanel(
  "Chart 3"
)


# Conclusion tab panel
conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    h1("Key Takeaways", align = "center")
  )
)


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