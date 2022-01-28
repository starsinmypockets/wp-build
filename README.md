# WP-Build

A quick script to setup a Wordpress instance.

## Installing the tool
* clone this repo
* `$ cp wpb.sh /usr/bin/wpb && chmod +x /usr/bin/wpb`

## Setting up a wordpress site
* Install Debian
* Install NGINX
* Install MySql with `.my.cnf`
* Create a directory for your wordpress instance at `/var/www/SITEHOSTNAME`
* Copy `sample.wpbconfig.sh` to your site directory and configure
* From the site directory run `$ wpb`
