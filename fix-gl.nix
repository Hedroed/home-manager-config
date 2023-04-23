{ pkgs, ... }: 
{
  home.packages = with pkgs; [
    inputs.nixgl.nixGLIntel
  ];
  xsession.windowManager.i3.config.terminal = "${pkgs.inputs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.kitty}/bin/kitty";
}
