{
  environment.persistence."/persist" = {
    users.joshua = {
      directories = [
        # Not an ideal solution https://redd.it/15xxqlj
        ".cache/nvidia"

        ".mozilla"
        ".cache/mozilla"

        ".cache/starship"

        ".config/nvim"
        ".local/share/nvim"
        ".cache/nvim"

        ".cache/swww"

        ".config/discord"

        ".cache/spotify"
        ".config/spotify"
      ];
    };
  };
}