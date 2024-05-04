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


## Nord palette

| code | color |
| --- | --- |
| base00 | #2E3440 |
| base00 | #2E3440 |
| base01 | #3B4252 |
| base02 | #434C5E |
| base03 | #4C566A |
| base04 | #D8DEE9 |
| base05 | #E5E9F0 |
| base06 | #ECEFF4 |
| base07 | #8FBCBB |
| base08 | #BF616A |
| base09 | #D08770 |
| base0A | #EBCB8B |
| base0B | #A3BE8C |
| base0C | #88C0D0 |
| base0D | #81A1C1 |
| base0E | #B48EAD |
| base0F | #5E81AC |
