ifeq ($(strip $(ATTR)),)
$(error not define ATTR)
endif

impure:
	python ./scripts/main.py home $(ATTR)