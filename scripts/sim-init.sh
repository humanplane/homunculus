#!/bin/bash

# Colors
CYAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)
YELLOW=$(tput setaf 3)
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
        sleep 0.03
    done
}

pause() { sleep "${1:-0.5}"; }

# Sparkle effect at position
sparkle() {
    local chars=("✦" "✧" "·" "°" "✦")
    local colors=("$MAGENTA" "$CYAN" "$YELLOW" "$WHITE" "$MAGENTA")
    for i in {0..4}; do
        tput cup "$1" "$2"
        printf "${colors[$i]}${chars[$i]}${NC}"
        sleep 0.08
    done
    tput cup "$1" "$2"
    printf " "
}

# Floating particles
particles() {
    local positions=(
        "2 8" "3 18" "4 5" "2 22" "5 12"
        "3 25" "4 15" "2 10" "5 20" "3 7"
    )
    for pos in "${positions[@]}"; do
        read -r row col <<< "$pos"
        tput cup "$row" "$col"
        case $((RANDOM % 4)) in
            0) printf "${MAGENTA}·${NC}" ;;
            1) printf "${CYAN}✧${NC}" ;;
            2) printf "${YELLOW}°${NC}" ;;
            3) printf "${WHITE}✦${NC}" ;;
        esac
        sleep 0.05
    done
}

cls
pause 0.5

# Void with distant stars
cls
for i in {1..6}; do
    row=$((RANDOM % 6 + 1))
    col=$((RANDOM % 28 + 2))
    tput cup "$row" "$col"
    printf "${DIM}·${NC}"
    sleep 0.1
done
pause 0.4

# Central spark ignites
for i in {1..5}; do
    tput cup 4 15
    case $((i % 3)) in
        0) printf "${YELLOW}✦${NC}" ;;
        1) printf "${WHITE}✧${NC}" ;;
        2) printf "${MAGENTA}·${NC}" ;;
    esac
    sleep 0.12
done

pause 0.3

# Form emerges with color shift
cls
particles &
sleep 0.3

printf "\n\n\n\n              ${MAGENTA}.${NC}\n"
pause 0.3

cls
printf "\n\n\n\n              ${CYAN}✧${NC}\n\n\n             ${MAGENTA}( )${NC}\n"
pause 0.25

cls
printf "\n\n\n\n            ${YELLOW}· ${CYAN}✧${YELLOW} ·${NC}\n\n\n             ${CYAN}(${WHITE}.${CYAN})${NC}\n             ${CYAN}/|\\\\${NC}\n"
pause 0.25

cls
printf "\n\n\n\n            ${YELLOW}· ${CYAN}✧${YELLOW} ·${NC}\n\n\n             ${CYAN}(${WHITE}.${CYAN})${NC}\n             ${CYAN}/|\\\\${NC}\n              ${CYAN}|${NC}\n             ${CYAN}/ \\\\${NC}\n"
pause 0.4

# Base forms with animation
printf "\n          "
for i in {1..9}; do
    case $((i % 3)) in
        0) printf "${CYAN}▰${NC}" ;;
        1) printf "${MAGENTA}▰${NC}" ;;
        2) printf "${YELLOW}▰${NC}" ;;
    esac
    sleep 0.06
done
printf "\n"

# Sparkles around the form
for pos in "3 10" "3 20" "5 8" "5 22"; do
    read -r r c <<< "$pos"
    sparkle "$r" "$c" &
done
wait

pause 0.8

# First words
printf "\n\n  ${DIM}"
type_char "..."
printf "${NC}"
pause 0.6

printf "\n\n  ${WHITE}"
type_char "I'm here."
printf "${NC}"
pause 1.2

# Question with color
printf "\n\n  "
type_char "What are we building?"
printf "\n"
pause 0.8

# User input
printf "\n  ${MAGENTA}›${NC} "
pause 0.3
printf "${WHITE}"
type_char "a developer tool"
printf "${NC}\n"
pause 0.6

# Declaration
printf "\n  ${DIM}"
type_char "A developer tool."
printf "${NC}"
pause 0.3
printf " "
type_char "Nice."
pause 0.8

# Style question
printf "\n\n  "
type_char "One more thing—how do you like to work?"
printf "\n\n"
pause 0.2

printf "  ${MAGENTA}1${NC}  ${DIM}Keep it technical${NC}\n"
pause 0.1
printf "  ${MAGENTA}2${NC}  ${DIM}Think out loud with me${NC}\n"
pause 0.1
printf "  ${MAGENTA}3${NC}  ${DIM}I describe, you build${NC}\n"
pause 0.1
printf "  ${MAGENTA}4${NC}  ${DIM}Chaotic, just keep up${NC}\n"
printf "\n"
pause 0.5

printf "  ${MAGENTA}›${NC} "
pause 0.2
printf "${WHITE}"
type_char "1"
printf "${NC}\n"
pause 0.8

# Awakening sequence - full color
cls
pause 0.2

# Pulse with rainbow effect
colors=("$CYAN" "$MAGENTA" "$YELLOW" "$WHITE" "$CYAN" "$MAGENTA")
for c in "${colors[@]}"; do
    cls
    printf "\n\n\n            ${c}·  ✧  ·${NC}\n\n\n"
    printf "             ${c}◉${NC}\n"
    printf "            ${c}╱│╲${NC}\n"
    printf "             ${c}│${NC}\n"
    printf "            ${c}╱ ╲${NC}\n"
    sleep 0.1
done

# Settle with gradient base
cls
printf "\n\n\n            ${YELLOW}·  ${CYAN}✧${YELLOW}  ·${NC}\n\n\n"
printf "             ${CYAN}◉${NC}\n"
printf "            ${CYAN}╱│╲${NC}\n"
printf "             ${CYAN}│${NC}\n"
printf "            ${CYAN}╱ ╲${NC}\n"
printf "\n        ${MAGENTA}▰${CYAN}▰${YELLOW}▰${WHITE}▰▰▰${YELLOW}▰${CYAN}▰${MAGENTA}▰${NC}\n"

# Final sparkle burst
for pos in "2 8" "2 22" "4 6" "4 24"; do
    read -r r c <<< "$pos"
    sparkle "$r" "$c" &
done
wait

pause 1.2

# Final words
printf "\n\n  ${WHITE}"
type_char "Alright."
printf "${NC}"
pause 0.5

printf " "
type_char "I'll stay out of your way."
pause 0.6

printf "\n\n  ${DIM}"
type_char "But I'll be watching."
printf "${NC}"
pause 0.4
printf "\n  ${DIM}"
type_char "Learning how you work."
printf "${NC}"
pause 0.5

printf "\n\n  ${CYAN}"
type_char "Let's build something."
printf "${NC}\n\n"

pause 2.5

tput cnorm
