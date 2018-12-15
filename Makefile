BOOTSTRAPS := $(shell ls bootstrap)

.PHONY: all global bootstrap-envs ${BOOTSTRAPS}
all: global bootstrap-envs

global:
	nix-env -if global.nix

bootstrap-envs:
	for env in $(shell ls bootstrap | sed 's/\.nix$$//'); do \
		nix-env -p /nix/var/nix/profiles/per-user/bergey/bootstrap-$$env -if bootstrap/$$env.nix; \
	done;

update:
	./update.sh
