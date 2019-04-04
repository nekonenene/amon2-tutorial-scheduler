.PHONY: init
init:
	carton install
	sqlite3 db/development.db < sql/sqlite.sql

.PHONY: run
run:
	carton exec plackup -l 127.0.0.1:8013 -R lib -Ilib script/scheduler-server
