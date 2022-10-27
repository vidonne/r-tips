install.packages(c("dplyr", "tidyr", "ggplot2", "patchwork", "ggtext", "ragg", "magick"))

library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(ggtext)
library(ragg)
library(magick)

gdpco2 <- read.csv("co2-emissions-and-gdp.csv")
View(gdpco2)

countries <- c("Sweden", "United Kingdom", "France", "United States", "Germany", "Denmark")
gdpco2.six <- filter(gdpco2,  Entity %in% countries) %>%
  select(-Per.capita.CO2.emissions) %>%
  rename(Emissions = Per.capita.consumption.based.CO2.emissions, GDP = GDP.per.capita..PPP..constant.2011.international...)

gdpco2.90 <- filter(gdpco2.six, Year == 1990) %>%
  select(Entity, Emissions.90 = Emissions, GDP.90 = GDP)

gdpco2.six.index <- left_join(gdpco2.six, gdpco2.90, by = "Entity") %>%
  mutate(Emissions.index = Emissions/Emissions.90*100) %>%
  mutate(GDP.index = GDP/GDP.90*100)

gdpco2.plot <- select(gdpco2.six.index, Entity, Year, Emissions.index, GDP.index) %>%
  pivot_longer(cols=3:4, names_to = "Index", values_to = "Value")
View(gdpco2.plot)

# Data labels
datalabels <- filter(gdpco2.plot, (Year == 2017 & Index == "GDP.index") | (Year == 2018 & Index == "Emissions.index")) %>%
  mutate(Label = ifelse(Value - 100 < 0,
                        paste(round(Value - 100), "%", sep = ""),
                        paste("+", round(Value - 100), "%", sep = "")))

View(datalabels)

# Plot
# Plot using facet_wrap
View(gdpco2.plot)
ggplot(gdpco2.plot, aes(x = Year, y = Value, color = Index)) + 
  geom_point(size = 0.5)  +
  geom_line() +
  theme_minimal() + 
  facet_wrap(~Entity, ncol = 3) +
  theme(plot.background = element_rect(fill = "#FAF9F9", color = "#CCCCCC", size = 0.5))

ggsave(filename = "facets_plotbackground.png", units = "cm", width = 20, height = 12)


# Base plot for Patchwork
baseplot <- ggplot(filter(gdpco2.plot, Entity == "Sweden"), aes(x = Year, y = Value, color = Index)) + 
  geom_point(size = 0.5)  +
  geom_line() +
  theme_minimal() + 
  theme(
    axis.title = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 12),
    panel.grid = element_blank(),
    legend.position = "none",
    plot.background = element_rect(fill = "#FAF9F9", color = "#CCCCCC", size = 0.5),
    plot.title = element_text(family = "Playfair Display", size = 18, color = "#565655", hjust = 0.05),
    #plot.title = element_text(size = 18, color = "#565655", hjust = 0.05),
    ) +
  scale_x_continuous(breaks = c(1990, 2018), limits = c(1990, 2024)) +
  scale_color_manual(values = c("#BE5B40", "#526177"))

baseplot + ggtitle("Sweden")

baseplot + ggtitle("Sweden") + geom_text(data = filter(datalabels, Entity == "Sweden"), aes(label = Label, x = 2018.5), hjust = 0, fontface = "bold")

sweden <- baseplot %+% filter(gdpco2.plot, Entity == "Sweden") +
  geom_text(data = filter(datalabels, Entity == "Sweden"), aes(label = Label, x = 2018.5), hjust = 0, fontface = "bold") +
  ggtitle('Sweden') +
  theme(plot.title = element_text(family = "Playfair Display", size = 18, color = "#565655", hjust = 0.05)) +
  annotate("text", x = 2018.5, y = 143, label = "GDP per capita", hjust = 0, color = "#526177") + 
  #annotate("text", x = 2018.5, y = 86, label = "CO₂ emissions\nper capita", hjust = 0, color = "#BE5B40") +
  annotate("richtext", x = 2018.5, y = 86, label = "CO<sub>2</sub> emissions<br />per capita", hjust = 0, fill = NA, label.color = NA, color = "#BE5B40") +
  scale_x_continuous(breaks = c(1990, 2018), limits = c(1990, 2028))
sweden
ggsave(filename = "sweden_annotated_subscript.png", units = "cm", height = 8, width = 12)

uk <- baseplot %+% filter(gdpco2.plot, Entity == "United Kingdom") +
  geom_text(data = filter(datalabels, Entity == "United Kingdom"), aes(label = Label), hjust = -0.4, fontface = "bold") +
  ggtitle('United Kingdom')

france <- baseplot %+% filter(gdpco2.plot, Entity == "France") +
  geom_text(data = filter(datalabels, Entity == "France"), aes(label = Label), hjust = -0.4, fontface = "bold") +
  ggtitle('France')

us <- baseplot %+% filter(gdpco2.plot, Entity == "United States") +
  geom_text(data = filter(datalabels, Entity == "United States"), aes(label = Label), hjust = -0.4, fontface = "bold") +
  ggtitle('US') +
  scale_x_continuous(breaks = c(1990, 2018), limits = c(1990, 2028))

germany <- baseplot %+% filter(gdpco2.plot, Entity == "Germany") +
  geom_text(data = filter(datalabels, Entity == "Germany"), aes(label = Label), hjust = -0.4, fontface = "bold") +
  ggtitle('Germany') 

denmark <- baseplot %+% filter(gdpco2.plot, Entity == "Denmark") +
  geom_text(data = filter(datalabels, Entity == "Denmark"), aes(label = Label), hjust = -0.4, fontface = "bold") +
  ggtitle('Denmark')

# Patch 2 plots together
sweden + uk
ggsave(filename = "sweden_uk.png", units = "cm", height = 8, width = 24)

# Patch of 2 rows of 3 plots
(sweden + uk + france) /
  (us + germany + denmark)
ggsave(filename = "6countries.png", units = "cm", height = 16, width = 36)

# With vertical spacing
(sweden + 
    plot_spacer()  + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
    uk +
    plot_spacer() + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
    france  + plot_layout(widths = c(46,0.1,40,0.1,40))) /
  (us + 
     plot_spacer()  + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
     germany +
     plot_spacer() + theme(plot.margin = unit(c(0,2,0,2), "pt"))+
     denmark  + plot_layout(widths = c(46,0.1,40,0.1,40)))

ggsave(filename = "6countries-verticalspacing.png", units = "cm", height = 16, width = 36)

# With vertical and horizontal spacing
## Row 1
patchwork.all <- (sweden + 
    plot_spacer()  + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
    uk +
    plot_spacer() + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
    france +
    plot_layout(widths = c(46,0.1,40,0.1,40))) /
  ## Row 2 (spacing)
  (plot_spacer() + theme(plot.margin = unit(c(2,0,2,0), "pt"))) /
  ## Row 3
  (us +
     plot_spacer() + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
     germany +
     plot_spacer() + theme(plot.margin = unit(c(0,2,0,2), "pt")) +
     denmark +
     plot_layout(widths = c(46,0.1,40,0.1,40))) +
  ## layout for the whole plot
plot_layout(heights = c(40,0.1,40)) #+
patchwork.all

patchwork.all + plot_annotation(
    title = "Six countries that achieved <span style='color: #424590;'>strong economic growth</span> while <span style='color: #C5303B;'>reducing CO<sub>2</sub> emissions</span>",
    subtitle = "Emissions are adjusted for trade. This means that CO<sub>2</sub> emissions caused in the production of imported goods are added to its<br/>domestic emissions; for goods that are exported the emissions are subtracted.",
    caption = "Other countries achieved the same. Data for more countries can be found on <span style='color: #726FAE;'>OurWorldinData.org</span>",
    theme = theme(
      plot.title = element_markdown(family = "Playfair Display", size = 20, color = "#413E3C"),
      plot.subtitle = element_markdown(family = "Lato", color = "#949393", size = 13.5, margin = margin(t = 0, r = 0, b = 16, l = 0, unit = "pt")),
      plot.caption = element_markdown(family = "Lato", color = "#949393", size = 13, hjust = 0.5, margin = margin(t = 10, r = 0, b = 0, l = 0, unit = "pt")),
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10, unit = "pt")))
  
ggsave(filename = "plot_ready.png", units = "cm", height = 16, width = 36)
ggsave(filename = "ourworldindata_noscale.png", width = 20, height = 11, dpi = 300)
ggsave(filename = "ourworldindata_scaled.png", width = 20, height = 11, dpi = 300, scale = 0.6)

## Logo
chart <- image_read("ourworldindata_scaled.png")
logo <- image_read("OurWorldinData-logo.png")
logo.scaled <- image_scale(logo, "x200")

chart.logo <- image_composite(chart, logo.scaled, offset = "+3200+30")
image_write(chart.logo, path = "OWDcharts-logo.png", format = "png")

