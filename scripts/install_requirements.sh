declare -A requirements=(
    ["ripgrep"]="rg"
    ["python3"]=
    ["npm"]=
    ["git"]=
    ["gcc"]=
    ["xclip"]=
    ["curl"]=
)

# Exit immediately if a error occurs
set -e

# Print line separators
print_sep () {
    for i in $(seq $(tput cols)); do
        printf "_"
    done
}


# Install nvim if it does not exist
if command -v nvim &> /dev/null; then
    echo "Installing nvim for linux"
    
fi


# Check and install requirements for nvim
installed=()
updateable=()
missing=()

#Check for installed and missing packages
for package in ${!requirements[@]}; do
    package_command=$package
    if [[ -n ${requirements[$package]} ]]; then
        package_command=${requirements[$package]}
    fi

    if command -v $package_command &> /dev/null; then
        installed+=($package)
    else
        missing+=($package)
    fi
done

#Check for updateable packages
if command -v apt &> /dev/null; then
    sudo apt update
    upgradable="$(apt list --upgradable)"

    for package in ${installed[@]}; do
        grep_result="$(grep $package <<< $upgradable)"

        if [[ $grep_result != "" ]]; then
            updateable+=($package)
        fi
    done
else
    echo "Cannot search for upgrades because apt is not installed."
fi

#Print results
print_sep

if [[ -n ${installed[@]} ]]; then
    echo ""
    echo "Installed:"
    for name in ${installed[@]}; do
        echo "+ $name"
    done
fi

if [[ -n ${updateable[@]} ]]; then
    echo ""
    echo "Updateable (or subpackages):"
    for name in ${updateable[@]}; do
        echo "~ $name"
    done
    echo "--> Run \"apt list --upgradable\" for more details"
fi

if [[ -n ${missing[@]} ]]; then
    echo ""
    echo "Missing:"
    for name in ${missing[@]}; do
        echo "x $name"
    done
fi

#Install missing packages
print_sep
if command -v apt &> /dev/null; then
    if [[ -n ${missing[@]} ]]; then
        read -p "Install missing packages [y/n]: " install_choice
        if [[ $install_choice = "y" ]]; then
            for package in ${missing[@]}; do
                sudo apt install $package
            done
        fi
    else
        echo "No missing packages to install."
        echo "You still may require to download dev tool for specific programming languages like the Java SDK."
    fi
else
    echo "Cannot install missing packages because apt is not installed."
fi

