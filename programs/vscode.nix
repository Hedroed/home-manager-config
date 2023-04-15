{ pkgs }:
{
  programs.vscode = let
    font = "'FiraCode Nerd Font Mono', monospace";
    colorTheme = "Nord";
    iconTheme = "material-icon-theme";

    inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

    # Helper function for home-spun VS Code extension derivations
    extension = { publisher, name, version, sha256 }:
      buildVscodeMarketplaceExtension {
        mktplcRef = { inherit name publisher sha256 version; };
      };

    myExtensions = {
      textPastry = (extension {
        publisher = "jkjustjoshing";
        name = "vscode-text-pastry";
        version = "1.3.1";
        sha256 = "0rihsvabsxhjcf639qplriwp45vd1ni8ab047nipdwg992rrif1i";
      });

      spellCheckerFrench = (extension {
        publisher = "streetsidesoftware";
        name = "code-spell-checker-french";
        version = "0.3.1";
        sha256 = "1zsgwcx3fd7gh70i6l0vzsyj7hk9ygxlazax9icy0y4ygckrg5qv";
      });

      atomKeymap = (extension {
        publisher = "ms-vscode";
        name = "atom-keybindings";
        version = "3.3.0";
        sha256 = "12hkb2lm9c94b5y6zaxk6ajwx9q78c5jd46brm685qqm6py9ncxz";
      });
    };
  in
  {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
    extensions = (with myExtensions; [
      textPastry
      spellCheckerFrench
      atomKeymap
    ]) ++ (with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      ms-python.vscode-pylance
      bbenoist.nix
      elmtooling.elm-ls-vscode
      eamodio.gitlens
      mhutchie.git-graph
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
      naumovs.color-highlight
      bradlc.vscode-tailwindcss
      streetsidesoftware.code-spell-checker
    ]);

    userSettings = {
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.colorTheme" = colorTheme;
      "workbench.iconTheme" = iconTheme;

      "window.zoomLevel" = -1;
      "window.titleBarStyle" = "native";
      "breadcrumbs.enabled" = true;

      "editor.fontFamily" = font;
      "editor.fontSize" = 15;
      "editor.fontLigatures" = true;
      "editor.wordWrap" = "on";
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.renderWhitespace" = "boundary";
      "editor.detectIndentation" = false;
      "editor.tabSize" = 4;
      "editor.insertSpaces" = true;
      "editor.minimap.enabled" = false;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = false;
      "editor.quickSuggestions" = {
          "strings" = true;
      };
      "editor.inlayHints.enabled" = "onUnlessPressed";
      "editor.rulers" = [ 80 100 ];

      "telemetry.telemetryLevel" = "all";
      "cSpell.language" = "en,en-US,fr,fr-FR";

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
        "editor.tabSize" = 2;
      };
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      };
    };
    userTasks = { };
  };
}
