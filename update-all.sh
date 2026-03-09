#!/bin/zsh
# Zum Ausführen:
#
#    zsh update-all.sh
# 
# Um die einzelnen Funktionen direkt in der Shell zu nutzen,
# kommentiere den Aufruf am Ende der Datei aus und führe aus:
# 
#    source ./update-all.sh
#

# Textfarben definieren
GREEN='\033[32m' # Grün
CLEAR='\033[0m'  # Standardformatierung zurücksetzen

# Homebrew in den non-interactive Modus versetzen, um [y/n] Prompts zu unterdrücken
export NONINTERACTIVE=1

update-brew() {
    if ! which brew &>/dev/null; then return; fi

    echo -e "${GREEN}Aktualisiere Brew Formeln${CLEAR}"
    brew update
    brew upgrade --greedy
    brew cleanup -s

    echo -e "\n${GREEN}Aktualisiere Brew Casks${CLEAR}"
    brew outdated --cask
    brew upgrade --cask --greedy
    brew cleanup -s
}

update-gem() {
    if ! which gem &>/dev/null; then return; fi

    echo -e "\n${GREEN}Aktualisiere Gems${CLEAR}"
    gem update --user-install
    gem cleanup --user-install
}

update-npm() {
    if ! which npm &>/dev/null; then return; fi

    echo -e "\n${GREEN}Aktualisiere Npm-Pakete${CLEAR}"
    npm update -g
}

update-yarn() {
    if ! which yarn &>/dev/null; then return; fi

    echo -e "${GREEN}Aktualisiere Yarn-Pakete${CLEAR}"
    yarn upgrade --latest
}

update-pip2() {
    if ! which pip2 &>/dev/null; then return; fi
    if ! which python2 &>/dev/null; then return; fi

    echo -e "\n${GREEN}Aktualisiere Python 2.7.x Pips${CLEAR}"
    python2 -c "import pkg_resources; from subprocess import call; packages = [dist.project_name for dist in pkg_resources.working_set]; call('pip install --upgrade ' + ' '.join(packages), shell=True)"
}

update-pip3() {
    if ! which pip3 &>/dev/null; then return; fi
    if ! which python3 &>/dev/null; then return; fi

    echo -e "\n${GREEN}Aktualisiere Python 3.x Pips${CLEAR}"
    python3 -c "import pkg_resources; from subprocess import call; packages = [dist.project_name for dist in pkg_resources.working_set]; call('pip3 install --upgrade ' + ' '.join(packages), shell=True)"
}

update-app_store() {
    if ! which mas &>/dev/null; then return; fi

    echo -e "\n${GREEN}Aktualisiere App-Store-Anwendungen${CLEAR}"
    mas outdated
    mas upgrade
}

update-macos() {
    echo -e "\n${GREEN}Aktualisiere macOS (erfordert Root-Rechte)${CLEAR}"
    # Nutzt das im Hintergrund gehaltene sudo-Ticket
    sudo softwareupdate -i -a
}

update-all() {
    # Einmalig Sudo-Passwort im Voraus abfragen
    echo -e "${GREEN}Fordere sudo-Berechtigungen an (für macOS Updates und System-Casks)...${CLEAR}"
    sudo -v

    # Keep-alive-Prozess im Hintergrund starten: Hält sudo-Rechte aktiv, solange das Skript läuft
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Updates ausführen
    update-brew
    update-app_store
    update-macos
}

# START DER AUSFÜHRUNG
update-all