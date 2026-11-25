-- Filetype plugin for Java buffers.
-- Uses mfussenegger/nvim-jdtls to manage the Eclipse JDT Language Server lifecycle,
-- DAP (java-debug-adapter), test runner (java-test), and refactorings.

local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

-- Find project root directory
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir then
  root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()
end

local project_name = vim.fs.basename(root_dir)
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls/workspace/' .. project_name

local mason_path = vim.fn.stdpath 'data' .. '/mason'
local jdtls_path = mason_path .. '/packages/jdtls'

-- Launcher jar (wildcard to handle version upgrades)
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar', true)
if launcher_jar == '' then
  launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher.jar', true)
end

-- Configuration directory for Linux
local config_dir = jdtls_path .. '/config_linux'

-- Lombok jar
local lombok_jar = jdtls_path .. '/lombok.jar'

-- Build command
local cmd = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx2g',
  '--add-modules=ALL-SYSTEM',
  '--add-opens',
  'java.base/java.util=ALL-UNNAMED',
  '--add-opens',
  'java.base/java.lang=ALL-UNNAMED',
}

if vim.uv.fs_stat(lombok_jar) then
  table.insert(cmd, '-javaagent:' .. lombok_jar)
end

if launcher_jar ~= '' and vim.uv.fs_stat(config_dir) then
  vim.list_extend(cmd, {
    '-jar',
    launcher_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  })
else
  -- Fallback to mason bin executable if launcher jar is not found
  cmd = { 'jdtls', '-data', workspace_dir }
end

-- Collect bundles (java-debug-adapter and java-test)
local bundles = {}
local has_mason, mason_registry = pcall(require, 'mason-registry')
if has_mason then
  if mason_registry.is_installed 'java-debug-adapter' then
    local debug_path = mason_registry.get_package('java-debug-adapter'):get_install_path()
    local debug_jar = vim.fn.glob(debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true)
    if debug_jar ~= '' then
      table.insert(bundles, debug_jar)
    end
  end

  if mason_registry.is_installed 'java-test' then
    local test_path = mason_registry.get_package('java-test'):get_install_path()
    local test_jars = vim.split(vim.fn.glob(test_path .. '/extension/server/*.jar', true), '\n', { trimempty = true })
    vim.list_extend(bundles, test_jars)
  end
end

-- Extended client capabilities (supports decompile and class files)
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Completion capabilities via blink.cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.junit.Assert.*',
          'org.junit.Assume.*',
          'org.junit.jupiter.api.Assertions.*',
          'org.junit.jupiter.api.Assumptions.*',
          'org.junit.jupiter.api.DynamicContainer.*',
          'org.junit.jupiter.api.DynamicTest.*',
          'org.mockito.Mockito.*',
          'org.mockito.ArgumentMatchers.*',
          'org.mockito.Answers.*',
        },
        importOrder = {
          'java',
          'javax',
          'com',
          'org',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Enable DAP support
    local dap_ok, jdtls_dap = pcall(require, 'jdtls.dap')
    if dap_ok and #bundles > 0 then
      jdtls.setup_dap { hotcodereplace = 'auto' }
      jdtls_dap.setup_dap_main_class_configs()
    end
  end,
}

-- Register LspAttach hook for DAP configuration when jdtls attaches
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd('LspAttach', {
  buffer = bufnr,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == 'jdtls' then
      local dap_ok, jdtls_dap = pcall(require, 'jdtls.dap')
      if dap_ok and #bundles > 0 then
        jdtls.setup_dap { hotcodereplace = 'auto' }
        jdtls_dap.setup_dap_main_class_configs()
      end
    end
  end,
})

-- Java buffer-local refactoring and test keymaps
local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Java: ' .. desc })
end

map('<leader>jo', jdtls.organize_imports, '[O]rganize Imports')
map('<leader>jv', jdtls.extract_variable, 'Extract [V]ariable')
map('<leader>jv', function() jdtls.extract_variable(true) end, 'Extract [V]ariable', 'v')
map('<leader>jc', jdtls.extract_constant, 'Extract [C]onstant')
map('<leader>jc', function() jdtls.extract_constant(true) end, 'Extract [C]onstant', 'v')
map('<leader>jm', function() jdtls.extract_method(true) end, 'Extract [M]ethod', 'v')
map('<leader>jt', jdtls.test_class, '[T]est Class')
map('<leader>jn', jdtls.test_nearest_method, 'Test [N]earest Method')

jdtls.start_or_attach(config)
