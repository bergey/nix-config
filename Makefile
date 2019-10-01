BOOTSTRAPS := $(shell ls bootstrap)
OLD := 7d

.PHONY: all os os-update user global bootstrap-envs ${BOOTSTRAPS}
all: user os

user: global bootstrap-envs

update:
	@./update.sh
	make user

os:
	sudo nixos-rebuild switch

os-update:
	sudo nixos-rebuild switch --upgrade

global:
	nix-env -if global.nix

bootstrap-envs:
	for env in $(shell ls bootstrap | sed 's/\.nix$$//'); do \
		nix-env -p /nix/var/nix/profiles/per-user/bergey/bootstrap-$$env -if bootstrap/$$env.nix; \
	done;

prune:
	sudo nix-collect-garbage --delete-older-than ${OLD}

roots:
	for r in $$(nix-store --gc --print-roots | awk '$$1 ~ /^\/home\/bergey/ {print $$1;}'); do \
    du -shc $$(nix-store -qR $$r 2>/dev/null) | awk -v r="$$r" '$$2 ~ /total/ {print $$1, r;}' ;  done \
    | sort -h

iso:
	nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
