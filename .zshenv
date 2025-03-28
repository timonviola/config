
# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

if [ -d "$PATH:/opt/mssql-tools/bin" ] ; then
    PATH="$PATH:/opt/mssql-tools/bin"
fi
