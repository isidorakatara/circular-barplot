# Circular bar plot in R

This repository provides a reproducible example of the code used to create the main **Challenges** circular bar plot for the poster:

> Pita, C., Koumbedakis, K. 2025. *The transformation of small-scale octopus fisheries*. Cephalopod International Advisory Council 2025 Conference (CIAC2025), Okinawa, Japan, 25 October–1 November 2025.

The original data used for the poster are **not included** in this repository. Instead, the repository provides a script that generates completely synthetic mock data with the same structure required by the plotting script.

The purpose is to make the plotting approach easy to reproduce and adapt to other datasets without sharing the original study data.

## Repository structure

```text
circular-barplot-example/
├── R/
│   ├── A_generate_mock_data.R
│   └── B_make_circular_barplot.R
├── data/
│   └── mock_data.csv          # created by Script A
├── output/
│   └── circular_barplot.png   # created by Script B
├── .gitignore
├── circular-barplot-example.Rproj
└── README.md
```

## Workflow

The example uses two scripts.

### Script A — generate mock data

Run:

```r
source("R/A_generate_mock_data.R")
```

This creates:

```text
data/mock_data.csv
```

The values and labels in this file are artificial and are provided only to demonstrate the format expected by the plotting script.

### Script B — make the circular bar plot

After running Script A, run:

```r
source("R/B_make_circular_barplot.R")
```

Script B reads:

```text
data/mock_data.csv
```

and saves the resulting figure as:

```text
output/circular_barplot.png
```

## Expected data structure

Script B expects data in **long format** with three columns:

| group | category | value |
|---|---|---:|
| Group A | Category 1 | 4 |
| Group A | Category 2 | 2 |
| Group A | Category 3 | 6 |
| Group B | Category 1 | 7 |
| Group B | Category 2 | 3 |

The columns have the following roles:

- `group` — defines the larger sections of the circular plot;
- `category` — provides the label for each individual bar;
- `value` — provides the numeric height of each bar.

The public mock data deliberately use generic labels such as `Group A` and `Category 1`. Users can replace these with labels appropriate to their own dataset.

Each row represents one combination of `group` and `category`.

## Required R packages

The scripts use the following packages:

```r
install.packages(c(
  "ggplot2",
  "dplyr",
  "tidyr",
  "stringr",
  "readr"
))
```

## Colours and label positioning

The circular layout usually needs some visual fine-tuning. For that reason, the main settings are collected near the top of **B_make_circular_barplot.R**.

### Selecting group colours

Colours are assigned with a **named vector**:

```r
group_colours <- c(
  "Group A" = "#4f2a86",
  "Group B" = "#22b16d",
  "Group C" = "#e66b63",
  "Group D" = "#2f5573"
)
```

The names must correspond exactly to the values in the `group` column. The hexadecimal codes can be replaced with any preferred colours.

The colours are applied to the plot using:

```r
scale_fill_manual(values = group_colours)
```

If a new group is added to the data, it should also be added to `group_colours`.

### Positioning category labels

Category labels are drawn outside the bars. Their radial position is controlled by:

```r
category_label_offset <- 1
```

and used as:

```r
y = value + category_label_offset
```

Increase `category_label_offset` to move labels further away from the bars; decrease it to move them closer.

Long labels can be wrapped using:

```r
category_label_wrap <- 30
```

The script calculates the angle of every label automatically. Labels falling on the left side of the circle are rotated by 180 degrees and right-justified so that they remain readable:

```r
angle_raw = 90 - 360 * (id - 0.5) / number_of_bars
hjust = if_else(angle_raw < -90, 1, 0)
angle = if_else(angle_raw < -90, angle_raw + 180, angle_raw)
```

This part normally does not need to be edited when using a different dataset.

### Positioning group labels

The larger group names are positioned independently from the category labels.

Their distance from the centre is controlled with:

```r
group_label_y <- -3
```

Their angular position can be fine-tuned group by group using:

```r
group_label_nudge_x <- c(
  "Group A" = 0,
  "Group B" = 0,
  "Group C" = 0,
  "Group D" = 0
)
```

For example, changing `"Group B" = 1` moves the Group B label slightly around the circle, while `"Group B" = -1` moves it in the opposite direction.

Horizontal justification can also be adjusted independently:

```r
group_label_hjust <- c(
  "Group A" = 0.2,
  "Group B" = 1.0,
  "Group C" = 0.5,
  "Group D" = 0.2
)
```

These controls are useful because label placement in a circular plot depends on where each group falls around the circle.

### Changing the scale

The supplied mock data use values between 0 and 8, so Script B uses:

```r
y_ticks <- c(2, 4, 6, 8)
y_min <- -10
y_max <- 12
```

If another dataset has a substantially different range, these values should be changed accordingly. The negative lower limit creates the empty central space used for the group labels.

## Using the code with another dataset

To use the plotting code with your own data:

1. Prepare a CSV file with the columns `group`, `category`, and `value`.
2. Replace `data/mock_data.csv` with your own file, or change `input_file` near the top of `R/B_make_circular_barplot.R`.
3. Edit `group_colours` so that each group in your data has a colour.
4. If necessary, fine-tune `category_label_offset`, `group_label_y`, `group_label_nudge_x`, and `group_label_hjust`.
5. Adjust `y_ticks`, `y_min`, and `y_max` if your values use a different range.
6. Run Script B.

The original dataset used for the CIAC2025 poster is not required to reproduce or adapt the plotting method.

## Data availability

The dataset distributed with this repository is synthetic. It was generated solely to demonstrate the plotting workflow and should not be interpreted as data from the small-scale octopus fisheries study or from the CIAC2025 poster.
