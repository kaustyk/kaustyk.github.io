.PHONY: all hugo prettier

all: hugo prettier

hugo:
	hugo

prettier:
	npx prettier --write .
