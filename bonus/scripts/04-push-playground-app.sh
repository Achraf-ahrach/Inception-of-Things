#!/bin/bash

source "$(dirname "$0")/lib.sh"
source .env


GITLAB_REPO_URL="http://oauth2:$GITLAB_ACCESS_TOKEN@localhost:8888/root/$PROJECT_NAME.git"
TEMP_DIR=$(mktemp -d)
REPO_NAME=$(basename "$GITLAB_REPO_URL" .git)

print_message $BLUE "Creating App project in GitLab..."
curl --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
     --data "name=$PROJECT_NAME" \
     http://localhost:8888/api/v4/projects > /dev/null 2>&1
print_message $GREEN "Project created successfully!"

# Clone the repository
print_message $BLUE "Cloning repository..."
git clone "$GITLAB_REPO_URL" "$TEMP_DIR/$REPO_NAME" > /dev/null 2>&1

# Check if clone was successful
if [ $? -ne 0 ]; then
  print_message $RED "Failed to clone the repository. Please check the URL and access token."
  exit 1
fi

# Copy the source directory into the repository
print_message $BLUE "Copying ./app to the repository..."
cp "./app/deployment.yaml" "$TEMP_DIR/$REPO_NAME" > /dev/null 2>&1
cp "./app/namespace.yaml" "$TEMP_DIR/$REPO_NAME" > /dev/null 2>&1
cp "./app/service.yaml" "$TEMP_DIR/$REPO_NAME" > /dev/null 2>&1

# Move into the cloned repository
cd "$TEMP_DIR/$REPO_NAME" > /dev/null 2>&1

# Add the changes
git add .

# Commit the changes
print_message $BLUE "Committing changes..."
git commit -m "push app to GitLab repository"

# Push the changes
print_message $BLUE "Pushing changes to the repository..."
git push

# Check if push was successful
if [ $? -eq 0 ]; then
  print_message $GREEN "Changes pushed successfully!"
else
  print_message $RED "Failed to push changes. Please check your permissions and network connection."
  exit 1
fi

# Clean up
print_message $BLUE "Cleaning up..."
cd - > /dev/null 2>&1
rm -rf "$TEMP_DIR" > /dev/null 2>&1

print_message $GREEN "Done!"
# if do you want show project in gitlab this is link
print_message $GREEN "App project is available at: \c"
print_message $CYAN "http://localhost:8888/root/$PROJECT_NAME"