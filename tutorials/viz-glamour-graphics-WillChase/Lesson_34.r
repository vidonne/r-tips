library(tidyverse)
library(lubridate)

#reading in data that I copied and pasted
data <- tibble::tribble(
             ~date, ~no_of_jobs,
    "January 2006",    2439100L,
   "February 2006",    2444400L,
      "March 2006",    2458700L,
      "April 2006",    2458500L,
        "May 2006",    2468000L,
       "June 2006",    2476300L,
       "July 2006",    2487000L,
     "August 2006",    2498100L,
  "September 2006",    2508800L,
    "October 2006",    2513700L,
   "November 2006",    2523700L,
   "December 2006",    2533900L,
    "January 2007",    2541100L,
   "February 2007",    2549300L,
      "March 2007",    2562500L,
      "April 2007",    2568400L,
        "May 2007",    2579000L,
       "June 2007",    2591000L,
       "July 2007",    2594900L,
     "August 2007",    2597800L,
  "September 2007",    2601500L,
    "October 2007",    2610900L,
   "November 2007",    2619200L,
   "December 2007",    2624300L,
    "January 2008",    2626800L,
   "February 2008",    2632200L,
      "March 2008",    2632500L,
      "April 2008",    2638200L,
        "May 2008",    2642400L,
       "June 2008",    2645200L,
       "July 2008",    2655000L,
     "August 2008",    2657700L,
  "September 2008",    2634700L,
    "October 2008",    2646700L,
   "November 2008",    2654500L,
   "December 2008",    2645900L,
    "January 2009",    2630800L,
   "February 2009",    2618300L,
      "March 2009",    2603500L,
      "April 2009",    2583700L,
        "May 2009",    2579500L,
       "June 2009",    2569600L,
       "July 2009",    2556000L,
     "August 2009",    2548400L,
  "September 2009",    2547400L,
    "October 2009",    2542800L,
   "November 2009",    2540100L,
   "December 2009",    2536700L,
    "January 2010",    2539300L,
   "February 2010",    2540700L,
      "March 2010",    2548700L,
      "April 2010",    2558100L,
        "May 2010",    2572100L,
       "June 2010",    2569400L,
       "July 2010",    2570100L,
     "August 2010",    2574300L,
  "September 2010",    2575500L,
    "October 2010",    2583400L,
   "November 2010",    2586400L,
   "December 2010",    2591100L,
    "January 2011",    2598200L,
   "February 2011",    2595400L,
      "March 2011",    2609400L,
      "April 2011",    2623700L,
        "May 2011",    2624500L,
       "June 2011",    2633300L,
       "July 2011",    2641600L,
     "August 2011",    2646600L,
  "September 2011",    2657200L,
    "October 2011",    2655000L,
   "November 2011",    2663000L,
   "December 2011",    2674400L,
    "January 2012",    2683000L,
   "February 2012",    2687600L,
      "March 2012",    2705200L,
      "April 2012",    2714700L,
        "May 2012",    2725400L,
       "June 2012",    2736500L,
       "July 2012",    2743000L,
     "August 2012",    2757000L,
  "September 2012",    2767900L,
    "October 2012",    2773000L,
   "November 2012",    2782200L,
   "December 2012",    2788000L,
    "January 2013",    2793400L,
   "February 2013",    2808500L,
      "March 2013",    2817900L,
      "April 2013",    2825300L,
        "May 2013",    2829500L,
       "June 2013",    2836900L,
       "July 2013",    2847300L,
     "August 2013",    2852300L,
  "September 2013",    2859600L,
    "October 2013",    2866800L,
   "November 2013",    2873300L,
   "December 2013",    2877800L,
    "January 2014",    2881100L,
   "February 2014",    2893200L,
      "March 2014",    2903200L,
      "April 2014",    2917400L,
        "May 2014",    2927100L,
       "June 2014",    2932700L,
       "July 2014",    2945000L,
     "August 2014",    2954800L,
  "September 2014",    2963800L,
    "October 2014",    2976200L,
   "November 2014",    2986200L,
   "December 2014",    2994500L,
    "January 2015",    2995100L,
   "February 2015",    2996100L,
      "March 2015",    2993300L,
      "April 2015",    2987200L,
        "May 2015",    2988400L,
       "June 2015",    2988300L,
       "July 2015",    2991200L,
     "August 2015",    2994400L,
  "September 2015",    2995100L,
    "October 2015",    2998000L,
   "November 2015",    2992200L,
   "December 2015",    2992900L,
    "January 2016",    3002100L,
   "February 2016",    2997400L,
      "March 2016",    2991600L,
      "April 2016",    2993900L,
        "May 2016",    2990200L,
       "June 2016",    2982900L,
       "July 2016",    2991400L,
     "August 2016",    2989300L,
  "September 2016",    2992400L,
    "October 2016",    2992300L,
   "November 2016",    2991800L,
   "December 2016",    2995400L,
    "January 2017",    3002800L,
   "February 2017",    3003400L,
      "March 2017",    3012400L,
      "April 2017",    3016900L,
        "May 2017",    3021100L,
       "June 2017",    3023900L,
       "July 2017",    3016100L,
     "August 2017",    3022400L,
  "September 2017",    3011500L,
    "October 2017",    3031200L,
   "November 2017",    3038400L,
   "December 2017",    3044700L,
    "January 2018",    3047700L,
   "February 2018",    3060000L,
      "March 2018",    3067300L,
      "April 2018",    3069300L,
        "May 2018",    3075600L,
       "June 2018",    3082900L,
       "July 2018",    3089700L,
     "August 2018",    3098600L,
  "September 2018",    3101200L,
    "October 2018",    3114600L,
   "November 2018",    3119700L,
   "December 2018",    3127900L,
    "January 2019",    3138700L,
   "February 2019",    3145100L,
      "March 2019",    3139600L,
      "April 2019",    3146700L,
        "May 2019",    3153600L,
       "June 2019",    3156400L,
       "July 2019",    3161800L,
     "August 2019",    3166800L,
  "September 2019",    3172000L,
    "October 2019",    3176200L,
   "November 2019",    3184700L,
   "December 2019",    3182600L,
    "January 2020",    3192200L,
   "February 2020",    3200200L,
      "March 2020",    3176700L,
      "April 2020",    2831100L,
        "May 2020",    2888200L,
       "June 2020",    2931400L,
       "July 2020",    2917100L,
     "August 2020",    2934700L,
  "September 2020",    2949600L,
    "October 2020",    2975900L,
   "November 2020",    3001500L,
   "December 2020",    2999000L,
    "January 2021",    3000400L,
   "February 2021",    2990000L,
      "March 2021",    3016500L,
      "April 2021",    3026800L,
        "May 2021",    3035900L,
       "June 2021",    3047900L,
       "July 2021",    3082100L,
     "August 2021",    3091700L,
  "September 2021",    3100600L,
    "October 2021",    3116800L,
   "November 2021",    3134100L,
   "December 2021",    3150800L,
    "January 2022",    3155900L,
   "February 2022",    3175500L,
      "March 2022",    3183200L,
      "April 2022",    3203300L,
        "May 2022",    3221300L,
       "June 2022",    3239200L
  )

#this is just a basic line chart
p <- data %>%
  mutate(date = mdy(date)) %>%
  ggplot() +
  geom_line(aes(x = date, y = no_of_jobs)) +
  scale_y_continuous(labels = scales::label_number(suffix = "m", scale = 1e-6, accuracy = 0.1)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

#here we use the annotate function to add our arrow and text annotation
p + 
  annotate(geom = "text", x = as.Date("2013-06-01"), y = 2730000, label = "COVID-19 pandemic", hjust = "left") +
  annotate(
    geom = "curve", x = as.Date("2018-06-01"), y = 2730000, xend = as.Date("2020-03-10"), yend = 2810000, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) 