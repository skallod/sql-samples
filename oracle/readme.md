docker run -d -e WEB_CONSOLE=false -p 1521:1521 quay.io/maksymbilenko/oracle-12c

hostname: localhost
port: 1521
sid: xe
service name: xe
username: system
password: oracle

http://localhost:8080/em
user: sys
password: oracle
connect as sysdba: true

jdbc:oracle:thin:@localhost:1521:XE
user: johy

