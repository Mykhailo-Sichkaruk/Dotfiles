{ ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      volume = 80;
      volume-max = 200;
      sub-auto = "fuzzy";
      sub-file-paths = "ass:srt:sub:Sub:subs:Subs:subtitles:Subtitles";
      sub-font = "MesloLGS NF";
      slang = "ru,en,sk";
      sub-visibility = false;
      cache = true;
      cache-secs = 3600;
      demuxer-max-bytes = "500MiB";
      cache-on-disk = true;
      # demuxer-cache-dir = "~/.cache/mpv";
      # cache-default = 4000000;
      save-position-on-quit = true;
      osc = false;
    };
    scriptOpts.ytdl_hook.ytdl_path = "yt-dlp";
    extraInput = builtins.readFile ../../../home/.config/mpv/input.conf;
  };
}
