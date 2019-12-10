# Install R version 3.5
FROM rocker/shiny-verse:latest

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# Install R packages that are required
# TODO: add further package if you need!
RUN R -e "install.packages(c('shiny', 'shinydashboard'), repos='http://cran.rstudio.com/')"

# Copy configuration files into the Docker image
COPY /app /srv/shiny-server/

# Make the ShinyApp available at port 3838
EXPOSE 3838
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Copy further configuration files into the Docker image
#COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]
