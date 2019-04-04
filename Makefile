.PHONY: init
init:
	carton install

.PHONY: run
run:
	carton exec plackup -l 127.0.0.1:5000 -R lib -Ilib script/scheduler-server
