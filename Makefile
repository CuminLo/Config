# Define all scripts in the init directory
INIT_SCRIPTS = $(wildcard init/*.sh)

.PHONY: all brew fonts apps zsh pyenv nvm rime permissions

permissions:
	@echo "Setting execute permissions for init scripts..."
	@chmod +x $(INIT_SCRIPTS)

brew: permissions
	@bash init/00_install_homebrew.sh

fonts: permissions
	@bash init/01_install_fonts.sh

# The apps target now correctly filters out its own name from the command goals
# and passes the rest as arguments to the script.
# Usage: make apps w3m
apps: permissions
	@bash init/02_install_apps.sh $(filter-out $@,$(MAKECMDGOALS))

zsh: permissions
	@bash init/04_setup_zsh.sh

pyenv: permissions
	@bash init/05_setup_pyenv.sh

nvm: permissions
	@bash init/06_setup_nvm.sh

rime: permissions
	@bash init/07_setup_rime.sh

# The 'all' target will run the apps script without arguments
all: permissions brew fonts zsh pyenv nvm rime
	@bash init/02_install_apps.sh
