Build process:

```docker-compose up -d -f docker-compose.yml -f docker-compose.build.yml```

Run process:

```docker-compose up -d --remove-orphans```

The build file will create a container that will generate the certificates and place them in a shared volume for the rest of your containers to use and then exit.
Once it is complete you can run Compose without the build file to remove the orphan as it is no longer needed.
