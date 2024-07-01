local привет = function(a)
  return a
end

print {
  id = 16,
  jsonrpc = '2.0',
  method = 'textDocument/codeAction',
  params = {
    context = {
      diagnostics = {
        {
          message = 'staticcheck: SA9003: empty branch',
          range = {
            ['end'] = { character = 1, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'staticcheck',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 12, line = 7 },
            start = { character = 4, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          code = 'default',
          message = 'empty branch',
          range = {
            ['end'] = { character = 14, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'SA9003',
        },
      },
      triggerKind = 1,
    },
    range = { ['end'] = { character = 7, line = 7 }, start = '' },
    textDocument = { uri = 'file:///Users/quolpr/.config/nvim/m.go' },
  },
}

-- onDiagnostic:
print {
  {
    {
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 25, line = 7 },
            start = { character = 21, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'ferferf' },
          message = '"ferferf": Unknown word.',
          range = {
            ['end'] = { character = 39, line = 7 },
            start = { character = 32, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 9, line = 14 },
            start = { character = 5, line = 14 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'пупкк' },
          message = '"пупкк": Unknown word.',
          range = {
            ['end'] = { character = 31, line = 14 },
            start = { character = 26, line = 14 },
          },
          severity = 3,
          source = 'cSpell',
        },
      },
      uri = 'file:///Users/quolpr/.config/nvim/m.go',
      version = 0,
    },
  },
}
-- publishDiagnostics
print {
  diagnostics = {
    {
      code = 'BrokenImport',
      codeDescription = { href = 'https://pkg.go.dev/golang.org/x/tools/internal/typesinternal#BrokenImport' },
      message = 'could not import abc/go_test/abc (no required module provides package "abc/go_test/abc")',
      range = {
        ['end'] = { character = 18, line = 3 },
        start = { character = 1, line = 3 },
      },
      severity = 1,
      source = 'compiler',
    },
  },
  uri = 'file:///Users/quolpr/.config/nvim/go_test/abc/abc_test.go',
}

-- Что присылает cpsell в ответ на инициализацию сервера
print { id = 1, jsonrpc = '2.0', result = { capabilities = { textDocumentSync = { openClose = true, save = true } } } }
-- Что присылает gopls в ответ на инициализацию сервера
print {
  id = 1,
  jsonrpc = '2.0',
  result = {
    capabilities = {
      callHierarchyProvider = true,
      codeActionProvider = {
        codeActionKinds = { 'quickfix', 'refactor.extract', 'refactor.inline', 'refactor.rewrite', 'source.fixAll', 'source.organizeImports' },
        resolveProvider = true,
      },
      codeLensProvider = vim.empty_dict(),
      completionProvider = { triggerCharacters = { '.' } },
      definitionProvider = true,
      documentFormattingProvider = true,
      documentHighlightProvider = true,
      documentLinkProvider = vim.empty_dict(),
      documentSymbolProvider = true,
      executeCommandProvider = {
        commands = {
          'gopls.add_dependency',
          'gopls.add_import',
          'gopls.add_telemetry_counters',
          'gopls.apply_fix',
          'gopls.change_signature',
          'gopls.check_upgrades',
          'gopls.diagnose_files',
          'gopls.edit_go_directive',
          'gopls.fetch_vulncheck_result',
          'gopls.gc_details',
          'gopls.generate',
          'gopls.go_get_package',
          'gopls.list_imports',
          'gopls.list_known_packages',
          'gopls.maybe_prompt_for_telemetry',
          'gopls.mem_stats',
          'gopls.regenerate_cgo',
          'gopls.remove_dependency',
          'gopls.reset_go_mod_diagnostics',
          'gopls.run_go_work_command',
          'gopls.run_govulncheck',
          'gopls.run_tests',
          'gopls.start_debugging',
          'gopls.start_profile',
          'gopls.stop_profile',
          'gopls.test',
          'gopls.tidy',
          'gopls.toggle_gc_details',
          'gopls.update_go_sum',
          'gopls.upgrade_dependency',
          'gopls.vendor',
          'gopls.views',
          'gopls.workspace_stats',
        },
      },
      foldingRangeProvider = true,
      hoverProvider = true,
      implementationProvider = true,
      inlayHintProvider = vim.empty_dict(),
      referencesProvider = true,
      renameProvider = { prepareProvider = true },
      selectionRangeProvider = true,
      semanticTokensProvider = {
        full = true,
        legend = {
          tokenModifiers = {
            'declaration',
            'definition',
            'readonly',
            'static',
            'deprecated',
            'abstract',
            'async',
            'modification',
            'documentation',
            'defaultLibrary',
          },
          tokenTypes = {
            'namespace',
            'type',
            'class',
            'enum',
            'interface',
            'struct',
            'typeParameter',
            'parameter',
            'variable',
            'property',
            'enumMember',
            'event',
            'function',
            'method',
            'macro',
            'keyword',
            'modifier',
            'comment',
            'string',
            'number',
            'regexp',
            'operator',
            'decorator',
          },
        },
        range = true,
      },
      signatureHelpProvider = { triggerCharacters = { '(', ',' } },
      textDocumentSync = { change = 2, openClose = true, save = vim.empty_dict() },
      typeDefinitionProvider = true,
      workspace = { workspaceFolders = { changeNotifications = 'workspace/didChangeWorkspaceFolders', supported = true } },
      workspaceSymbolProvider = true,
    },
    serverInfo = {
      name = 'gopls',
      version = '{"GoVersion":"go1.22.1","Path":"golang.org/x/tools/gopls","Main":{"Path":"golang.org/x/tools/gopls","Version":"v0.15.3","Sum":"h1:zbdOidFrPTc8Bx0YrN5QKgJ0zCjyGi0L27sKQ/bDG5o=","Replace":null},"Deps":[{"Path":"github.com/BurntSushi/toml","Version":"v1.2.1","Sum":"h1:9F2/+DoOYIOksmaJFPw1tGFy1eDnIJXg+UHjuD8lTak=","Replace":null},{"Path":"github.com/google/go-cmp","Version":"v0.6.0","Sum":"h1:ofyhxvXcZhMsU5ulbFiLKl/XBFqE1GSq7atu8tAmTRI=","Replace":null},{"Path":"golang.org/x/exp/typeparams","Version":"v0.0.0-20221212164502-fae10dda9338","Sum":"h1:2O2DON6y3XMJiQRAS1UWU+54aec2uopH3x7MAiqGW6Y=","Replace":null},{"Path":"golang.org/x/mod","Version":"v0.15.0","Sum":"h1:SernR4v+D55NyBH2QiEQrlBAnj1ECL6AGrA5+dPaMY8=","Replace":null},{"Path":"golang.org/x/sync","Version":"v0.6.0","Sum":"h1:5BMeUDZ7vkXGfEr1x9B4bRcTH4lpkTkpdh0T/J+qjbQ=","Replace":null},{"Path":"golang.org/x/telemetry","Version":"v0.0.0-20240209200032-7b892fcb8a78","Sum":"h1:vcVnuftN4J4UKLRcgetjzfU9FjjgXUUYUc3JhFplgV4=","Replace":null},{"Path":"golang.org/x/text","Version":"v0.14.0","Sum":"h1:ScX5w1eTa3QqT8oi6+ziP7dTV1S2+ALU0bI+0zXKWiQ=","Replace":null},{"Path":"golang.org/x/tools","Version":"v0.18.1-0.20240412183611-d92ae0781217","Sum":"h1:uH9jJYgeLCvblH0S+03kFO0qUDxRkbLRLFiKVVDl7ak=","Replace":null},{"Path":"golang.org/x/vuln","Version":"v1.0.1","Sum":"h1:KUas02EjQK5LTuIx1OylBQdKKZ9jeugs+HiqO5HormU=","Replace":null},{"Path":"honnef.co/go/tools","Version":"v0.4.6","Sum":"h1:oFEHCKeID7to/3autwsWfnuv69j3NsfcXbvJKuIcep8=","Replace":null},{"Path":"mvdan.cc/gofumpt","Version":"v0.6.0","Sum":"h1:G3QvahNDmpD+Aek/bNOLrFR2XC6ZAdo62dZu65gmwGo=","Replace":null},{"Path":"mvdan.cc/xurls/v2","Version":"v2.5.0","Sum":"h1:lyBNOm8Wo71UknhUs4QTFUNNMyxy2JEIaKKo0RWOh+8=","Replace":null}],"Settings":[{"Key":"-buildmode","Value":"exe"},{"Key":"-compiler","Value":"gc"},{"Key":"DefaultGODEBUG","Value":"httplaxcontentlength=1,httpmuxgo121=1,panicnil=1,tls10server=1,tlsrsakex=1,tlsunsafeekm=1"},{"Key":"CGO_ENABLED","Value":"1"},{"Key":"CGO_CFLAGS","Value":""},{"Key":"CGO_CPPFLAGS","Value":""},{"Key":"CGO_CXXFLAGS","Value":""},{"Key":"CGO_LDFLAGS","Value":""},{"Key":"GOARCH","Value":"arm64"},{"Key":"GOOS","Value":"darwin"}],"Version":"v0.15.3"}',
    },
  },
}

print {
  id = 1,
  jsonrpc = '2.0',
  result = {
    capabilities = {
      codeActionProvider = { codeActionKinds = { '', 'quickfix', 'refactor.rewrite', 'refactor.extract' }, resolveProvider = false },
      codeLensProvider = { resolveProvider = true },
      colorProvider = true,
      completionProvider = {
        resolveProvider = true,
        triggerCharacters = { '\t', '\n', '.', ':', '(', "'", '"', '[', ',', '#', '*', '@', '|', '=', '-', '{', ' ', '+', '?' },
      },
      definitionProvider = true,
      documentFormattingProvider = true,
      documentHighlightProvider = true,
      documentOnTypeFormattingProvider = { firstTriggerCharacter = '\n' },
      documentRangeFormattingProvider = true,
      documentSymbolProvider = true,
      executeCommandProvider = {
        commands = { 'lua.removeSpace', 'lua.solve', 'lua.jsonToLua', 'lua.setConfig', 'lua.getConfig', 'lua.autoRequire' },
      },
      foldingRangeProvider = true,
      hoverProvider = true,
      implementationProvider = true,
      inlayHintProvider = { resolveProvider = true },
      offsetEncoding = 'utf-16',
      referencesProvider = true,
      renameProvider = { prepareProvider = true },
      semanticTokensProvider = {
        full = true,
        legend = {
          tokenModifiers = {
            'declaration',
            'definition',
            'readonly',
            'static',
            'deprecated',
            'abstract',
            'async',
            'modification',
            'documentation',
            'defaultLibrary',
            'global',
          },
          tokenTypes = {
            'namespace',
            'type',
            'class',
            'enum',
            'interface',
            'struct',
            'typeParameter',
            'parameter',
            'variable',
            'property',
            'enumMember',
            'event',
            'function',
            'method',
            'macro',
            'keyword',
            'modifier',
            'comment',
            'string',
            'number',
            'regexp',
            'operator',
            'decorator',
          },
        },
        range = true,
      },
      signatureHelpProvider = { triggerCharacters = { '(', ',' } },
      textDocumentSync = { change = 2, openClose = true, save = { includeText = false } },
      typeDefinitionProvider = true,
      workspace = {
        fileOperations = {
          didRename = {
            filters = {
              {
                pattern = {
                  glob = '/Users/quolpr/.config/nvim/**',
                  options = { ignoreCase = true },
                },
              },
            },
          },
        },
        workspaceFolders = { changeNotifications = true, supported = true },
      },
      workspaceSymbolProvider = true,
    },
    serverInfo = { name = 'sumneko.lua' },
  },
}

-- Ответ от cspell
print {
  jsonrpc = '2.0',
  method = '_onDiagnostics',
  params = {
    {
      {
        diagnostics = {
          {
            data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
            message = '"кыыы": Unknown word.',
            range = {
              ['end'] = { character = 25, line = 7 },
              start = { character = 21, line = 7 },
            },
            severity = 3,
            source = 'cSpell',
          },
          {
            data = { isFlagged = false, isKnown = false, strict = true, text = 'ferferf' },
            message = '"ferferf": Unknown word.',
            range = {
              ['end'] = { character = 39, line = 7 },
              start = { character = 32, line = 7 },
            },
            severity = 3,
            source = 'cSpell',
          },
          {
            data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
            message = '"кыыы": Unknown word.',
            range = {
              ['end'] = { character = 9, line = 14 },
              start = { character = 5, line = 14 },
            },
            severity = 3,
            source = 'cSpell',
          },
          {
            data = { isFlagged = false, isKnown = false, strict = true, text = 'пупкк' },
            message = '"пупкк": Unknown word.',
            range = {
              ['end'] = { character = 31, line = 14 },
              start = { character = 26, line = 14 },
            },
            severity = 3,
            source = 'cSpell',
          },
        },
        uri = 'file:///Users/quolpr/.config/nvim/m.go',
        version = 0,
      },
    },
  },
}
-- send to cspell + gopls:
print {
  id = 18,
  jsonrpc = '2.0',
  method = 'textDocument/codeAction',
  params = {
    context = {
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 35, line = 7 },
            start = { character = 27, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'ferferf' },
          message = '"ferferf": Unknown word.',
          range = {
            -- Здесь есть удвоение. При этом в редакторе на нужно мeсте отображается
            ['end'] = { character = 49, line = 7 },
            start = { character = 42, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          code = 'default',
          message = 'empty branch',
          range = {
            -- Здесь нет удвоения
            ['end'] = { character = 37, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'SA9003',
        },
        {
          code = 'cond',
          codeDescription = { href = 'https://pkg.go.dev/golang.org/x/tools/go/analysis/passes/nilness#cond' },
          message = 'tautological condition: non-nil != nil',
          range = {
            ['end'] = { character = 17, line = 7 },
            start = { character = 17, line = 7 },
          },
          severity = 2,
          source = 'nilness',
        },
        {
          message = 'staticcheck: SA9003: empty branch',
          range = {
            ['end'] = { character = 1, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'staticcheck',
        },
      },
    },
    range = { ['end'] = { character = 21, line = 7 }, start = '' },
    textDocument = { uri = 'file:///Users/quolpr/.config/nvim/m.go' },
  },
}

-- send to cspell:
print {
  id = 91,
  jsonrpc = '2.0',
  method = 'textDocument/codeAction',
  params = {
    context = {
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 35, line = 7 },
            start = { character = 27, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'ferferf' },
          message = '"ferferf": Unknown word.',
          range = {
            ['end'] = { character = 49, line = 7 },
            start = { character = 42, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
        {
          code = 'default',
          message = 'empty branch',
          range = {
            ['end'] = { character = 37, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'SA9003',
        },
        {
          code = 'cond',
          codeDescription = { href = 'https://pkg.go.dev/golang.org/x/tools/go/analysis/passes/nilness#cond' },
          message = 'tautological condition: non-nil != nil',
          range = {
            ['end'] = { character = 17, line = 7 },
            start = { character = 17, line = 7 },
          },
          severity = 2,
          source = 'nilness',
        },
        {
          message = 'staticcheck: SA9003: empty branch',
          range = {
            ['end'] = { character = 1, line = 7 },
            start = { character = 1, line = 7 },
          },
          severity = 2,
          source = 'staticcheck',
        },
      },
      triggerKind = 1,
    },
    range = { ['end'] = { character = 35, line = 7 }, start = '' },
    textDocument = { uri = 'file:///Users/quolpr/.config/nvim/m.go' },
  },
}

-- send to gopls:
print {
  id = 106,
  jsonrpc = '2.0',
  method = 'codeAction/resolve',
  params = {
    data = {
      arguments = {
        {
          Fix = 'inline_call',
          Range = {
            ['end'] = { character = 22, line = 7 },
            start = { character = 22, line = 7 },
          },
          ResolveEdits = true,
          URI = 'file:///Users/quolpr/.config/nvim/m.go',
        },
      },
      command = 'gopls.apply_fix',
      title = 'Inline call to кыыы',
    },
    kind = 'refactor.inline',
    title = 'Inline call to кыыы',
  },
}

print {
  id = 15,
  jsonrpc = '2.0',
  result = {
    {
      command = {
        arguments = {
          { ' { //fer' },
          'file:///Users/quolpr/.config/nvim/m.go',
          { name = 'nvim/cspell.json', uri = 'file:///Users/quolpr/.config/nvim/cspell.json' },
        },
        command = 'cSpell.addWordsToConfigFileFromServer',
        title = 'Add: " { //fer" to config: nvim/cspell.json',
      },
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 35, line = 7 },
            start = { character = 27, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
      },
      kind = 'quickfix',
      title = 'Add: " { //fer" to config: nvim/cspell.json',
    },
    {
      command = {
        arguments = {
          { ' { //fer' },
          'file:///Users/quolpr/.config/nvim/m.go',
          { name = 'nvim/cspell.json', uri = 'file:///Users/quolpr/.config/nvim/cspell.json' },
        },
        command = 'cSpell.addWordsToConfigFileFromServer',
        title = 'Add: " { //fer" to config: nvim/cspell.json',
      },
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 35, line = 7 },
            start = { character = 27, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
      },
      kind = 'quickfix',
      title = 'Add: " { //fer" to config: nvim/cspell.json',
    },
    {
      command = {
        arguments = { { ' { //fer' }, 'file:///Users/quolpr/.config/nvim/m.go', 'user' },
        command = 'cSpell.addWordsToVSCodeSettingsFromServer',
        title = 'Add: " { //fer" to user settings',
      },
      diagnostics = {
        {
          data = { isFlagged = false, isKnown = false, strict = true, text = 'кыыы' },
          message = '"кыыы": Unknown word.',
          range = {
            ['end'] = { character = 35, line = 7 },
            start = { character = 27, line = 7 },
          },
          severity = 3,
          source = 'cSpell',
        },
      },
      kind = 'quickfix',
      title = 'Add: " { //fer" to user settings',
    },
  },
}

print {
  id = 28,
  jsonrpc = '2.0',
  result = {
    data = {
      arguments = {
        {
          Fix = 'inline_call',
          Range = {
            ['end'] = { character = 21, line = 7 },
            start = { character = 21, line = 7 },
          },
          ResolveEdits = true,
          URI = 'file:///Users/quolpr/.config/nvim/m.go',
        },
      },
      command = 'gopls.apply_fix',
      title = 'Inline call to кыыы',
    },
    edit = {
      documentChanges = {
        {
          edits = {
            {
              newText = 'true',
              range = {
                ['end'] = { character = 27, line = 7 },
                start = { character = 21, line = 7 },
              },
            },
          },
          textDocument = { uri = 'file:///Users/quolpr/.config/nvim/m.go', version = 0 },
        },
      },
    },
    kind = 'refactor.inline',
    title = 'Inline call to кыыы',
  },
}
-- Проблема: diasnostic отсылается раздвоенным. В то время как ranges отправляется нормальным

-- hehhee
--
--
--
--
print {
  jsonrpc = '2.0',
  method = 'textDocument/publishDiagnostics',
  params = {
    diagnostics = {
      {
        code = 'unicode-name',
        data = 'syntax',
        message = 'Contains Unicode characters.',
        range = {
          ['end'] = { character = 12, line = 0 },
          start = { character = 6, line = 0 },
        },
        severity = 1,
        source = 'Lua Syntax Check.',
      },
      {
        code = 'unused-local',
        message = 'Unused local `привет`.',
        range = {
          ['end'] = { character = 12, line = 0 },
          start = { character = 6, line = 0 },
        },
        severity = 4,
        source = 'Lua Diagnostics.',
        tags = { 1 },
      },
      {
        code = 'unused-function',
        message = 'Unused functions.',
        range = {
          ['end'] = { character = 23, line = 0 },
          start = { character = 15, line = 0 },
        },
        severity = 4,
        source = 'Lua Diagnostics.',
        tags = { 1 },
      },
    },
    uri = 'file:///Users/quolpr/.config/nvim/my.lua',
    version = 17,
  },
}

print {
  id = 15,
  jsonrpc = '2.0',
  result = {
    {
      command = {
        arguments = {
          {
            action = 'add',
            key = 'Lua.diagnostics.disable',
            uri = 'file:///Users/quolpr/.config/nvim/my.lua',
            value = 'unused-function',
          },
        },
        command = 'lua.setConfig',
        title = 'Disable diagnostics',
      },
      kind = 'quickfix',
      title = 'Disable diagnostics in the workspace (unused-function).',
    },
    {
      edit = {
        changes = {
          ['file:///Users/quolpr/.config/nvim/my.lua'] = {
            {
              newText = '---@diagnostic disable-next-line: unused-function\n',
              range = {
                ['end'] = { character = 0, line = 0 },
                start = { character = 0, line = 0 },
              },
            },
          },
        },
      },
      kind = 'quickfix',
      title = 'Disable diagnostics on this line (unused-function).',
    },
    {
      edit = {
        changes = {
          ['file:///Users/quolpr/.config/nvim/my.lua'] = {
            {
              newText = '---@diagnostic disable: unused-function\n',
              range = {
                ['end'] = { character = 0, line = 0 },
                start = { character = 0, line = 0 },
              },
            },
          },
        },
      },
      kind = 'quickfix',
      title = 'Disable diagnostics in this file (unused-function).',
    },
    {
      command = {
        arguments = {
          {
            action = 'add',
            key = 'Lua.diagnostics.disable',
            uri = 'file:///Users/quolpr/.config/nvim/my.lua',
            value = 'unused-local',
          },
        },
        command = 'lua.setConfig',
        title = 'Disable diagnostics',
      },
      kind = 'quickfix',
      title = 'Disable diagnostics in the workspace (unused-local).',
    },
    {
      edit = {
        changes = {
          ['file:///Users/quolpr/.config/nvim/my.lua'] = {
            {
              newText = '---@diagnostic disable-next-line: unused-local\n',
              range = {
                ['end'] = { character = 0, line = 0 },
                start = { character = 0, line = 0 },
              },
            },
          },
        },
      },
      kind = 'quickfix',
      title = 'Disable diagnostics on this line (unused-local).',
    },
    {
      edit = {
        changes = {
          ['file:///Users/quolpr/.config/nvim/my.lua'] = {
            {
              newText = '---@diagnostic disable: unused-local\n',
              range = {
                ['end'] = { character = 0, line = 0 },
                start = { character = 0, line = 0 },
              },
            },
          },
        },
      },
      kind = 'quickfix',
      title = 'Disable diagnostics in this file (unused-local).',
    },
  },
}

--
