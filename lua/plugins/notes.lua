return {
  {
    'backdround/global-note.nvim',
    config = function()
      local get_project_name = function()
        local result = vim
          .system({
            'git',
            'rev-parse',
            '--show-toplevel',
          }, {
            text = true,
          })
          :wait()

        if result.stderr ~= '' then
          vim.notify(result.stderr, vim.log.levels.WARN)
          return nil
        end

        local project_directory = result.stdout:gsub('\n', '')

        local project_name = vim.fs.basename(project_directory)
        if project_name == nil then
          vim.notify('Unable to get the project name', vim.log.levels.WARN)
          return nil
        end

        return project_name
      end

      local get_git_branch = function()
        local result = vim
          .system({
            'git',
            'symbolic-ref',
            '--short',
            'HEAD',
          }, {
            text = true,
          })
          :wait()

        if result.stderr ~= '' then
          vim.notify(result.stderr, vim.log.levels.WARN)
          return nil
        end

        return result.stdout:gsub('\n', '')
      end

      local global_note = require 'global-note'
      global_note.setup {
        additional_presets = {
          git_branch_local = {
            command_name = 'GitBranchNote',

            directory = function()
              return vim.fn.stdpath 'data' .. '/global-note/' .. get_project_name()
            end,

            filename = function()
              local git_branch = get_git_branch()
              if git_branch == nil then
                return nil
              end
              return get_git_branch():gsub('[^%w-]', '-') .. '.md'
            end,

            title = get_git_branch,
          },
          project_local = {
            command_name = 'ProjectNote',

            filename = function()
              return get_project_name() .. '.md'
            end,

            title = 'Project note',
          },
        },
      }
    end,
    keys = {
      {
        '<leader>nb',
        function()
          local global_note = require 'global-note'
          global_note.toggle_note 'git_branch_local'
        end,
        desc = 'Toggle [N]otes [B]ranch',
      },
      {
        '<leader>np',
        function()
          local global_note = require 'global-note'
          global_note.toggle_note 'project_local'
        end,
        desc = 'Toggle [N]otes [P]roject',
      },
    },
  },
}
