# Exit immediately if a error occurs
set -e

# Settings vars
BASHRC_PATH="$HOME/.bashrc"
CONFIG_STRING="export PATH='\$PATH:/opt/nvim-linux64/bin'"
SDKMAN_IDENTIFIER="#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!"


# Install nvim
echo "Installing nvim for linux:"
echo ""
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

echo ""
echo "Update .bashrc:"
if grep -q "$CONFIG_STRING" "$BASHRC_PATH"; then
    echo ".bashrc is already configured"

else
    echo "Adding config string to .bashrc"
    if grep -q "$SDKMAN_IDENTIFIER" "$BASHRC_PATH"; then
        sed -i "/$SDKMAN_IDENTIFIER/i $CONFIG_STRING" "$BASHRC_PATH"
    else
        echo "$CONFIG_STRING" >> "$BASHRC_PATH"
    fi
fi

echo ""
echo "*********************************************"
echo "Nvim installation and configuration finished."
echo "*********************************************"
echo ""
echo "Open new terminal or run source ~/.bashrc to apply changes."
