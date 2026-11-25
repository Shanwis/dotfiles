# Neovim Configuration

A modular, keyboard-driven Neovim setup that covers the core of what an IDE does —
code intelligence, autocompletion, a file tree, formatting, linting, debugging and
test running — without leaving the terminal. Everything is fast (lazy-loaded),
discoverable (which-key + dashboard) and readable (one file per feature area).

Built on: **lazy.nvim** (plugin management), **LSP** (code intelligence),
**tree-sitter** (syntax parsing), **blink.cmp** (completion), **Telescope**
(fuzzy finding) and **snacks.nvim** (start screen).

---

## Requirements

| Tool | Why it is needed |
|---|---|
| Neovim ≥ 0.12 | `vim.lsp.config`, modern tree-sitter API |
| A [Nerd Font](https://www.nerdfonts.com/) | icons in the tree, statusline and completion menu |
| `git` | plugin installation |
| `node` | pyright and other JS-based language servers |
| `make` | builds telescope's C matcher and LuaSnip's regex engine |
| `cargo-nextest` | runs Rust tests (the Rust test adapter requires it) |
| `java` (JDK ≥ 17) | Eclipse JDTLS runtime and Java compilation (JDK 21/25 supported) |
| `mvn` / `gradle` | builds Java projects and resolves dependencies |
| Your language toolchains | `python`, `go`, `cargo`, `java`, a C compiler — as needed |

Everything else (language servers, formatters, linters, debug adapters) is
installed automatically by Mason on first launch.

---

## Installation

```sh
git clone <this-repo> ~/.config/nvim   # or symlink this directory
nvim
```

First launch: lazy.nvim bootstraps itself, installs all plugins, Mason installs
the tooling, and tree-sitter installs parsers. Open the dashboard, press `f`,
start working.

---

## Project Layout

```
init.lua                  Entry point: core settings, lazy.nvim bootstrap
lazy-lock.json            Exact plugin versions (managed by lazy.nvim)
ftplugin/
  java.lua                Buffer-local Java setup: JDTLS, DAP bundles, test runner, keymaps
lua/
  config/
    options.lua           Editor behavior: numbers, search, clipboard, diagnostics
    keymaps.lua           Global keymaps: windows, search, quickfix, terminal
    autocmds.lua          Autocommands: yank highlight
  plugins/                One file per feature area; each returns lazy.nvim specs
    dashboard.lua         Start screen (snacks.nvim dashboard)
    ui.lua                Colorscheme, icons, which-key, todo-comments
    editor.lua            Indent detection, text objects, surrounds, pairs, statusline
    git.lua               Git signs and hunk operations (gitsigns)
    tree.lua              File tree (nvim-tree)
    telescope.lua         Fuzzy finding (files, grep, symbols, help)
    lsp.lua               Language servers and code intelligence (mason + lspconfig)
    java.lua              Java language support spec (nvim-jdtls)
    completion.lua        Autocompletion and snippets (blink.cmp + LuaSnip)
    treesitter.lua        Syntax parsing, highlighting, indentation
    format.lua            Format on save (conform)
    lint.lua              Inline lint diagnostics (nvim-lint)
    debug.lua             Debugging (nvim-dap + UI)
    test.lua              Test runner (neotest)
```

**Reading order:** `init.lua` → `lua/config/` top to bottom → any
`lua/plugins/` file. Each plugin file is self-contained: spec, setup and
keymaps live together.

---

## How It Works

### Plugin management — lazy.nvim

Each `lua/plugins/*.lua` returns a list of *specs* (declarative plugin
descriptions). lazy.nvim installs them into `~/.local/share/nvim/lazy/` and
loads each one only when needed — on an event (`BufReadPre`, `InsertEnter`),
a command (`:NvimTreeToggle`), or a keypress (`<leader>sf`). That is why
startup stays fast no matter how many plugins are added.

- `:Lazy` — plugin manager UI (update, profile, lock, clean)
- `:Lazy check` — see available updates
- `lazy-lock.json` — pin file; commit it for reproducible setups

### Startup flow

1. `init.lua` sets leader (Space), loads `config.options/keymaps/autocmds`
2. lazy.nvim bootstraps and loads the specs
3. `snacks.nvim` draws the dashboard (banner, one-key menu, startup stats)
4. Opening a file triggers the event-loaded plugins: LSP, treesitter,
   formatting, linting, git signs

---

## Features — what and why

### Start screen (snacks.nvim dashboard)

**What:** A landing page with a banner, single-key shortcuts (`f` find file,
`g` grep, `r` recent files, `n` new file, `c` config, `L` Lazy, `q` quit) and
a footer with plugin count and startup time.
**Why:** The empty buffer is wasted space; a dashboard orients you the second
Neovim opens and makes the most common actions one keypress away — no commands
to remember.

### Colorscheme (tokyonight) + devicons

**What:** A dark, high-contrast theme with file-type icons everywhere.
**Why:** Consistent visual hierarchy — code, errors, git signs and UI all share
one palette, so your eye spots diffs and diagnostics by color alone.

### which-key

**What:** A popup that appears after any incomplete keypress (e.g. `<leader>`)
listing every valid continuation with a description.
**Why:** It makes the keymap self-documenting. You never have to memorize the
config — press Space and read the menu.

### Editing core (mini.nvim + guess-indent)

| Piece | What it does | Why it helps |
|---|---|---|
| `mini.ai` | Richer text objects (`va)` select around parens, `ci'` change inside quotes) | Editing *structures* instead of characters is the biggest speed-up in modal editing |
| `mini.surround` | `saiw)` wrap word in parens, `sd'` delete quotes, `sr)'` replace | Correcting delimiters is a one-keystroke operation |
| `mini.pairs` | Auto-closes brackets and quotes | Fewer mismatched-delimiter bugs |
| `mini.statusline` | Mode, file, git, `line:col` in the bottom bar | Always know where you are |
| `guess-indent` | Detects tabs vs. spaces per file | Never fight a file's existing style |

### File tree (nvim-tree) — `<leader>e`

**What:** A sidebar showing the project's folder structure with git status and
file icons; `<leader>E` jumps to the current file in it.
**Why:** Projects are trees, not flat lists. Seeing where a file lives — and
sibling files you did not know to search for — is how you build a mental map
of an unfamiliar codebase.

### Fuzzy finding (Telescope) — `<leader>s…`

**What:** Instantly filter files, text, symbols, help and more by typing a few
fuzzy letters (`<leader>sf` files, `<leader>sg` project grep, `<leader><leader>`
buffers, `<leader>sh` help…).
**Why:** The fastest way to move around: you never navigate *to* a file, you
just type fragments of its name. Grep across the project the same way —
no `cd`, no `find | xargs grep`.

### Code intelligence (LSP) — `gr…`, `K`

**What:** Language servers (pyright, rust-analyzer, gopls, clangd, bashls,
lua_ls, jdtls) that understand your whole project. Go to definition (`grd`), find
references (`grr`), rename everywhere (`grn`), code actions (`gra` — quick
fixes, imports), hover docs (`K`), type definitions (`grt`), symbol search
(`gO` file, `gW` workspace). Java also includes full decompilation of `.class`
files (Fernflower), import organization, and refactorings via `nvim-jdtls`.
Errors/warnings appear inline as you type and `[d` / `]d` walk through them.
**Why:** This is the core of "IDE": the editor answers *what is this?*,
*where is it used?* and *what is wrong?* instantly. Renaming a function across
50 files is one keypress with zero risk of missing an occurrence.

### Autocompletion (blink.cmp + LuaSnip)

**What:** A completion menu fed by the LSP (words, methods, types), file paths
and snippets. `<C-n>/<C-p>` select, `<C-y>` accept (auto-imports when needed),
`<C-space>` item docs, `<C-k>` signature help. Snippets expand with `<Tab>`
jumping between placeholders.
**Why:** Fewer keystrokes and fewer typos, but more importantly *discoverability*
— browsing completion candidates teaches you the API of the library you are
using without leaving the buffer.

### Syntax parsing (tree-sitter)

**What:** Parses code into an accurate syntax tree — precise highlighting,
indentation and the structure that text objects and folds rely on. Parsers for
all common languages install themselves automatically the first time you open
a file.
**Why:** Regex-based highlighting breaks on nested strings, macros and
generics; tree-sitter never does. It is the foundation the rest of the editing
features stand on.

### Format on save (conform) — `<leader>f`

**What:** Formats every save with the language's standard tool (stylua, ruff,
rustfmt, goimports+gofumpt, clang-format, shfmt, google-java-format), falling back to LSP
formatting. Also works on visual selections.
**Why:** Code style stops being a review topic. Consistent formatting also
makes diffs meaningful — only real changes show up.

### Linting (nvim-lint)

**What:** Runs ruff (Python) and shellcheck (shell) as you edit and on save,
surfacing problems as diagnostics alongside LSP ones.
**Why:** Catches bugs before runtime — unused imports, risky shell patterns —
in the same gutter/sign UI you already watch.

### Git integration (gitsigns) — `]h`, `<leader>h…`

**What:** Change markers in the gutter; jump between hunks (`]h`/`[h`), stage
or reset a hunk (`<leader>hs`/`hr`, visual mode for part of one), preview
(`hp`), blame (`hb`), diff (`hd`).
**Why:** You see what you changed *while* you edit, and stage at hunk
granularity — the workflow that keeps commits clean and reviewable.

### Debugging (nvim-dap + UI) — `<leader>d…`

**What:** Real debuggers via the Debug Adapter Protocol: breakpoints (`db`),
conditional breakpoints (`dB`), continue (`dc`), step over/into/out
(`do`/`di`/`dO`), a UI with variables/watches/stack/REPL that opens
automatically (`du` toggles). Python, Go, C/C++, Rust and Java are wired up.
**Why:** When "read the code" fails, stepping through the actual runtime with
live values is the shortest path to the answer. It also pairs with tests:
debug the failing test at the exact failing line.

### Test runner (neotest) — `<leader>T…`

**What:** Runs tests in-process and shows a result tree: nearest test (`Tn`),
file (`Tf`), all (`Ta`), debug nearest (`Td`), summary (`Ts`), output panel
(`To`). Supports pytest, `go test`, `cargo nextest` and JUnit (via neotest-java).
**Why:** The feedback loop — edit, run *the* test you care about, see the
failure output — without leaving the editor or re-running a whole suite.

---

## Keymap Reference

Leader is **Space**. Press it and wait for which-key to show the live menu.

### Global

| Keys | Action |
|---|---|
| `<Esc>` | Clear search highlight |
| `<C-h/j/k/l>` | Move between windows |
| `<leader>q` | Diagnostics → quickfix list |
| `]d` / `[d` | Next / previous diagnostic (float auto-opens) |
| `<leader>f` | Format buffer / selection |
| `<Esc><Esc>` | Exit terminal mode |

### Search & navigation (Telescope)

| Keys | Action |
|---|---|
| `<leader>sf` / `<leader>sg` | Find files / grep text |
| `<leader>sw` | Grep word under cursor |
| `<leader><leader>` | Switch buffers |
| `<leader>s.` / `<leader>sr` | Recent files / resume last picker |
| `<leader>sh` / `<leader>sk` / `<leader>sc` | Help / keymaps / commands |
| `<leader>sd` / `<leader>sn` | Diagnostics / Neovim config files |
| `<leader>/` / `<leader>s/` | Search in current buffer / open files |

### Code intelligence (LSP)

| Keys | Action |
|---|---|
| `K` | Hover documentation |
| `grd` / `grt` / `grD` | Definition / type definition / declaration |
| `grr` / `gri` | References / implementation |
| `grn` / `gra` | Rename / code action |
| `gO` / `gW` | Symbols in file / in project |
| `<leader>th` | Toggle inlay hints |

### File tree, git, editing

| Keys | Action |
|---|---|
| `<leader>e` / `<leader>E` | Toggle tree / reveal current file |
| `]h` / `[h` | Next / previous git hunk |
| `<leader>hs` / `hr` / `hS` / `hu` | Stage / reset hunk, stage buffer, undo stage |
| `<leader>hp` / `hb` / `hd` | Preview hunk / blame line / diff |
| `va)` / `ci'` / `saiw)` | Text objects and surrounds (mini) |

### Debugging & tests

| Keys | Action |
|---|---|
| `<leader>db` / `dB` | Toggle (conditional) breakpoint |
| `<leader>dc` / `dt` | Continue / terminate |
| `<leader>do` / `di` / `dO` | Step over / into / out |
| `<leader>du` | Toggle debug UI |
| `<leader>Tn` / `Tf` / `Ta` | Run nearest / file / all tests |
| `<leader>Td` / `Ts` / `To` | Debug test / summary / output |

### Java refactoring & actions (`<leader>j…`)

| Keys | Action |
|---|---|
| `<leader>jo` | Organize imports |
| `<leader>jv` | Extract variable (normal / visual) |
| `<leader>jc` | Extract constant (normal / visual) |
| `<leader>jm` | Extract method (visual) |
| `<leader>jt` | Run test class (JDTLS) |
| `<leader>jn` | Run nearest test method (JDTLS) |

---

## Customization

### Add a plugin

Drop a spec into any `lua/plugins/*.lua` (or a new file):

```lua
return {
  {
    'someuser/some-plugin.nvim',
    event = 'VeryLazy',            -- when to load it
    config = function()
      require('some-plugin').setup {}
    end,
    keys = {
      { '<leader>x', function() end, desc = 'Do a thing' },
    },
  },
}
```

Restart, `:Lazy sync`, done. Prefer `event`/`cmd`/`keys` triggers so the
plugin stays out of startup.

### Other common changes

| Want to… | Edit |
|---|---|
| Change the colorscheme | `lua/plugins/ui.lua` (setup + `colorscheme` line) |
| Add an LSP server | `servers` table in `lua/plugins/lsp.lua` + its Mason name in `ensure_installed` |
| Add a formatter / linter | `lua/plugins/format.lua` / `lua/plugins/lint.lua` (+ install via Mason) |
| Change dashboard buttons | `preset.keys` in `lua/plugins/dashboard.lua` |
| Add language parsers | `parsers` list in `lua/plugins/treesitter.lua` |
| Tweak editor options | `lua/config/options.lua` |
| Change keymaps | `lua/config/keymaps.lua`, or the `keys` list in the relevant plugin file |

### Maintenance

```sh
:Lazy sync        # install/update/clean plugins
:Lazy check       # what updates are available
:Mason            # manage language servers / formatters / linters
:checkhealth      # diagnose anything that feels off
```

Plugin versions are pinned in `lazy-lock.json` — commit it alongside the
config so every machine gets the same setup.
