library(tidyverse)
library(plotly)
library(scales)
library(lubridate)
library(reshape2)
library(knitr)
library(naniar)


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

# Customize theme ----

# Create an overall theme for plots
overall_theme <- theme(
  plot.title = element_text(
    face = "bold", color = "deepskyblue4", size = (20), hjust = 0.5
  ),
  legend.title = element_text(color = "steelblue", face = "bold.italic"),
  legend.text = element_text(face = "italic", color = "steelblue4"),
  axis.title = element_text(size = (13), color = "steelblue4"),
  axis.text = element_text(color = "cornflowerblue", size = (10)),
)

# Calculate the total number of DUI cases
under_influence <- collisions_df %>%
  replace_with_na(replace = list(UNDERINFL = "N")) %>%
  mutate(new_data = replace(UNDERINFL, UNDERINFL == "Y", 1)) %>%
  group_by(YEAR) %>%
  summarize(under_influence = sum(as.numeric(new_data), na.rm = T))

# Summarize total injuries, people involved, and collisions per year
summary <- collisions_df %>%
  group_by(YEAR) %>%
  summarize(
    injuries = sum(INJURIES),
    total_people = sum(PERSONCOUNT),
    total_collisions = n()
  )
# Join under influence and summary data frames
joined <- left_join(under_influence, summary) %>%
  rename(
    "Year" = YEAR,
    "Under Influence" = under_influence,
    "Injuries" = injuries,
    "Total People" = total_people,
    "Total Collisions" = total_collisions
  )

# Chart 2 ----

# Total number of injuries each year
num_injuries <- collisions_df %>%
  group_by(YEAR) %>%
  summarize(num_injuries = sum(INJURIES))

# Total number of serious injuries each year
num_serious_injuries <- collisions_df %>%
  group_by(YEAR) %>%
  summarize(num_serious_injuries = sum(SERIOUSINJURIES))

# Total number of fatalities each year
num_fatalities <- collisions_df %>%
  group_by(YEAR) %>%
  summarize(num_fatalities = sum(FATALITIES))

# Pull all types of casualties into a list
all_casualties_list <- list(num_injuries, num_serious_injuries, num_fatalities)

# Merge all data frames
all_casualties <- all_casualties_list %>% reduce(full_join, by = "YEAR")

# Plot multiple y values as separate lines using long format data frame
# Load "reshape2" and use melt function
all_casualties_long <- melt(
  all_casualties,
  id = "YEAR",
  measure = c("num_injuries", "num_serious_injuries", "num_fatalities")
)

all_casualties_long <- all_casualties_long %>%
  rename(Year = YEAR, Quantity = value, Type = variable)

# Change variable names without changing the default colors
# Use scale_color_manual if wanted to change both names and colors
levels(all_casualties_long$Type) <- list(
  "Injuries" = "num_injuries",
  "Serious Injuries" = "num_serious_injuries",
  "Fatalities" = "num_fatalities"
)

# Plot the casualties
plot_casualties <- function(data) {
  ggplot(data, aes(Year, Quantity, color = Type)) +
    geom_point() +
    geom_line() +
    labs(
      title = "Total Number of Casualties Per Year", x = "Year",
      y = "Number of Casualties", color = "Levels of Severity"
    ) +
    overall_theme +
    scale_x_continuous(breaks = pretty_breaks())
}

# Chart 3 ----

# Total number of each weather
num_weather_condition <- collisions_df %>%
  group_by(WEATHER) %>%
  tally() %>%
  na.omit() %>%
  arrange(-n) %>%
  filter(!row_number() %in% c(4, 6)) %>%
  head(5)

# Total number of each road condition
num_road_condition <- collisions_df %>%
  group_by(ROADCOND) %>%
  tally() %>%
  na.omit() %>%
  arrange(-n) %>%
  filter(!row_number() %in% c(3, 6)) %>%
  head(5)

# Total number of each light condition
num_light_condition <- collisions_df %>%
  group_by(LIGHTCOND) %>%
  tally() %>%
  na.omit() %>%
  arrange(-n) %>%
  filter(!row_number() %in% c(3, 8)) %>%
  head(5)

# Create condition plot function
condition_plot <- function(data, type) {
  # Change column names to modify the code easier
  colnames(data)[1:2] <- c("condition_type", "number")

  # Plot
  plot <- ggplot(data) +
    geom_col(aes(reorder(condition_type, desc(number)),
      number,
      fill = condition_type,
      text = paste0(
        condition_type,
        "\n# of Collisions: ",
        formatC(number, big.mark = ",")
      )
    )) +
    labs(
      title = paste0(
        "Total Number of Collisions by ",
        type, " Conditions"
      ),
      x = paste0(type, " Condition"),
      y = "Number of Collisions",
      fill = paste0(type, " Condition")
    ) +
    overall_theme +
    theme(
      axis.text.x = element_text(angle = 45),
      legend.position = "none"
    ) +
    scale_y_continuous(
      labels = label_number(scale_cut = cut_short_scale())
    )

  # Make it interactive
  ggplotly(plot, tooltip = "text")
}

# Server ----

server <- function(input, output) {
  # Chart 1
  output$chart1 <- renderPlotly({
    chart1_df <- collisions_df %>%
      filter(YEAR %in% input$year1_selection) %>%
      mutate(Month = month(INCDATE)) %>%
      mutate(YEAR = as.character(YEAR)) %>%
      group_by(Month, YEAR) %>%
      summarize(Collisions = n()) %>%
      rename(Year = YEAR)

    plot <- ggplot(chart1_df, aes(x = Month, y = Collisions, color = Year)) +
      geom_point() +
      geom_line() +
      labs(
        title = paste0("Collision Trends Over Time"),
        x = "Months", y = "Number of Collisions", color = "Year"
      ) +
      overall_theme +
      scale_x_continuous(breaks = 1:12)

    return(plot)
  })

  # Chart 2
  data <- reactive(
    all_casualties_long %>%
      filter(all_casualties_long$Type %in%
        input$casualty_selection)
  )

  output$chart2 <- renderPlotly({
    plot <- plot_casualties(data())
    return(plot)
  })

  # Chart 3
  output$chart3 <- renderPlotly({
    if (input$condition_selection == 1) {
      plot <- condition_plot(num_weather_condition, "Weather")
    } else if (input$condition_selection == 2) {
      plot <- condition_plot(num_road_condition, "Road")
    } else {
      plot <- condition_plot(num_light_condition, "Light")
    }
    return(plot)
  })

  # Chart 4
  output$chart4 <- renderPlotly({
    collision_types <- collisions_df %>%
      filter(YEAR %in% input$year4_selection) %>%
      filter(COLLISIONTYPE %in% input$coltype_selection) %>%
      group_by(COLLISIONTYPE) %>%
      tally() %>%
      na.omit()

    plot <- ggplot(
      collision_types,
      aes(reorder(COLLISIONTYPE, desc(n)), n,
        fill = COLLISIONTYPE,
        text = paste0(COLLISIONTYPE, "\n# of Collisions: ", n)
      )
    ) +
      geom_col() +
      labs(
        title = paste0("Types of Collision in ", input$year4_selection),
        x = "Collision Types",
        y = "Number of Collisions",
      ) +
      overall_theme +
      theme(axis.text.x = element_text(angle = 45)) +
      theme(legend.position = "none")

    return(ggplotly(plot, tooltip = "text"))
  })

  # Table
  output$table <- renderTable(joined, align = "c", bordered = T, digits = 0)
}
