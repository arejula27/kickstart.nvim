return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'BufReadPre ' .. vim.fn.expand '~' .. '/obsidian/**.md',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see below for full list of optional dependencies 👇
  },
  config = function()
    require('which-key').register {
      ['<leader>o'] = { name = '[O]bsidian', _ = 'which_key_ignore' },
    }
    local obsidian = require 'obsidian'
    obsidian.setup {
      disable_frontmatter = true,
      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        note:add_alias(note.id)

        local out = { aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      ui = {
        enable = true,
      },
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/obsidian/main',
        },
      },
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        substitutions = {
          yesterday = function()
            return os.date('%Y-%m-%d', os.time() - 86400)
          end,
          tomorrow = function()
            return os.date('%Y-%m-%d', os.time() + 86400)
          end,
        },
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = 'journal',
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = '%Y-%m-%d',
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = '%Y-%m-%d',
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = 'Daily-nvim.md',
      },
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return 'Note-' .. suffix
      end,
      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ['<leader>oc'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = '[O]bsidian toggle [C]heckbox' },
        },
        ['<leader>os'] = { action = '<cmd>ObsidianQuickSwitch<cr>', opts = { buffer = true, desc = '[O]bsidian quick [S]witch' } },
        ['<leader>og'] = { action = '<cmd>ObsidianSearch<cr>', opts = { buffer = true, desc = '[O]bsidian search [G]rep' } },
        ['<leader>ot'] = { action = '<cmd>ObsidianTags<cr>', opts = { buffer = true, desc = '[O]bsidian [T]ags' } },
        ['<leader>od'] = { action = '<cmd>ObsidianToday<cr>', opts = { buffer = true, desc = '[O]bsidian today [D]aily note' } },
        ['<leader>on'] = { action = '<cmd>ObsidianNew<cr>', opts = { buffer = true, desc = '[O]bsidian [N]ew note' } },
      },

      -- see below for full list of options 👇
    }
  end,
}
