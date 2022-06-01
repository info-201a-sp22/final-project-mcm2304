library(tidyverse)
library(plotly)
library(scales)
library(lubridate)


# 1. Load and clean up data

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

# Chart 3 data ----

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
        "# of Accidents: ",
        formatC(number, big.mark = ",")
      )
    )) +
    labs(
      title = paste0(type, " Conditions"),
      x = paste0(type, " Condition"),
      y = "Number of Accidents",
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

# 2. Server ----

server <- function(input, output) {
  # Chart 3
  output$condition_chart <- renderPlotly({
    if (input$condition_selection == 1) {
      plot <- condition_plot(num_weather_condition, "Weather")
    } else if (input$condition_selection == 2) {
      plot <- condition_plot(num_road_condition, "Road")
    } else {
      plot <- condition_plot(num_light_condition, "Light")
    }
    return(plot)
  })
}
