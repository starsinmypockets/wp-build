#!/usr/bin/env bash

installWPCLI() {
  if [ ! -f `which wp` ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php wp-cli.phar --info
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    echo "Successfully installed wp cli at `which wp`"
  else
    echo "WP CLI already installed..."
  fi
}

# DEPRECATED
setupDB() {
  if [ -f /root/.my.cnf ]; then
    mysql -e "CREATE DATABASE ${sitedb_name} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${sitedb_user}@localhost IDENTIFIED BY '${sitedb_pass}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${sitedb_name}.* TO '${sitedb_user}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
  else
    echo "Please configure /root/.my.cnf with your mysql credentials and try again"
  fi
}

setupWP() {
  sudo -u www-data wp core download
  sudo -u www-data wp config create --dbname=${sitedb_name} --dbuser=${sitedb_user} --dbpass=${sitedb_pass} --dbhost=${sitedb_host}
  sudo -u www-data wp db create
  sudo -u www-data wp core install --url=${site_host} --title="${site_title}" --admin_user=${site_admin} --admin_password="${site_admin_pass}" --admin_email=${site_admin_email}
}

# do this first
configureNGINX() {
  echo "Hello world" > index.html
  cp ${wpb_template_path} /etc/nginx/sites-available/${site_host}
  sed -i "s|host|${site_host}|g" /etc/nginx/sites-available/${site_host}
  ln -s /etc/nginx/sites-available/${site_host} /etc/nginx/sites-enabled/${site_host}
  if nginx -t > /dev/null 2>&1; then
    echo "NGINX syntax updated, restarting nginx..."
    service nginx restart
    echo "checking for site..."
    if curl ${site_host} | grep "Hello world"; then
      ## TODO prob want / need to test make sure site is up first
      if runcertbot; then
        certbot --nginx -d ${host} -d www.${host}
      fi
      rm index.html
    else
      echo "Site setup failed!"
      exit 1
    fi
  else 
    echo "syntax is not ok"
  fi
}

source $PWD/wpbconf.sh
configureNGINX
installWPCLI
setupWP
