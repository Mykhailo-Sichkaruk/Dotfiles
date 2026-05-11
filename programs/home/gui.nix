{ pkgs, ... }:

let
  audioRecorder = pkgs.writeShellApplication {
    name = "toggle-audio-recording";
    runtimeInputs = with pkgs; [
      coreutils
      ffmpeg
      gnugrep
      gnused
      libnotify
      pipewire
      procps
      wireplumber
    ];
    text = ''
      set -euo pipefail

      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/audio-recorder"
      recordings_dir="''${AUDIO_RECORDING_DIR:-$HOME/recording/audio}"
      pid_file="$state_dir/ffmpeg.pid"
      file_file="$state_dir/current-file"
      mute_file="$state_dir/source-was-muted"
      log_file="$state_dir/ffmpeg.log"
      source_ref="@DEFAULT_AUDIO_SOURCE@"

      notify() {
        notify-send "$@" >/dev/null 2>&1 || true
      }

      read_state() {
        pid="$(cat "$pid_file" 2>/dev/null || true)"
        current_file="$(cat "$file_file" 2>/dev/null || true)"
      }

      is_running() {
        read_state
        [[ "$pid" =~ ^[0-9]+$ ]] || return 1
        [[ -d "/proc/$pid" ]] || return 1
        cmdline="$(tr '\0' ' ' <"/proc/$pid/cmdline" 2>/dev/null || true)"
        [[ -n "$current_file" && "$cmdline" == *"$current_file"* ]]
      }

      cleanup_state() {
        rm -f "$pid_file" "$file_file" "$mute_file"
      }

      restore_source_mute() {
        if [[ "$(cat "$mute_file" 2>/dev/null || true)" == "1" ]]; then
          wpctl set-mute "$source_ref" 1 >/dev/null 2>&1 || true
        fi
      }

      print_devices() {
        echo "PipeWire status:"
        wpctl status || true
        echo
        echo "Default audio source:"
        wpctl inspect "$source_ref" || true
        echo
        echo "FFmpeg PulseAudio sources:"
        ffmpeg -hide_banner -sources pulse 2>&1 || true

        device_id="$(
          wpctl inspect "$source_ref" 2>/dev/null \
            | sed -n 's/.*device.id = "\([0-9][0-9]*\)".*/\1/p' \
            | head -n 1
        )"
        if [[ -n "$device_id" ]]; then
          echo
          echo "Routes for PipeWire device $device_id:"
          pw-cli enum-params "$device_id" Route || true
        fi
      }

      stop_recording() {
        if ! is_running; then
          cleanup_state
          notify "Audio recording" "No recording is running"
          exit 0
        fi

        kill -INT "$pid" 2>/dev/null || true
        for _ in $(seq 1 60); do
          if ! kill -0 "$pid" 2>/dev/null; then
            break
          fi
          sleep 0.1
        done

        if kill -0 "$pid" 2>/dev/null; then
          kill -TERM "$pid" 2>/dev/null || true
        fi

        restore_source_mute
        cleanup_state
        notify "Audio recording stopped" "$(basename "$current_file")"
      }

      start_recording() {
        mkdir -p "$state_dir" "$recordings_dir"

        if is_running; then
          stop_recording
          exit 0
        fi

        cleanup_state

        if wpctl get-volume "$source_ref" 2>/dev/null | grep -q "MUTED"; then
          echo 1 >"$mute_file"
        else
          echo 0 >"$mute_file"
        fi

        wpctl set-mute "$source_ref" 0 >/dev/null 2>&1 || true

        timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
        output="$recordings_dir/audio-$timestamp.flac"

        ffmpeg \
          -hide_banner \
          -nostdin \
          -loglevel warning \
          -f pulse \
          -name keybind-audio-recorder \
          -stream_name microphone \
          -sample_rate 48000 \
          -channels 2 \
          -i default \
          -map 0:a:0 \
          -vn \
          -c:a flac \
          -compression_level 12 \
          -sample_fmt s32 \
          "$output" >"$log_file" 2>&1 &

        pid="$!"
        sleep 0.3

        if ! kill -0 "$pid" 2>/dev/null; then
          restore_source_mute
          cleanup_state
          notify "Audio recording failed" "See $log_file"
          exit 1
        fi

        echo "$pid" >"$pid_file"
        echo "$output" >"$file_file"
        notify "Audio recording started" "$(basename "$output")"
      }

      case "''${1:-}" in
        --devices)
          print_devices
          ;;
        --status)
          if is_running; then
            echo "recording $current_file"
          else
            echo "idle"
          fi
          ;;
        --stop)
          stop_recording
          ;;
        ""|--toggle)
          start_recording
          ;;
        *)
          echo "usage: toggle-audio-recording [--toggle|--stop|--status|--devices]" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [ audioRecorder ];

  services.sxhkd = {
    enable = true;
    extraConfig = ''
      # brightness control
      XF86MonBrightness{Up,Down}
        ${pkgs.light}/bin/light -{A,U} 10

      # volume control
      XF86Audio{Raise,Lower}Volume
        ${pkgs.pulsemixer}/bin/pulsemixer --change-volume {+,-}5 --max-volume 100

      # volume toggle mute
      XF86AudioMute
        ${pkgs.pulsemixer}/bin/pulsemixer --toggle-mute

      XF86Audio{Next,Prev}
        ${pkgs.playerctl}/bin/playerctl --all-players {next,previous}

      XF86AudioPlay
        ${pkgs.playerctl}/bin/playerctl --all-players play-pause

      XF86AudioStop
        ${pkgs.playerctl}/bin/playerctl --all-players stop

      XF86AudioRewind
        ${pkgs.playerctl}/bin/playerctl --all-players play

      XF86AudioPause
        ${pkgs.playerctl}/bin/playerctl --all-players play-pause

      # audio recording
      super + F9
        ${audioRecorder}/bin/toggle-audio-recording

      XF86AudioRecord
        ${audioRecorder}/bin/toggle-audio-recording

      # screenshot
      Print
        ${pkgs.flameshot}/bin/flameshot gui

      ctrl + Print
        ${pkgs.flameshot}/bin/flameshot full
    '';
  };
}
