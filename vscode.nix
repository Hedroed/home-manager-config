{ pkgs }:

let
  font = "'FiraCode Nerd Font Mono', monospace";
  colorTheme = "Nord";
  iconTheme = "vscode-icons";

  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  # Helper function for home-spun VS Code extension derivations
  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };

  myExtensions = {
    nickel = (extension {
      publisher = "kubukoz";
      name = "nickel-syntax";
      version = "0.0.2";
      sha256 = "sha256-ffPZd717Y2OF4d9MWE6zKwcsGWS90ZJvhWkqP831tVM=";
    });

    nix = (extension {
      publisher = "bbenoist";
      name = "nix";
      version = "1.0.1";
      sha256 = "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
    });

    nixpkgs-fmt = (extension {
      publisher = "B4dM4n";
      name = "nixpkgs-fmt";
      version = "0.0.1";
      sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
    });

    nushell = (extension {
      publisher = "TheNuProjectContributors";
      name = "vscode-nushell-lang";
      version = "1.0.0";
      sha256 = "sha256-2FHAFh4ipYKegir7o59Ypb78MOzy2iu+3p3aUUgsatw=";
    });

    oil = (extension {
      publisher = "karino2";
      name = "oilshell-extension";
      version = "1.3.0";
      sha256 = "sha256-rUAHB8rdUHh2G+2Fp8F7Pwmie+43PSWr9pLFfpj1cyw=";
    });

    opa = (extension {
      publisher = "tsandall";
      name = "opa";
      version = "0.12.1";
      sha256 = "sha256-HoFX0pNTbL4etkmZVvezmL0vKE54QZtIPjcAp2/llqs=";
    });

    unison = (extension {
      publisher = "benfradet";
      name = "vscode-unison";
      version = "0.4.0";
      sha256 = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
    });
  };
in
{
  enable = true;
  enableExtensionUpdateCheck = true;
  enableUpdateCheck = true;
  # extensions = (with myExtensions; [
  #   nickel
  #   nix
  #   nixpkgs-fmt
  #   nushell
  #   oil
  #   opa
  #   unison
  # ]) ++ (
  extensions = with pkgs.vscode-extensions; [
    rust-lang.rust-analyzer
    ms-python.vscode-pylance
    bbenoist.nix
    elmtooling.elm-ls-vscode
    eamodio.gitlens
    arcticicestudio.nord-visual-studio-code
    naumovs.color-highlight
  ];

  userSettings = {
    "workbench.startupEditor" = "newUntitledFile";
    "workbench.colorTheme" = colorTheme;
    "workbench.iconTheme" = iconTheme;

    "window.zoomLevel" = -1;
    "window.titleBarStyle" = "native";
    "breadcrumbs.enabled" = true;

    "editor.multiCursorModifier" = "ctrlCmd";
    "editor.renderWhitespace" = "boundary";
    "editor.fontSize" = 15;
    "editor.detectIndentation" = false;
    "editor.tabSize" = 4;
    "editor.insertSpaces" = true;
    "editor.minimap.enabled" = false;
    "editor.fontLigatures" = true;
    "editor.formatOnPaste" = false;
    "editor.wordWrap" = "on";
    "editor.formatOnSave" = false;
    "editor.quickSuggestions" = {
        "strings" = true;
    };
    "editor.inlayHints.enabled" = "onUnlessPressed";
    "editor.rulers" = [ 80 100 ];

    "cSpell.language" = "en,en-GB,en-US,fr,fr-FR";

    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.openEditors.visible" = 0;
    "files.exclude" = {
        "**/.*.crc" = true;
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
    };

    "terminal.integrated.setLocaleVariables" = false;
    "terminal.integrated.detectLocale" = "off";

    "emmet.showExpandedAbbreviation" = "never";
    "emmet.showSuggestionsAsSnippets" = false;

    "http.proxyStrictSSL" = false;
    "http.proxySupport" = "on";

    "git.confirmSync" = false;
    "git.autofetch" = true;
    "gitlens.showWhatsNewAfterUpgrades" = false;
    "gitlens.showWelcomeOnInstall" = false;
    "gitlens.plusFeatures.enabled" = false;

    "vsicons.dontShowNewVersionMessage" = true;
    "atomKeymap.promptV3Features" = true;

    "python.formatting.autopep8Args" = [
        "--max-line-length=160"
    ];
    "python.showStartPage" = false;
    "python.defaultInterpreterPath" = "/usr/bin/python";
    "python.venvPath" = "~/.virtualenvs";
    "python.linting.flake8Args" = [
        "--max-line-length=160"
    ];
    "python.linting.mypyEnabled" = true;
    "python.dataScience.enabled" = false;

    "vetur.format.options.useTabs" = false;
    "vetur.format.options.tabSize" = 4;
    "vetur.format.defaultFormatterOptions" = {
        "prettier" = {
            "semi" = false;
            "singleQuote" = true;
        };
    };

    "prettier.tabWidth" = 4;
    "prettier.trailingComma" = "es5";
    "prettier.printWidth" = 200;
    "prettier.semi" = false;
    "prettier.singleQuote" = true;

    "javascript.preferences.quoteStyle" = "single";

    "go.useLanguageServer" = true;

    "[vue]" = {
        "editor.defaultFormatter" = "octref.vetur";
    };

    "typescript.updateImportsOnFileMove.enabled" = "always";

    "tailwindCSS.experimental.classRegex" = [
        "tw`([^`]*)"
        "tw=\"([^\"]*)"
        "tw={\"([^\"}]*)"
        "tw\\.\\w+`([^`]*)"
        "tw\\(.*?\\)`([^`]*)"
    ];
    "tailwindCSS.includeLanguages" = {
      "typescript" = "javascript";
      "typescriptreact" = "javascript";
    };
    "tailwindCSS.classAttributes" = [
        "class"
        "className"
        "ngClass"
        "styleName"
    ];

    "rust-client.engine" = "rust-analyzer";

    "[nix]" = {
      "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
    };
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
  };
  userTasks = { };
}

