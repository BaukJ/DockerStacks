# DockerStacks

A collection of docker stack files that work together

## Issues / Manual Steps

Gerrit needs to set this up:
curl -H 'Content-Type: plain/text' -X POST --data 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7qBxfXj7DTxTmqk5zXlqnpowbR1/ChiVBKlJPAcsMCR3WaTrg+AXe8GGLxkHZSvt5M3AJwTPzvC7AqGE+2HIyHfxiq+mFNRlcALsrDkM1HZCjxf/Pglx9FjxRMlkOD8s7Ufi6wczX816V0vbBnjbpQV6a/XhtX/g727dnRlqzfhNOzUl0Tf4X+zgRgqPAO1BkYS70zI1Ss8aH2gpzh67zAyrKs8Dh3hzNxMsXkCRNIj2jXooGJXs5HSlbMao+nb1SeJxppgU6Ui7JFDGDwMDOewMVE7DFIVzKgUoJxmYPQVA6viQRIhL2CZ89hKc6zOImqMURW3RNgXf5uVzQRjIX your_email@example.com' http://admin:admin@127.0.0.1:38080/a/accounts/self/sshkeys

could curl from the gerrit master to where it needs to go
