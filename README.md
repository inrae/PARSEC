# parsec-algo-250102588

## Name
PARSEC-algo-250102588

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation

Before using this program, ensure that you have the following environment set up on your machine:

### 1 Installing R

- Download and install **R** from the official website: [https://cran.r-project.org/](https://cran.r-project.org/)
- Optional but recommended: Install **RStudio** (user-friendly interface for R): [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)

### 2 Required R Packages

This program relies on several specific R libraries. They need to be installed before running the script:

```r
install.packages(c("dplyr", "lme4", "ggplot2", "patchwork"))
```

| Package       | Purpose                                                         |
| ------------- | --------------------------------------------------------------- |
| **dplyr**     | Data manipulation and processing                                |
| **lme4**      | Mixed-effects models for correcting batch effects               |
| **ggplot2**   | Data visualization                                              |
| **patchwork** | Combining multiple ggplot graphics into a single plot           |
| **optparse**  | Parses command line options for scripts                         |

### 3⃣ Recommended Operating System

- **Windows**, **MacOS**, or **Linux**
- A recent version of **R** (≥ 4.0 is preferred)

### 4⃣ Useful Resources for Beginners

If you are new to R, here are some useful resources to help you get started:

- [Introduction to R](https://cran.r-project.org/doc/contrib/Paradis-rdebuts_fr.pdf) (French)
- [RStudio Documentation](https://support.posit.co/hc/en-us)
- [R for Data Science](https://r4ds.had.co.nz/) (English)
- [R Cheat Sheets](https://posit.co/resources/cheatsheets/)
- [ Other source](https://www.datacamp.com/fr/doc/r/category/r-documentation)

## Usage
### To test the program :
        Rscript ./executable_func.R -i data_test.csv -o data_ouput.csv

### the options :

- `--input` or `-i` for the dataset
- `--ouput` or `-o` for the modified data file

- data_test.csv : represents the file of data that will be processeded by the program
- data_ouput.csv : represents the the modified data file of the data processed by program in comparison with the origin data.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
