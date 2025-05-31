read -p "This will remove all files in order to provide a clean starting point, are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Remove the prior git repo
    rm -rf .git/
    # Create a new empty repo
    git init
    # Remove template documentation
    rm -rf assets/ README.md LICENSE
fi

