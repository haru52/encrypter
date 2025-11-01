.PHONY: install lint lint-sh update-gibo

install:
	./bin/install.sh

lint: lint-sh

lint-sh:
	shellcheck --enable=all --severity=style src/*sh bin/*sh

update-gi:
	gibo update
	cat .gitignore_custom >| .gitignore
	gibo dump macOS Linux Windows VisualStudioCode JetBrains Vim Node >> .gitignore
