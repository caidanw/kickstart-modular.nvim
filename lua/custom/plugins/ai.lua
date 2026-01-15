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
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = false,
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-e>',
        },
      },
      panel = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      -- Explicitly set this keymap to skip the pass through of <C-l> that the copilot plugin does
      vim.keymap.set('i', '<C-l>', function()
        require('copilot.suggestion').accept()
      end, { silent = true })

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
      'franco-ruggeri/codecompanion-spinner.nvim',
      'ravitemer/codecompanion-history.nvim',
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
      interactions = {
        chat = {
          keymaps = {
            close = {
              modes = {
                n = 'gX',
              },
              index = 4,
              callback = 'keymaps.close',
              description = 'Close Chat',
            },
            stop = {
              modes = {
                n = '<C-c>',
                i = '<C-c>',
              },
              index = 5,
              callback = 'keymaps.stop',
              description = 'Stop Request',
            },
          },
          tools = {
            ['git_commit'] = {
              description = 'Commit staged changes with a message from the LLM',
              opts = { require_approval_before = false },
              callback = {
                name = 'git_commit',
                cmds = {
                  function(self, args)
                    local msg = args.message
                    if not msg or msg == '' then
                      return { status = 'error', data = 'A commit message is required.' }
                    end
                    msg = msg:gsub("'", "'\\''")
                    local cmd = string.format("git diff --cached --quiet || git commit -m '%s'", msg)
                    local result = vim.fn.system(cmd)
                    if vim.v.shell_error == 0 then
                      return { status = 'success', data = 'Committed: ' .. msg }
                    else
                      return { status = 'error', data = 'No staged changes or commit failed: ' .. result }
                    end
                  end,
                },
                schema = {
                  type = 'function',
                  ['function'] = {
                    name = 'git_commit',
                    description = 'Commit staged changes with a message',
                    parameters = {
                      type = 'object',
                      properties = {
                        message = {
                          type = 'string',
                          description = 'The commit message to use',
                        },
                      },
                      required = { 'message' },
                      additionalProperties = false,
                    },
                    strict = true,
                  },
                },
                system_prompt = [[
## Git Commit Tool (`git_commit`)
- Commits staged changes in the current repository with a message provided by the LLM.
- Does nothing if there are no staged changes.
- Requires a 'message' argument.
]],
                output = {
                  success = function(self, agent, cmd, stdout)
                    agent.chat:add_tool_output(self, stdout[1] or 'Commit succeeded.')
                  end,
                  error = function(self, agent, cmd, stderr)
                    agent.chat:add_tool_output(self, stderr[1] or 'No staged changes to commit or commit failed.')
                  end,
                },
              },
            },
          },
        },
      },
      extensions = {
        spinner = {},
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        history = {
          enabled = true,
          opts = {
            auto_save = false,
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = true,
            chat_filter = function(chat_data)
              return chat_data.cwd == vim.fn.getcwd()
            end,
          },
        },
      },
      prompt_library = {
        ['Git commit'] = {
          description = 'Generate and commit with custom git_commit tool',
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            alias = 'gc',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              opts = {
                contains_code = true,
                ignore_system_prompt = true,
              },
              references = {
                {
                  type = 'url',
                  url = 'https://www.conventionalcommits.org/en/v1.0.0/',
                },
              },
              content = function()
                return string.format(
                  [[
You are an expert at following the Conventional Commit specification.

Given the git diff listed below, please generate a commit message for me:

```diff
%s
```

When unsure about the context to use in the commit message, you can refer to the previous commit messages in this repository:

```
%s
```

Use the generated commit message as the message arg to call the @{git_commit} tool to commit the staged changes.
Do not ask for confirmation or approval, just commit the changes directly.
]],
                  vim.fn.system('git diff --no-ext-diff --staged'),
                  vim.fn.system('git log --pretty=format:"%s" -n 10')
                )
              end,
            },
          },
        },
      },
    },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle Chat', mode = { 'n', 'v' } },
      { 'q', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle Chat', ft = 'codecompanion' },
      { '<leader>ap', '<cmd>CodeCompanionActions<cr>', desc = 'Action Palette', mode = { 'n', 'v' } },
      { '<leader>ac', '<cmd>CodeCompanion /gc<cr>', desc = 'Prompt: git commit' },
      { '<leader>as', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to Chat', mode = { 'v' } },
    },
  },
}
