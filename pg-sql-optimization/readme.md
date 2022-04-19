sql optimization from postgrespro qpt. 
  
_TEST_   
  
```diff
- TEST. 
+ TEST fsfds. 
```
`check postgres.  
another string`

**check bold.  
bold finish**

docker start 144
  
запускаю docker-compose up  
подключаюсь к контейнеру [root]  
su -c psql airuser  
No passwd entry .. airuser  
adduser airuser  
su -c "psql -d postgres" airuser  

Рабочие команды:  
Загрузка базы из файла  
psql -U airuser -d postgres -a -f /tmp/demo-big.sql
psql -U airuser -d demo
