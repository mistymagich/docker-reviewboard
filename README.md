docker-reviewboard with MySQL
=============================

See 'https://github.com/ikatson/docker-reviewboard' if the PostgreSQL

## Quickstart. Run dockerized reviewboard with all dockerized dependencies.

    # Install MySQL
    docker run -d --name rb-mysql -e MYSQL_ROOT_PASSWORD=reviewboard mysql

    # Wait starting MySQL
    sleep 10

    # Create Database and User
    curl -sO https://raw.githubusercontent.com/mistymagich/docker-reviewboard/master/init.sql
    docker run --link rb-mysql:mysql -v `pwd`:/tmp mysql \
      sh -c 'MYSQL_PWD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot < /tmp/init.sql'

    # Install memcached
    docker run --name rb-memcached -d memcached

    # Create a data container for reviewboard with ssh credentials and media.
    docker run -v /.ssh -v /media --name rb-data busybox true

    # Build reviewboard Container
    docker build -t 'mistymagich/reviewboard' git://github.com/mistymagich/docker-reviewboard.git

    # Run reviewboard
    docker run -it --link rb-mysql:mysql --link rb-memcached:memcached --volumes-from rb-data -p 8000:8000 mistymagich/reviewboard


After that, go the url, e.g. ```http://localhost:8000/```, login as ```admin:admin```


Add and change environment variable

- ```MYSQLHOST``` - the mysql host. Defaults to the value of ```MYSQL_PORT_3306_TCP_ADDR```, provided by the ```mysql``` linked container.
- ```MYSQLPORT``` - the mysql port. Defaults to the value of ```MYSQL_PORT_3306_TCP_PORT```, provided by the ```mysql``` linked container, or 3306, if it's empty.
- ```DBUSER``` - the database user. Defaults to ```reviewboard``` (Old PGUSER).
- ```DBNAME``` - the database name. Defaults to ```reviewboard``` (Old PGDB).
- ```DBPASSWORD``` - the database password. Defaults to ```reviewboard``` (Old PGPASSWORD).
