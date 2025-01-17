{ lib
, config
, pkgs
, ...
}:
let
  fd = "${pkgs.fd}/bin/fd";
  bat = "${pkgs.bat}/bin/bat";
  colors = config.colorscheme.colors;
in
lib.mkIf config.modules.shell.enable {
  programs.fzf = {
    enable = true;
    defaultCommand = "${fd} -H --type f";
    defaultOptions = [
      "--height 80%"
      "--bind ctrl-p:preview-up,ctrl-n:preview-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down"
      "--border rounded"
    ];
    changeDirWidgetCommand = "${fd} --type d --hidden --exclude .git";
    changeDirWidgetOptions = [ ];
    fileWidgetCommand = "${fd} --type f --hidden --exclude .git --exclude .cache";
    fileWidgetOptions = [ "--preview '${bat} --style=numbers --color=always --line-range :500 {}'" ];
    colors = {
      bg = "-1";
      "bg+" = "-1";
      fg = "#${colors.base04}";
      "fg+" = "#${colors.base06}";
      hl = "#${colors.base0D}";
      "hl+" = "#${colors.base0D}";
      spinner = "#${colors.base0C}";
      header = "#${colors.base0D}";
      info = "#${colors.base0A}";
      pointer = "#${colors.base0C}";
      marker = "#${colors.base0C}";
      prompt = "#${colors.base0A}";
    };
  };
}
