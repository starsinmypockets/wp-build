#!/usr/bin/env bash

installWPCLI() {
  if [ ! -f `which wp` ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php wp-cli.phar --info
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    echo "Successfully installed wp cli at `which wp`"
  fi
}

setupWP() {
  wp core download
  wp config --dbname=${sitedb_name} --dbuser=${sitedb_pass} --dbpass=${sitedb_pass} --dbhost=${sitedb_host}
}

source $PWD/wpbbconf.sh
installWPCLI
