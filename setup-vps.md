- add non-root user
    
```sh 
    adduser dennis
```
- grant the user sudo access

```sh
    usermod -aG sudo dennis
```
- grant new user ssh access
 ```sh
#  from local device run
 ssh-copy-id dennis@localhost
 ```
- harden ssh 
disable ssh using password by: checking under `/etc/ssh/sshd_config` and change the 
  - `PermitRootLogin yes` to `PermitRootLogin no` 
  - `PermitRootLogin yes` to `PermitRootLogin no`
  - `UserPAM yes` to `UserPAM no` 
then to apply the changes
 ```sh
 sudo systemctl reload ssh
 ```  
 after this logging in as root won't work and only logging in as dennis will work
 > changing the default ssh port from 22 is also another option

- enables firewall with ufw
 ```sh
 sudo ufw default deny incoming
 sudo ufw default allow outgoing
 sudo ufw allow 22
 sudo ufw allow 80
 sudo ufw allow 443
 sudo ufw enable
 ``` 
> [!NOTE] 
> If you have a docker container running on your VPS that exposes ports , it will overwrite your iptables rules making those ports implicitly open to avoid this behavior consider addinga reverse proxy.

check if ssh port is open
- check domain is propagated
```sh
    nslookup your-domain

    #sample response
     Server:		127.0.0.53
     Address:	127.0.0.53#53
     Non-authoritative answer:
     Name:	your-domain
     Address: 29.108.9.77
```


Consider 
 - Docker + docker compose  
 - [traefik](https://traefik.io/traefik) as your reverse proxy as ot works really well with comtainers
- [watch tower](https://github.com/containrrr/watchtower) tomonitor your container registry and redeploy on new code 

Example docker compose for a service using traefik and watchtower to run a go server with postgres
- [dreams of code youtube video](https://t.co/oFVjVcidSW)
- [link to project](https://github.com/dreamsofcode-io/guestbook)
```yml
services:
  watchtower:
    image: containrrr/watchtower
    command:
      - "--label-enable"
      - "--interval"
      - "30"
      - "--rolling-restart"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  reverse-proxy:
    image: traefik:v3.1
    command:
      - "--providers.docker"
      - "--providers.docker.exposedbydefault=false"
      - "--entryPoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=elliott@zenful.cloud"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - letsencrypt:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock
  guestbook:
    image: ghcr.io/dreamsofcode-io/guestbook:prod
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.guestbook.rule=Host(`zenful.cloud`)"
      - "traefik.http.routers.guestbook.entrypoints=websecure"
      - "traefik.http.routers.guestbook.tls.certresolver=myresolver"
      - "com.centurylinklabs.watchtower.enable=true"
    secrets:
      - db-password
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_PASSWORD_FILE=/run/secrets/db-password
      - POSTGRES_USER=postgres
      - POSTGRES_DB=guestbook
      - POSTGRES_PORT=5432
      - POSTGRES_SSLMODE=disable
    deploy:
      mode: replicated
      replicas: 3
    restart: always
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres
    restart: always
    user: postgres
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=guestbook
      - POSTGRES_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 5432
    healthcheck:
      test: [ "CMD", "pg_isready" ]
      interval: 10s
      timeout: 5s
      retries: 5
volumes:
  db-data:
  letsencrypt:
secrets:
  db-password:
    file: db/password.txt

```
