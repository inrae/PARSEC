# parsec-algo-250102588



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://unh-pfem-gitlab.ara.inrae.fr/parsec/parsec-algo-250102588.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://unh-pfem-gitlab.ara.inrae.fr/parsec/parsec-algo-250102588/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

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
## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
