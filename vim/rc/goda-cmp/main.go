// Command config is a user's goda-cmp configuration: an ordinary Go program.
// Build it with :call goda_cmp#build() (or go build) and goda-cmp.vim runs the result.
//
// It is the counterpart of a ddc.ts: extensions are imported (and so type
// checked and completed by your editor), and configured with PatchGlobal and
// PatchFiletype.
package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/convertertruncateabbr"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherprefix"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortercmdlinehistory"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterlength"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortertext"
	"github.com/Shougo/goda-cmp.vim/ext/source/around"
	"github.com/Shougo/goda-cmp.vim/ext/source/cmdline"
	"github.com/Shougo/goda-cmp.vim/ext/source/cmdlinehistory"
	"github.com/Shougo/goda-cmp.vim/ext/source/file"
	"github.com/Shougo/goda-cmp.vim/ext/source/line"
	"github.com/Shougo/goda-cmp.vim/ext/source/lsp"
	"github.com/Shougo/goda-cmp.vim/ext/source/register"
	"github.com/Shougo/goda-cmp.vim/ext/ui/inline"
	"github.com/Shougo/goda-cmp.vim/ext/ui/native"
	"github.com/Shougo/goda-cmp.vim/ext/ui/pum"
)

func main() {
	b := cmp.New()

	b.AddUI(inline.New())
	b.AddUI(native.New())
	b.AddUI(pum.New())

	b.AddSource(around.New(around.Params{MinLength: 2}))
	b.AddSource(cmdline.New())
	b.AddSource(cmdlinehistory.New(cmdlinehistory.Params{}))
	b.AddSource(file.New(file.Params{}))
	b.AddSource(line.New(line.Params{}))
	b.AddSource(lsp.New(lsp.Params{
		Name:        "gopls",
		Command:     []string{"gopls"},
		Filetypes:   []string{"go", "gomod"},
		RootMarkers: []string{"go.work", "go.mod", ".git"},
		// Settings answer workspace/configuration.
		Settings: map[string]any{"gopls": map[string]any{
			"usePlaceholders": false,
		}},
	}))
	b.AddSource(register.New(register.Params{}))

	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(matcherprefix.New(matcherprefix.Params{}))
	b.AddFilter(sorterlength.New())
	b.AddFilter(sortertext.New())
	b.AddFilter(sortercmdlinehistory.New(sortercmdlinehistory.Params{}))
	b.AddFilter(convertertruncateabbr.New(convertertruncateabbr.Params{MaxWidth: 40}))

	configure(b)
	b.Main()
}
