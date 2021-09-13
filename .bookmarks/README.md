Source: https://threkk.medium.com/how-to-use-bookmarks-in-bash-zsh-6b8074e40774 for more information

Moving around your terminal effectively is going to make you more productive. Sometimes you need to quickly move between different projects or directories located in different places in your machine. For instance, maybe your code lives in ~/project/my-project, but the configuration of the server is in /etc/... Remembering locations is inefficient, and often they take longer to write. What if there is an easy, inexpensive solution in 4 lines of bash?

# How to install
Here is where the magic is. Add these 4 lines of code to your bashrc or zshrc file.

    if [ -d "$HOME/.bookmarks" ]; then
        export CDPATH=".:$HOME/.bookmarks:/"
        alias goto="cd -P"
    fi

Additionally, you need to create the directory in your home folder or wherever it suits you, just remember to update the CDPATH variable above.

    mkdir ~/.bookmarks

# How to use
To add a new bookmark, you just need to create a symbolic link to the folder in your bookmarks directory. I suggest you start all the bookmarks with the same character. This way, the autocomplete will suggest to you all the bookmarks available once you type the character. In my case, I chose the symbol @ . If you want to edit or remove the bookmark, delete the symbolic link and/or create a new one.

    ln -s path/to/certain/directory/with/my/project @important-project
# How does it work?

The magic here is in the $CDPATH variable. $CDPATH is a colon-separated list of directories used as a search path for the cd built-in command. It behaves like the $PATH when resolving binaries. The $CDPATH we define first attempts to locate the directories in the current directory, then in our bookmark’s directory, and finally in the root. Because we are using always the same starting character, if we type it, it will suggest all the bookmarks we have defined.
Additionally, we also declare an alias for cd named goto. The option -P will resolve the symbolic links moving us to the directory instead of the symbolic link.

# Edit
As pointed in this tweet, there are some extra steps needed to make it work in Bash that I overlooked.
https://twitter.com/mattn_jp/status/1434192554036137995?s=20
