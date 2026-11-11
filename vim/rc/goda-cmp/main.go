// Command config is a user's goda-cmp configuration: an ordinary Go program.
// Build it with :call goda_cmp#build() (or go build) and goda-cmp.vim runs the result.
package main

import (
	"log"
	"os"
	"runtime"

	"github.com/Shougo/goda-cmp-ext/ext/filter/converterremoveoverlap"
	"github.com/Shougo/goda-cmp-ext/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp-ext/ext/filter/matcherlength"
	"github.com/Shougo/goda-cmp-ext/ext/filter/matcherprefix"
	"github.com/Shougo/goda-cmp-ext/ext/filter/sortercmdlinehistory"
	"github.com/Shougo/goda-cmp-ext/ext/filter/sorterhead"
	"github.com/Shougo/goda-cmp-ext/ext/filter/sorterrank"
	"github.com/Shougo/goda-cmp-ext/ext/filter/sortershellhistory"
	"github.com/Shougo/goda-cmp-ext/ext/source/around"
	"github.com/Shougo/goda-cmp-ext/ext/source/buffer"
	"github.com/Shougo/goda-cmp-ext/ext/source/cmdline"
	"github.com/Shougo/goda-cmp-ext/ext/source/cmdlinehistory"
	"github.com/Shougo/goda-cmp-ext/ext/source/file"
	"github.com/Shougo/goda-cmp-ext/ext/source/input"
	"github.com/Shougo/goda-cmp-ext/ext/source/line"
	"github.com/Shougo/goda-cmp-ext/ext/source/lsp"
	"github.com/Shougo/goda-cmp-ext/ext/source/mocword"
	"github.com/Shougo/goda-cmp-ext/ext/source/register"
	"github.com/Shougo/goda-cmp-ext/ext/source/shell"
	"github.com/Shougo/goda-cmp-ext/ext/source/shellhistory"
	"github.com/Shougo/goda-cmp-ext/ext/source/shellnative"
	"github.com/Shougo/goda-cmp-ext/ext/source/vim"
	"github.com/Shougo/goda-cmp-ui-inline.vim/ext/ui/inline"
	"github.com/Shougo/goda-cmp-ui-native.vim/ext/ui/native"
	"github.com/Shougo/goda-cmp-ui-pum.vim/ext/ui/pum"
	"github.com/Shougo/goda-cmp.vim/cmp"

	"github.com/Shougo/goda-skk.vim/cmp/source/skk"
	"github.com/Shougo/goda-skk.vim/cmp/source/skkokuri"
	"github.com/Shougo/goda-skk.vim/dictionary/google"
	"github.com/Shougo/goda-skk.vim/engine"
)

var (
	hasWindows = runtime.GOOS == "windows"
	// MOCWORD_DATA is read when the binary starts: from the editor's
	// environment.
	hasMocword  = os.Getenv("MOCWORD_DATA") != ""
	shellSource = map[bool]string{true: "shell", false: "shellnative"}[hasWindows]
)

// The shell history files, for the source and the sorter.
var shellHistories = []string{"~/.cache/goda-term-shell-history", "~/.zsh-history"}

func main() {
	// goda-skk
	jisyo := "/usr/share/skk/SKK-JISYO.L"
	if runtime.GOOS == "windows" {
		jisyo = "~/.config/SKK-JISYO.L"
	}
	p, err := engine.New(engine.Config{
		// globalDictionaries
		Dictionaries: []engine.Dictionary{
			engine.NewJisyo(jisyo, ""),
			google.New(google.Params{}),
			//skkserv.New(skkserv.Params{Addr: "localhost:1178"}),
		},
		// No markers: the highlights GodaSkkHenkan and
		// GodaSkkHenkanSelect show the pre-edit (vimrc.vim).
		MarkerHenkan:          new(""),
		MarkerHenkanSelect:    new(""),
		EggLikeNewline:        true,
		RegisterConvertResult: true,

		// register_kanatable('rom', {'jj': 'escape', '~': ['〜', '']})
		KanaTable: engine.RomTable.With(
			engine.Rule{From: "jj", Func: "escape"},
			engine.Rule{From: "~", Kana: "〜"},
		),
		// register_keymap('input', '<C-z>', 'kakuteiUndo'); <C-z> is
		// mapped by itself.
		Keymaps: map[string]map[string]string{
			"input": {"<C-z>": "kakuteiUndo"},
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	// goda-cmp
	b := cmp.New()

	b.AddUI(inline.New())
	b.AddUI(native.New())
	b.AddUI(pum.New())

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
	// goda-cmp's lsp source starts the servers itself, in Vim too. One
	// source per server; gopls here.
	b.AddSource(lsp.New(lsp.Params{
		Name:        "lsp",
		Command:     []string{"gopls"},
		Filetypes:   []string{"go"},
		RootMarkers: []string{"go.work", "go.mod", ".git"},
	}))
	b.AddSource(skk.New(p))      // skkeleton
	b.AddSource(skkokuri.New(p)) // skkeleton_okuri

	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(matcherprefix.New(matcherprefix.Params{}))
	b.AddFilter(matcherlength.New())
	b.AddFilter(sorterrank.New())
	b.AddFilter(sorterhead.New())
	b.AddFilter(sortercmdlinehistory.New(sortercmdlinehistory.Params{}))
	b.AddFilter(sortershellhistory.New(sortershellhistory.Params{Paths: shellHistories}))
	b.AddFilter(converterremoveoverlap.New())

	configure(b)

	// goda-cmp.vim and the input method, in one binary.
	b.Main(p)
}
