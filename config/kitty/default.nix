{ ... }:

{

  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;

  xdg.configFile."kitty/diff.conf".text = ''
    pygments_style monokai
  '';

}
