// Command config is a user's goda-cmp configuration: an ordinary Go program.
// Build it with :call goda_cmp#build() (or go build) and goda-cmp.vim runs the result.
//
// It is the counterpart of a ddc.ts: extensions are imported (and so type
// checked and completed by your editor), and configured with PatchGlobal and
// PatchFiletype.
package main

import (
	"os"
	"runtime"

	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/converterremoveoverlap"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherlength"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherprefix"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortercmdlinehistory"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterrank"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortershellhistory"
	"github.com/Shougo/goda-cmp.vim/ext/source/around"
	"github.com/Shougo/goda-cmp.vim/ext/source/buffer"
	"github.com/Shougo/goda-cmp.vim/ext/source/cmdline"
	"github.com/Shougo/goda-cmp.vim/ext/source/cmdlinehistory"
	"github.com/Shougo/goda-cmp.vim/ext/source/file"
	"github.com/Shougo/goda-cmp.vim/ext/source/input"
	"github.com/Shougo/goda-cmp.vim/ext/source/line"
	"github.com/Shougo/goda-cmp.vim/ext/source/lsp"
	"github.com/Shougo/goda-cmp.vim/ext/source/mocword"
	"github.com/Shougo/goda-cmp.vim/ext/source/register"
	"github.com/Shougo/goda-cmp.vim/ext/source/shell"
	"github.com/Shougo/goda-cmp.vim/ext/source/shellhistory"
	"github.com/Shougo/goda-cmp.vim/ext/source/shellnative"
	"github.com/Shougo/goda-cmp.vim/ext/source/vim"
	"github.com/Shougo/goda-cmp.vim/ext/ui/inline"
	"github.com/Shougo/goda-cmp.vim/ext/ui/native"
	"github.com/Shougo/goda-cmp.vim/ext/ui/pum"
)

var (
	hasWindows = runtime.GOOS == "windows"
	// MOCWORD_DATA is read when the binary starts: from the editor's
	// environment.
	hasMocword = os.Getenv("MOCWORD_DATA") != ""
	// ddc-source-shell on Windows, ddc-source-shell_native elsewhere.
	shellSource = map[bool]string{true: "shell", false: "shellnative"}[hasWindows]
)

// The shell history files, for the source and the sorter.
var shellHistories = []string{"~/.cache/ddt-shell-history", "~/.zsh-history"}

func main() {
	b := cmp.New()

	b.AddUI(inline.New())
	b.AddUI(native.New())
	b.AddUI(pum.New())

	// Sources, with the sourceParams of ddc.ts.
	b.AddSource(around.New(around.Params{}))
	b.AddSource(buffer.New(buffer.Params{
		RequireSameFiletype: new(false),
		LimitBytes:          50000,
		FromAltBuf:          true,
		ForceCollect:        true,
	}))
	b.AddSource(file.New(file.Params{FilenameChars: "[:keyword:]."}))
	b.AddSource(register.New(register.Params{Registers: `0123456789"#:`, ExtractWords: true}))
	b.AddSource(line.New(line.Params{}))
	b.AddSource(input.New())
	b.AddSource(cmdline.New())
	b.AddSource(cmdlinehistory.New(cmdlinehistory.Params{}))
	b.AddSource(vim.New())
	b.AddSource(shellhistory.New(shellhistory.Params{Paths: shellHistories}))
	b.AddSource(shell.New())
	b.AddSource(shellnative.New(shellnative.Params{Shell: "zsh"}))
	b.AddSource(mocword.New(mocword.Params{}))
	// ddc-source-lsp uses Neovim's LSP client; goda-cmp's lsp source starts
	// the servers itself, in Vim too. One source per server; gopls here.
	b.AddSource(lsp.New(lsp.Params{
		Name:        "lsp",
		Command:     []string{"gopls"},
		Filetypes:   []string{"go"},
		RootMarkers: []string{"go.work", "go.mod", ".git"},
	}))

	// Filters, with the filterParams of ddc.ts.
	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(matcherprefix.New(matcherprefix.Params{}))
	b.AddFilter(matcherlength.New())
	b.AddFilter(sorterrank.New())
	b.AddFilter(sorterhead.New())
	b.AddFilter(sortercmdlinehistory.New(sortercmdlinehistory.Params{}))
	b.AddFilter(sortershellhistory.New(sortershellhistory.Params{Paths: shellHistories}))
	b.AddFilter(converterremoveoverlap.New())

	configure(b)
	b.Main()
}
