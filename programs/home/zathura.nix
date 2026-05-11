{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      selection-notification = "false";
      adjust-open = "best-fit";
      pages-per-row = 1;
      scroll-page-aware = true;
      scroll-full-overlap = 0.01;
      scroll-step = 50;
      zoom-min = 10;
      index-bg = "#000000";
      index-fg = "#444444";
      index-active-bg = "#aaaaaa";
      index-active-fg = "#000000";
      font = "inconsolata 15";
      default-bg = "#000000";
      default-fg = "#eeeeee";
      link-hadjust = false;
      statusbar-fg = "#ffffff";
      statusbar-bg = "#000000";
      inputbar-bg = "#000000";
      inputbar-fg = "#FFFFFF";
      notification-error-bg = "#AC4142";
      notification-error-fg = "#151515";
      notification-warning-bg = "#AC4142";
      notification-warning-fg = "#151515";
      highlight-color = "#222222";
      highlight-active-color = "#111122";
      highlight-fg = "#ffffff";
      highlight-transparency = 0.5;
      completion-highlight-fg = "#ff0000";
      completion-highlight-bg = "#90A959";
      completion-bg = "#ff0030";
      completion-fg = "#ff0000";
      notification-bg = "#ffA959";
      notification-fg = "#151515";
      recolor = true;
      recolor-lightcolor = "#000000";
      recolor-darkcolor = "#E0E0E0";
      recolor-reverse-video = true;
      recolor-keephue = true;
    };
  };
}
