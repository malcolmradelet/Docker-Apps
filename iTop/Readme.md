![iTop Logo](https://www.combodo.com/IMG/jpg/bandeau-produits-itop.jpg)

# iTOP
This is the iTop 3 "Fullmoon" release by Combodo.

iTop is a customizable ITSM and CMDB web solution that can adapt it to your internal processes and help you deliver better services.

## Usage
Currently, this container requires you to run your own database engine. The setup wizard will guide you through connecting to it once you have one running and then create the database.

```docker
docker run -d \
  --name iTop \
  -e TIMEZONE="My/TimeZone"
  -p 80:80 \
  -v iTop-Sessions:/session \
  --restart unless-stopped \
  malcolmradelet/itop3:latest
```

## Parameters
### Environment Variables
- SESSION_LOCATION="/session" #Path to save PHP session data.
- TIMEZONE="America/Vancouver"
- PHP_MAX_UPLOAD="16M" \
- PHP_MAX_POST="32M" \
- PHP_MEMORY_LIMIT="256M" \
- PHP_FPM_USER="apache" \
- PHP_FPM_GROUP="apache" \
- PHP_FPM_LISTEN_MODE="0660"

### Volumes
- /session - Referenced by the SESSION_LOCATION environment variable - Specify a location if you want it to persist beyond the life of the container
- /var/www/localhost/htdocs - Specify a volume for htdocs if you already have an existing iTop installation

### Ports and Database Options
- Todo

## Tags
- iTop3:latest
- iTop3:alpine
- iTop3:\<build> - This isn't properly implemented yet

## Changelog
- Implement performance tweaks and environment variables for them
- Enable volume support for PHP session data
- Rebase from Ubuntu to Alpine 3.15
- Update README
