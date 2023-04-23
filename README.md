# home-manager-config

My home manager config

```
home-manager switch --flake '.#hedroed

```


## Install

Setup a OS without any graphical softwares.
Once the system in installed follow these steps.

### 1. Install requirements

Packages which must be installed in root are:

- Xorg
- ...

### 2. Install nix and home-manager

https://nixos.org/download.html

https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone-stable


Edit configuration `home.nix` and change the username.

```sh
nix run github:hedroed/home-manager-config#homeConfigurations.hedroed.activationPackage
```

### 3. Display Manager

Install any display manager.

I suggest `SDDM` or `lightdm`.

Create a `/usr/share/xsessions/xsession.desktop`.

```ini
[Desktop Entry]
Name=X session
Comment=X session, controlled by your ~/.xsession
Exec=/etc/X11/Xsession
TryExec=/etc/X11/Xsession
Type=Application
X-LightDM-DesktopName=X session
DesktopNames=X session
```

It will make the link between your home .xsession file and the display manager.

source: http://skybert.net/linux/add-generic-x-session-to-sddm-menu/


#### With hyprland

https://wiki.hyprland.org/Getting-Started/Quick-start/#wrapping-the-launcher-recommended

```
#!/bin/sh

cd ~

export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24

exec Hyprland
```

## documentation

- https://nix-community.github.io/home-manager/
- https://nix-community.github.io/home-manager/options.html
- https://github.com/nix-community/home-manager/tree/master/modules
