# Solution

PATH inspection:

    echo "$PATH"
    command -v git
    command -v python

Temporary env variable:

    export APP_ENV=dev
    echo "$APP_ENV"

Alias example:

    echo "alias ll='ls -la'" >> ~/.zshrc
    source ~/.zshrc
    ll