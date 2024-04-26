{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      "default" = {
        id = 0;
        settings = {
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.contentblocking.category" = "strict";
          "browser.startup.page" = 3;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.warnOnQuitShortcut" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
          "privacy.annotate_channels.strict_list.enabled" = true;
          "privacy.annotate_channels.strict_list.pbmode.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.sanitize.pending" = "[]";
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "signon.rememberSignons" = false;
          "media.eme.enabled" = true;
        };
      };
    };
  };
}
