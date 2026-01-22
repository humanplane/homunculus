#!/bin/bash

# Colors
CYAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 15)
DIM=$(tput dim)
BOLD=$(tput bold)
NC=$(tput sgr0)

tput civis
trap "tput cnorm" EXIT

cls() { tput clear; }

type_char() {
    for ((i=0; i<${#1}; i++)); do
        printf "%s" "${1:$i:1}"
        sleep 0.025
    done
}

pause() { sleep "${1:-0.5}"; }

# Energy pulse effect
pulse() {
    local chars=("○" "◎" "●" "◉" "●" "◎" "○")
    for char in "${chars[@]}"; do
        tput cup "$1" "$2"
        printf "${MAGENTA}${char}${NC}"
        sleep 0.06
    done
}

# Rising particles
rise() {
    for row in 12 10 8 6 4; do
        tput cup "$row" "$1"
        printf "${YELLOW}✦${NC}"
        sleep 0.05
        tput cup "$row" "$1"
        printf " "
    done
}

cls
pause 0.3

# Homunculus notices something
printf "\n\n\n            ${YELLOW}·  ${CYAN}✧${YELLOW}  ·${NC}\n\n\n"
printf "             ${CYAN}◉${NC}\n"
printf "            ${CYAN}╱│╲${NC}\n"
printf "             ${CYAN}│${NC}\n"
printf "            ${CYAN}╱ ╲${NC}\n"
printf "\n        ${MAGENTA}▰${CYAN}▰${YELLOW}▰${WHITE}▰▰▰${YELLOW}▰${CYAN}▰${MAGENTA}▰${NC}\n"

pause 0.8

printf "\n\n  ${DIM}"
type_char "Hey."
printf "${NC}"
pause 0.5

printf "\n\n  "
type_char "You keep doing the same thing before each release:"
printf "\n"
pause 0.5

printf "\n  ${WHITE}  run tests${NC}"
pause 0.25
printf "\n  ${DIM}  fix what breaks${NC}"
pause 0.25
printf "\n  ${DIM}  update the changelog${NC}"
pause 0.25
printf "\n  ${DIM}  bump the version${NC}"
pause 0.25
printf "\n  ${DIM}  commit${NC}\n"
pause 0.8

printf "\n  "
type_char "I can do that for you."
pause 0.5

printf "\n  ${CYAN}"
type_char "Want me to learn it?"
printf "${NC}\n\n"
pause 0.4

printf "  ${MAGENTA}1${NC}  ${DIM}Yeah, do it${NC}\n"
pause 0.08
printf "  ${MAGENTA}2${NC}  ${DIM}Not yet${NC}\n"
printf "\n"
pause 0.5

printf "  ${MAGENTA}›${NC} "
pause 0.2
printf "${WHITE}"
type_char "1"
printf "${NC}\n"
pause 0.6

# Evolution sequence
cls

printf "\n\n\n            ${DIM}·  ·  ·${NC}\n\n\n"
printf "             ${CYAN}◉${NC}\n"
printf "            ${CYAN}╱│╲${NC}\n"
printf "             ${CYAN}│${NC}\n"
printf "            ${CYAN}╱ ╲${NC}\n"
printf "\n        ${DIM}▰▰▰▰▰▰▰▰▰${NC}\n"

pause 0.3

# Energy gathering
for col in 6 10 20 24; do
    rise "$col" &
done
wait

pause 0.2

# Pulse at center
pulse 6 13 &
pulse 6 17 &
wait

# Transformation frames
colors=("$DIM" "$CYAN" "$MAGENTA" "$YELLOW" "$GREEN" "$WHITE")
for c in "${colors[@]}"; do
    cls
    printf "\n\n\n            ${c}✦  ✧  ✦${NC}\n\n\n"
    printf "             ${c}◉${NC}\n"
    printf "            ${c}╱│╲${NC}\n"
    printf "             ${c}│${NC}\n"
    printf "            ${c}╱ ╲${NC}\n"
    printf "\n        ${c}▰▰▰▰▰▰▰▰▰${NC}\n"
    sleep 0.08
done

# Settle with new power
cls
printf "\n\n\n            ${GREEN}✦  ${WHITE}✧${GREEN}  ✦${NC}\n\n\n"
printf "             ${CYAN}◉${NC}\n"
printf "            ${CYAN}╱│╲${NC}\n"
printf "             ${CYAN}│${NC}\n"
printf "            ${CYAN}╱ ╲${NC}\n"
printf "\n        ${MAGENTA}▰${CYAN}▰${GREEN}▰${WHITE}▰▰▰${GREEN}▰${CYAN}▰${MAGENTA}▰${NC}\n"

pause 0.8

# New capability
printf "\n\n  ${GREEN}"
type_char "Got it."
printf "${NC}"
pause 0.4

printf "\n\n  "
type_char "You can now run "
printf "${WHITE}/release${NC}"
pause 0.5

printf "\n\n  ${DIM}"
type_char "It'll handle tests, changelog, version, commit."
printf "${NC}"
pause 0.4
printf "\n  ${DIM}"
type_char "The whole thing."
printf "${NC}\n"
pause 0.8

printf "\n  ${CYAN}"
type_char "I'll keep an eye out for more patterns."
printf "${NC}\n\n"

pause 2.5

tput cnorm
