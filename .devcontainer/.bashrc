# This .bashrc file allows you to customize your bash environment within the container.
# Use it to add aliases, modify your PATH, or set other bash configurations that will persist across container restarts.

# Set JAVA_HOME environment variable (override VS Code Java extension)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Example:
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
