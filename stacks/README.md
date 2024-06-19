
# Instrukcije za pokretanje infrastrukture

1. Pozicionirati se na grani feat/deployment, u njoj se nalazi folder /stacks koji sadrzi potrebne fajlove za buildovanje docker slika.

2. U /stacks folderu najbolje je podici cijeli docker compose fajl da bi izbildovali sve slike, potom izvrsiti migracije
``` 
docker-compose --env-file config/env.conf up
docker-compose -f docker-compose-migration.yml --env-file config/env.conf up
```
3. Pokretanje insert skripte
``` 
docker exec -it <id kontenjera baze> psql -U <username baze> -d <sema baze> -f /tmp/DEMO_SKRIPTA.sql
```  
3. Pozicionirati se na operations granu, podesiti parametre
```
set +o history 
export DATABASE_PASSWORD=<value>
export DATABASE_SCHEMA=<value>
export DATABASE_USERNAME=<value>
export EXPLORER_CORS=<value>
export DATABASE_HOST=<value>
set -o history
```
4. Pokrenuti docker swarm servise
```
bash deploy-all.sh
```
5. Za unistavanje servisa 
```
bash destroy-all.sh
```



