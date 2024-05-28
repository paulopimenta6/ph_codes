![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Manual - How to use R codes in ELSA data

## Summary

- [About](#About)
- [Environment](#Environment)
- [How to use](#How-to-use)
- [Statistics](#Statistics)

### About 

## About ELSA

The Longitudinal Study of Adult Health - ELSA Brazil - is a multicenter cohort investigation composed of 15,000 employees from six public institutions of higher education and research in the Northeast, South, and Southeast regions of Brazil. The research aims to investigate the incidence and risk factors for chronic diseases, particularly cardiovascular diseases and diabetes.
At each study center, research subjects - aged 35 to 74 years - undergo examinations and interviews in which aspects such as living conditions, social differences, work relationships, gender, and specifics of the Brazilian population's diet are evaluated.
In addition to fostering the development of new research, the study will be essential for the adaptation of public health policies to national needs. ELSA is made possible by the interest of the Ministry of Health and the Ministry of Science and Technology in conducting large-scale national research on the health of the adult population in Brazil.

### Environment

## Instalantion of R

<p align="center">
  <img src="img/Rlogo.png" alt="R" width="200">
</p>

To install R on Windows and Linux, you can follow these general steps:

<p align="center">
  <img src="img/windows11.png" alt="Windows" width="400">
</p>

1. **Download R**: Go to the [R CRAN website](https://cran.r-project.org/) and download the latest version of R for Windows.

2. **Install R**: Run the downloaded .exe file and follow the installation instructions. You can choose the default settings unless you have specific preferences.

3. **Set Up Environment Variables (Optional)**: Windows might ask you to add R to the system PATH. If not, you can do it manually by adding the R installation directory (C:\Program Files\R\R-X.Y.Z\bin) to the PATH environment variable.

4. **Verify Installation**: Open a command prompt and type R. This should start the R console, indicating that R has been installed successfully.

<p align="center">
  <img src="img/ubuntu.jpg" alt="Ubuntu" width="300">
</p>

1. **Update Package Index**: Open a terminal and run:

```bash
sudo apt update
``` 

2. **Install R**: Run the following command to install R:

```bash
sudo apt install r-base
```

3. **Verify Installation**: Type R in the terminal. This should start the R console, confirming that R has been installed correctly.


## **To update R in Ubuntu Linux**:

1. Update Package Index: First, update the package index to ensure you install the latest version of R:

```bash
sudo apt update
```

2. Check Current R Version: You can check the current version of R installed on your system by running:

```bash
R --version
```

3. Add CRAN Repository: Add the CRAN repository to your sources.list file. Open the sources.list file in a text editor (e.g., vim, nano, gedit):

```bash
sudo vim /etc/apt/sources.list
``` 

Add the following line at the end of the file:

```bash
deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/
```

Replace focal with your Ubuntu version (e.g., bionic, xenial, etc.) and cran40 with the appropriate version for the R release.

4. Add CRAN GPG Key: Add the CRAN GPG key to ensure the packages are signed. Run the following commands:

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
```

5. Update Package Index Again: Update the package index to include the CRAN repository:

```bash
sudo apt update
```

6. Install/Update R: Install or update R using apt:

```bash
sudo apt install r-base
```

7. Check R Version: After installation, you can check the R version to verify it has been updated:

```bash
R --version
```
## Instalation of Rstudio (IDE)

<p align="center">
  <img src="img/rstudio.png" alt="Rstudio" width="300">
</p>

1. For windows users is very easy to install Rstudio just downloading the software from this [website](https://posit.co/download/rstudio-desktop/) and just double clicking the **.exe** and following the intalation instructions.

2. For Linux users is also easy install the rstudio, but instead of downloading an **.exe** you will find a **.deb** file. It is not a problem, because after download you just need to do the command in the Linux terminal:

``` bash
$ sudo dpkg -i <rstdio>.deb
```

**Remember**: Before to install Rstudio it advised to update (and upgrade the OS) doing:

```bash
$ sudo apt update
$ sudo apt upgrade #optional
```

### How to use

## First contact

The directories are organised like: 

 - **_src_**: All sources of statistical analysis
 - **_img_**: All images created from statistical analysis
 - **_prot_**: prototypes of statistical analysis 
 - **_articles_**: articles what project is based to 
 - **_environment_**: first scripts to install libraries (deprecated)
 - **_dados_coordenadas_**: geospatial data
 
 And also there is a **Rproj** file, a file of a project of R. There are two ways to run the project:
 
 1. Windows users just click on _File_ > _Open Project..._ and select the .Rproj file
 2. Linux users coud do the same as windows users but also is possible to run the command:
 
```bash
rstudio <file>.Rproj &
``` 

### Statistics
