BOOTSTRAPS := $(shell ls bootstrap)
OLD := 7d

.PHONY: all global bootstrap-envs ${BOOTSTRAPS}
all: global bootstrap-envs

global:
	nix-env -if global.nix

bootstrap-envs:
	for env in $(shell ls bootstrap | sed 's/\.nix$$//'); do \
		nix-env -p /nix/var/nix/profiles/per-user/bergey/bootstrap-$$env -if bootstrap/$$env.nix; \
	done;

update:
	@./update.sh

prune:
	nix-env --delete-generations ${OLD}
	for env in $(shell ls bootstrap | sed 's/\.nix$$//'); do \
		nix-env -p /nix/var/nix/profiles/per-user/bergey/bootstrap-$$env --delete-generations ${OLD}; \
	done;
	sudo nix-collect-garbage --delete-older-than ${OLD}
