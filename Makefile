.PHONY: *

gogo: stop-services build truncate-logs start-services bench

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuda.go
	sudo systemctl stop isutar.go
	sudo systemctl stop mysql

build:
	GO111MODULE=off make -C go/ isuda isutar

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log && sudo chmod 666 /var/log/mysql/mysql-slow.log
	sudo truncate --size 0 /var/log/mysql/error.log

start-services:
	sudo systemctl start mysql
	sudo systemctl start isutar.go
	sudo systemctl start isuda.go
	sudo systemctl start nginx

bench:
	cd ~/isucon6q && ./isucon6q-bench

kataribe:
	sudo cat /var/log/nginx/access.log | ./kataribe -conf kataribe.toml
