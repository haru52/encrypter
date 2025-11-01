.PHONY: lint lint-sh update-gibo

lint: lint-sh

lint-sh:
	shellcheck src/**/*.sh

update-gi:
	gibo update
	cat .gitignore_custom >| .gitignore
	gibo dump macOS Linux Windows VisualStudioCode JetBrains Vim Node >> .gitignore
