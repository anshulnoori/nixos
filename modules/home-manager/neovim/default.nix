{
  pkgs,
  lib,
  ...
}: {
  stylix.targets.nixvim.enable = true;

  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      smartindent = true;
      scrolloff = 8;
      sidescrolloff = 8;
      updatetime = 50;
      timeoutlen = 300;
      clipboard = "unnamedplus";
      undofile = true;
      hlsearch = false;
      incsearch = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      cursorline = true;
      termguicolors = true;
      splitbelow = true;
      splitright = true;
      wrap = false;
      conceallevel = 1;
      pumheight = 10;
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99;
      showmode = false;
      laststatus = 3;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [];

    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix lua python rust typescript javascript tsx
          java cpp c
          markdown markdown_inline
          bash fish
          json json5 yaml toml
          html css scss
          sql dockerfile
          graphql proto
          regex query
          vim vimdoc
          gitcommit gitignore diff
        ];
      };

      treesitter-textobjects.enable = true;

      # https://github.com/nix-community/nixvim
      # All servers use package = lib.mkForce null — binary must come from devShell.
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;

          lua_ls = {
            enable = true;
            settings.Lua.diagnostics.globals = ["vim"];
          };

          # ty is configured via extraConfigLua below (not yet a named nixvim server).
          ruff = {
            enable = true;
            package = lib.mkForce null;
          };

          rust_analyzer = {
            enable = true;
            package = lib.mkForce null;
            installCargo = false;
            installRustc = false;
            settings = {
              "rust-analyzer.cargo.extraEnv" = {
                CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = "clang";
                CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS = "-C link-arg=-fuse-ld=mold";
              };
              "rust-analyzer.check.command" = "clippy";
              "rust-analyzer.check.extraArgs" = ["--" "-W" "clippy::all"];
              "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
              "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "always";
            };
          };

          ts_ls = {
            enable = true;
            package = lib.mkForce null;
          };

          jdtls = {
            enable = true;
            package = lib.mkForce null;
          };

          clangd = {
            enable = true;
            package = lib.mkForce null;
          };
        };
      };

      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "super-tab";
          appearance.use_nvim_cmp_as_default = true;
          sources.default = ["lsp" "path" "buffer" "snippets" "emoji"];
          signature.enabled = true;
          completion = {
            documentation.auto_show = true;
            menu.draw.treesitter = ["lsp"];
          };
        };
      };

      blink-emoji.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 2000;
            lsp_format = "fallback";
          };
          formatters_by_ft = {
            python     = ["ruff_format" "ruff_organize_imports"];
            rust       = ["rustfmt"];
            javascript = {__unkeyed-1 = "biome"; __unkeyed-2 = "prettier"; stop_after_first = true;};
            typescript = {__unkeyed-1 = "biome"; __unkeyed-2 = "prettier"; stop_after_first = true;};
            tsx        = {__unkeyed-1 = "biome"; __unkeyed-2 = "prettier"; stop_after_first = true;};
            jsx        = {__unkeyed-1 = "biome"; __unkeyed-2 = "prettier"; stop_after_first = true;};
            json       = {__unkeyed-1 = "biome"; __unkeyed-2 = "prettier"; stop_after_first = true;};
            nix        = ["alejandra"];
            lua        = ["stylua"];
            c          = ["clang_format"];
            cpp        = ["clang_format"];
            sh         = ["shfmt"];
            bash       = ["shfmt"];
            markdown   = ["prettier"];
            yaml       = ["prettier"];
            css        = ["prettier"];
            html       = ["prettier"];
          };
          formatters.shfmt.prepend_args = ["-i" "2" "-ci"];
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          python = ["ruff"];
          nix    = ["nix"];
          sh     = ["shellcheck"];
          bash   = ["shellcheck"];
        };
      };

      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          focus = true;
          modes = {
            diagnostics.auto_open = false;
          };
        };
      };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text          = "▎";
          change.text       = "▎";
          delete.text       = "";
          topdelete.text    = "";
          changedelete.text = "▎";
          untracked.text    = "▎";
        };
      };

      diffview.enable = true;
      fugitive.enable = true;

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "auto";
            component_separators = {left = ""; right = "";};
            section_separators   = {left = ""; right = "";};
            globalstatus = true;
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = [{__unkeyed-1 = "filename"; path = 1;}];
            lualine_x = ["filetype"];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };

      which-key = {
        enable = true;
        settings.delay = 300;
      };

      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment.enable = true;

      todo-comments = {
        enable = true;
        settings.signs = true;
      };

      flash.enable = true;

      render-markdown = {
        enable = true;
        settings = {
          enabled = true;
          file_types = ["markdown"];
        };
      };

      fzf-lua.enable = true;
      web-devicons.enable = true;
    };

    # https://github.com/folke/snacks.nvim — not yet in nixvim module system
    extraPlugins = with pkgs.vimPlugins; [
      snacks-nvim
    ];

    extraConfigLua = ''
      -- https://github.com/astral-sh/ty — Python type-checker / LSP
      -- Not yet a named server in nixvim; configured via the Neovim ≥0.11 vim.lsp API.
      vim.lsp.config('ty', {
        cmd          = { 'ty', 'server' },
        filetypes    = { 'python' },
        root_markers = { 'pyproject.toml', 'uv.lock', 'setup.py', '.git' },
        settings     = {},
      })
      vim.lsp.enable('ty')

      require("snacks").setup({
        dashboard = {
          enabled = true,
          preset = {
            header = [[
       ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
       ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
       ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
       ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
       ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝]],
            keys = {
              { icon = " ", key = "f", desc = "Find File",  action = function() Snacks.picker.files() end },
              { icon = " ", key = "g", desc = "Find Text",  action = function() Snacks.picker.grep() end },
              { icon = " ", key = "r", desc = "Recent",     action = function() Snacks.picker.recent() end },
              { icon = " ", key = "e", desc = "Explorer",   action = function() Snacks.explorer() end },
              { icon = " ", key = "l", desc = "Lazygit",    action = function() Snacks.lazygit() end },
              { icon = " ", key = "q", desc = "Quit",       action = ":qa" },
            },
          },
        },
        picker    = { enabled = true, layout = { preset = "ivy" } },
        explorer  = { enabled = true },
        notifier  = { enabled = true, timeout = 3000, style = "compact" },
        lazygit   = { enabled = true },
        image     = { enabled = true },
        terminal  = { enabled = true, win = { position = "bottom", height = 0.35 } },
        bufdelete = { enabled = true },
        words     = { enabled = true },
        scroll    = { enabled = true },
        statuscolumn = {
          enabled = true,
          left  = { "mark", "sign" },
          right = { "fold", "git" },
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
          },
        },
        float = { border = "rounded", source = true },
      })

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          local ok, lint = pcall(require, "lint")
          if ok then lint.try_lint() end
        end,
      })

      -- https://dystroy.org/bacon/
      -- Run :terminal bacon in a split; errors surface via rust-analyzer diagnostics.

      -- https://github.com/mikaelmello/99.nvim — not yet in nixpkgs
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local ok, _99 = pcall(require, "99")
          if not ok then return end
          _99.setup({
            tmp_dir = "./tmp",
            md_files = { "AGENT.md" },
            completion = { source = "blink" },
          })
        end,
      })
    '';

    extraPackages = with pkgs; [
      nil
      alejandra

      lua-language-server
      stylua

      shfmt
      shellcheck

      git
      ripgrep
      fd
      lazygit

      uv
      ruff
      ty

      nodePackages.prettier

      # https://dystroy.org/bacon/
      bacon

      mold
    ];
  };
}
