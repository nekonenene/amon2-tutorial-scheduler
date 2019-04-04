.PHONY: init
init:
	carton install

.PHONY: run
run:
	carton exec perl -Ilib script/scheduler-server
