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

roots:
	for r in $$(nix-store --gc --print-roots | awk '$$1 ~ /^\/home\/bergey/ {print $$1;}'); do \
    du -shc $$(nix-store -qR $$r 2>/dev/null) | awk -v r="$$r" '$$2 ~ /total/ {print $$1, r;}' ;  done \
    | sort -h

iso:
	nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
