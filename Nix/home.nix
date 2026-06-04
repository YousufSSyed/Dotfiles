{
  inputs,
  ...
}:
let
  firefox-profile = "h9ep31cd.default";
  emoji-font = "Apple Color Emoji";
in
{
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.yousuf =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [ inputs.zen-browser.homeModules.twilight ];
        home = {
          stateVersion = "26.05";
          file.".config/zen/h9ep31cd.default/chrome".source =
            config.lib.file.mkOutOfStoreSymlink "/home/yousuf/.local/share/chezmoi/Firefox/";
        };
        programs.zen-browser = {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "Default";
              isDefault = true;
              path = firefox-profile;
              settings = {
                # Misc Settings
                "xpinstall.signatures.required" = false; # Don't require signatures on addons to install them. Allows sideloading addons.
                "accessibility.typeaheadfind.manual" = false; # Disable pressing "/" key for quick find
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "font.name-list.emoji" = emoji-font;
                "ui.key.menuAccessKey" = 0; # Disable Alt + B from opening Menu bar
                "apz.allow_double_tap_zooming" = false; # Don't double tap the trackpad to zoom in the page;
                "dom.forms.autocomplete.formautofill" = false;
                "intl.date_time.pattern_override.time_short" = "h:mm a";
                "network.http.max-connections" = 1500;
                "network.http.max-persistent-connections-per-server" = 64;
                "browser.gesture.swipe.up" = "";
                "browser.gesture.swipe.down" = "";
                "browser.gesture.swipe.left" = "";
                "browser.gesture.swipe.right" = "";
                "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
                "browser.bookmarks.showMobileBookmarks" = true;
                "browser.aboutConfig.showWarning" = false;
                "browser.urlbar.showSearchTerms.featureGate" = true; # Show the search query in the URL bar instead of the URL (only for the default search engine).
                "browser.urlbar.trimURLs" = false; # Show whole URLs in the URL bar.
                "browser.tabs.closeWindowWithLastTab" = true;
                "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in new tabs instead of in the current one.
                # Open new tab next to current one instead of at the rightmost.
                "browser.tabs.insertAfterCurrent" = true;
                "browser.tabs.insertRelatedAfterCurrent" = true;
                "browser.quitShortcut.disabled" = true;

                # Dev tools
                "devtools.debugger.remote-enabled" = true;
                "devtools.chrome.enabled" = true;
                "devtools.inspector.three-pane-enabled" = false;

                # Attempt to make addons work in restricted domains
                "extensions.webextensions.restrictedDomains" = "";
                "extensions.quarantinedDomains.enabled" = false;
                "privacy.resistFingerprinting.block_mozAddonManager" = true;

                # Right click menu
                "browser.ml.linkPreview.enabled" = false;
                "devtools.accessibility.enabled" = false;
                "extensions.formautofill.creditCards.enabled" = false;
                "privacy.query_stripping.strip_on_share.enabled" = false;
                "browser.ml.chat.enabled" = false;
                "browser.ml.chat.menu" = false;
                "browser.search.visualSearch.featureGate" = false;
                "browser.tabs.splitView.enabled" = false;

                # Zen Browser specific options:
                "zen.theme.content-element-separation" = 0; # disable border around zen window
                "zen.tabs.close-on-back-with-no-history" = false;
                "zen.urlbar.replace-newtab" = false;
                "zen.welcome-screen.seen" = true;

                # Temp preferences
                "browser.settings-redesign.enabled" = true;
              };
            };
            secondary = {
              id = 1;
              name = "Secondary";
              path = "o9fiaukr.2nd Profile";
              settings."zen.welcome-screen.seen" = true;
            };
          };
          nativeMessagingHosts = [ pkgs.firefoxpwa ];
        };
        programs.thunderbird = {
          enable = false;
          profiles."dexxqztk.Default User" = {
            isDefault = true;
            settings = {
              "mail.minimizeToTray.startMinimized" = true;
              "mail.biff.show_tray_icon_always" = true;
              "mail.minimizeToTray.supportedDesktops" = "kde,gnome,pop:gnome,xfce,mate,hyprland";
            };
          };
        };
      };
  };
}
