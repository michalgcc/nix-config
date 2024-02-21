# WSL specific config
if [[ $(grep -i Microsoft /proc/version) ]]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
    # Change shell to fish
    fish
fi

# Obsolete:

# PROMPT_COMMAND='PS1="$(powerline-go -newline -hostname-only-if-ssh)"; echo -ne "\033]0;$(pwd)\007"'

# function cp() {
#     rsync -ah --progress $@
# }

# function ii() {
#     (nautilus . &>/dev/null &)
# }

# function git_add_rebase_i() {
#     git add -A && git commit -m "x" && git rebase -i HEAD~2
# }

# function c() {
#     if [ -z "$*" ]; then
#         set -- "."
#     fi

#     command codium "$@" &>/dev/null
# }

# function battery_conservation() {
#     if [ -z "$1" ]; then
#         echo "battery_conservation command options:"
#         echo "'show': Display the current conservation mode status"
#         echo "'on': Enable the battery conservation mode"
#         echo "'off': Disable the battery conservation mode"
#     else
#         case $1 in
#         show)
#             conservation_mode=$(cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
#             if [ "$conservation_mode" == "1" ]; then
#                 echo "Conservation mode is on (1)"
#             else
#                 echo "Conservation mode is off (0)"
#             fi
#             ;;
#         on)
#             echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode >/dev/null
#             ;;
#         off)
#             echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode >/dev/null
#             ;;
#         *)
#             echo "Invalid command. Available commands are: 'show', 'on', 'off'"
#             ;;
#         esac
#     fi
# }

# function git_pull_all() {
#     find -maxdepth 2 -type d -name .git -execdir git pull \;
# }
