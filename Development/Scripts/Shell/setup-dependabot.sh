#!/bin/bash

# Define the project directory
PROJECT_DIR=$(pwd)

# Define the Dependabot configuration directory
DEPENDABOT_DIR="$PROJECT_DIR/.github"

# Create the .github directory if it doesn't exist
if [ ! -d "$DEPENDABOT_DIR" ]; then
    mkdir -p "$DEPENDABOT_DIR"
    echo "Created .github directory."
fi

# Write the Dependabot configuration file
cat > "$DEPENDABOT_DIR/dependabot.yml" <<EOL
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "daily"
    ignore:
      - dependency-name: "glob"
        versions: ["<9.0.0"]
EOL

echo "Dependabot configuration file created at $DEPENDABOT_DIR/dependabot.yml"
