{ pkgs, ... }:

{
  # Define a desktop entry for YouTube Music
  xdg.desktopEntries.youtube-music = {
    name = "Youtube Music";
    genericName = "Music streaming service";
    exec = "youtube-music"; # Make sure this is the correct command
    icon = "youtube-music"; # Optionally set an icon
    comment = "Music streaming service";
    categories = [
      "AudioVideo"
      "Music"
    ];
  };
}
