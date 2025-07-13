---@module 'lazy'
---@type LazySpec
return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'saghen/blink.cmp',
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<C-l>',
            next = '<C-n>',
            prev = '<C-p>',
            dismiss = '<C-e>',
          },
        },
        panel = {
          enabled = false,
        },
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim',
    },
    opts = {
      display = {
        action_palette = {
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'snacks',
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      prompt_library = {
        ['Generate a Commit Message'] = {
          strategy = 'chat',
          description = 'Generate a commit message',
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = 'commit',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                return string.format(
                  [[You are an expert at following the Conventional Commit specification.
Use the @{cmd_runner} tool to git commit the **staged** changes after generating the message.

Given the git diff listed below, please generate a commit message for me:
```diff
%s
```

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

```
%s
```

Output only the commit message without any explanations and follow-up suggestions.
]],
                  vim.fn.system('git diff --no-ext-diff --staged'),
                  vim.fn.system('git log --pretty=format:"%s" -n 20')
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle Chat' },
      { '<leader>ap', '<cmd>CodeCompanionActions<cr>', desc = 'Action Palette' },
      { '<leader>ac', '<cmd>CodeCompanion /commit<cr>', desc = 'Prompt: commit' },
    },
  },
}
