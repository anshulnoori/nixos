{config, ...}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;
in {
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = true;
      selection_wrap = true;
      theme = "default";
      additional_theme_location = "${config.home.homeDirectory}/.local/share/walker/themes/";
      hide_action_hints = true;

      placeholders."default" = {
        input = " Search...";
        list = "No Results";
      };

      keybinds.quick_activate = [];

      columns.symbols = 1;

      providers = {
        max_results = 256;
        "default" = ["desktopapplications" "websearch"];
        prefixes = [
          {
            prefix = "/";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "symbols";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = "$";
            provider = "clipboard";
          }
        ];
      };
    };
  };

  home.file.".local/share/walker/themes/default/style.css".text = ''
    @define-color selected-text #${c.base0D};
    @define-color text #${c.base05};
    @define-color base #${c.base00};
    @define-color border #${c.base05};
    @define-color foreground #${c.base05};
    @define-color background #${c.base00};

    * {
      font-family: '${font}';
      font-size: 18px;
    }

    .box-wrapper {
      background: alpha(@base, 0.95);
      padding: 20px;
      border: 2px solid @border;
      border-radius: 0;
    }

    .search-container {
      background: @base;
      padding: 10px;
    }

    child:selected .item-box * {
      color: @selected-text;
    }

    .item-box {
      padding-left: 14px;
    }

    .item-text-box {
      padding: 14px 0;
    }

    .item-subtext {
      font-size: 0;
    }

    .item-image {
      margin-right: 14px;
      -gtk-icon-size: 32px;
    }

    entry {
      color: @text;
      caret-color: @selected-text;
    }

    entry placeholder {
      color: alpha(@text, 0.5);
    }
  '';

  home.file.".local/share/walker/themes/default/layout.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkBox" id="BoxWrapper">
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkBox" id="SearchContainer">
            <style><class name="search-container"/></style>
            <child>
              <object class="GtkEntry" id="Input">
                <property name="hexpand">true</property>
              </object>
            </child>
          </object>
        </child>
        <child>
          <object class="GtkScrolledWindow" id="Scroll">
            <property name="propagate-natural-height">true</property>
            <property name="max-content-height">300</property>
            <child>
              <object class="GtkGridView" id="List">
                <property name="max-columns">1</property>
              </object>
            </child>
          </object>
        </child>
      </object>
    </interface>
  '';
}
