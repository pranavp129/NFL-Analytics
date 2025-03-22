# https://pranavpitchala.shinyapps.io/NFLDraftPickAndAV/
# NFL Draft Analysis Shiny App

## Overview
This **Shiny App** provides an interactive tool for analyzing **NFL Draft Picks** and their **Approximate Value (AV)**. Users can explore draft data from **1994 to 2024**, filter by position, draft round, and pick range, and visualize trends in player value based on draft position.

## Features
- **Interactive Filters**: Select draft round, position, and pick range to analyze performance trends.
- **Data Table**: Summarizes average Approximate Value (AV) by position and round.
- **Visualizations**: Scatter plot with trend lines showing AV distribution across draft picks.

## Data Source
The data is sourced from **Pro Football Reference** using the [`nflverse`](https://nflverse.nflverse.com/) package.

## How to Run
1. Clone this repository:
   ```sh
   git clone https://github.com/yourusername/NFL-Analytics.git
   cd NFL-Analytics
   ```
2. Install dependencies in R:
   ```r
   install.packages(c("shiny", "tidyverse", "nflverse", "ggrepel"))
   ```
3. Run the Shiny app:
   ```r
   shiny::runApp()
   ```

## Folder Structure
```
NFL-Analytics/
│── Shiny Scripts/
│   ├── ui.R   # Shiny UI script
│   ├── server.R  # Shiny Server script
│   ├── global.R  # Preprocessed draft data (loaded in both UI and Server)
│── Other R Scripts
│── README.md  # This file
```

## Contributions
Feel free to submit issues or pull requests to enhance the app!

## License
This project is open-source and available under the [MIT License](LICENSE).
