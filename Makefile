ifeq ($(MAKECMDGOALS), impure)
ifeq ($(strip $(ATTR)),)
	$(error not define ATTR)
endif
endif

impure:
	python ./scripts/main.py home $(ATTR)

vm:
	nixos-rebuild build-vm --flake .#minvm