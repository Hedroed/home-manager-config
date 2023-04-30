# home-manager-config

My home manager config

```
home-manager switch --flake ".#hedroed@standalone"
```

## Available configurations

| name | usage |
| --- | --- |
| hedroed@standalone | Standalone installation without nixos |
| hedroed@standalone | Nixos and home-manager install |
| ... | ... |

## Install

Setup a OS without any graphical softwares.
Once the system in installed follow these steps.

### 1. Install requirements

Packages which must be installed in root are:

- Xorg
- i3 or hyprland

### 2. Install nix and home-manager

https://nixos.org/download.html

https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone-stable


```sh
nix develop
```

## documentation

- https://nix-community.github.io/home-manager/
- https://nix-community.github.io/home-manager/options.html
- https://github.com/nix-community/home-manager/tree/master/modules
