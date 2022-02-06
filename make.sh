#!/usr/bin/env bash

COMMAND=$1
shift

source <(sed -E -n 's/[^#]+/export &/ p' .env)

case "$COMMAND" in
    "build")
        docker-compose build
        ;;
    "up")
        docker-compose up
        ;;
    "daemon")
        docker-compose up -d
        ;;
    "down")
        docker-compose down
        ;;
    "restart")
        docker-compose restart
        ;;
    "logs")
        docker-compose logs -f
        ;;
    "config")
        docker-compose config
        ;;
    "ps")
        docker-compose ps
        ;;
    "exec")
        docker-compose exec "$@"
        ;;
    "enable")
        FILE="$NGINX_CONF_PATH/sites-available/$1"
        if [ ! -x "$FILE" ]; then
            echo "File $1 not found"
            exit 1
        fi

        ln -s "$FILE" "$NGINX_CONF_PATH/sites-enabled/$1"
        docker-compose exec nginx nginx -s reload
        ;;
    "disable")
        FILE="$NGINX_CONF_PATH/sites-enabled/$1"
        if [ ! -x "$FILE" ]; then
            echo "File $1 not found"
            exit 1
        fi

        rm "$FILE"
        docker-compose exec nginx nginx -s reload
        ;;
    "login")
        docker-compose exec -it reverse /bin/bash
        ;;
    *)
        echo "Usage: $0 {build|up|down|restart|logs|ps|exec}"
        exit 1
        ;;
esac
