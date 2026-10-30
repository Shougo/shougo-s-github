package main

import (
	"github.com/Shougo/goda-fi.vim/ext/filter/matchersubstring"
	kindfile "github.com/Shougo/goda-fi.vim/ext/kind/file"
	"github.com/Shougo/goda-fi.vim/ext/source/buffer"
	"github.com/Shougo/goda-fi.vim/ext/source/file"
	"github.com/Shougo/goda-fi.vim/ext/source/fileexternal"
	"github.com/Shougo/goda-fi.vim/ext/source/filepoint"
	"github.com/Shougo/goda-fi.vim/ext/source/filerec"
	"github.com/Shougo/goda-fi.vim/fi"
	"github.com/Shougo/goda-fi.vim/ui/ff"
)

func main() {
	b := fi.New()
	b.AddUI(ff.New())
	b.AddSource(file.New(file.Params{}))
	b.AddSource(filerec.New(filerec.Params{}))
	b.AddSource(buffer.New())
	b.AddSource(filepoint.New())
	b.AddSource(fileexternal.New(fileexternal.Params{
		Cmd: []string{
			"git", "ls-files", "-co", "--exclude-standard",
		},
		UpdateItems: 50000,
	}))
	b.AddFilter(matchersubstring.New(
		matchersubstring.Params{HighlightMatched: "PmenuMatch"},
	))
	b.AddKind(kindfile.New())

	b.PatchGlobal(fi.Options{
		UI: "ff",
		UIParams: map[string]fi.Params{
			"ff": {
				"maxHighlightItems": 50,
				"winWidth":          100,
			},
		},
		SourceOptions: map[string]fi.SourceOptions{
			"_": {
				Matchers:   []string{"matchersubstring"},
				IgnoreCase: ptr(true),
				SmartCase:  ptr(true),
			},
		},
		KindOptions: map[string]fi.KindOptions{
			"file": {
				DefaultAction: "open",
				// setAlias("_", "action", "tabopen", "open")
				Actions: map[string]string{"tabopen": "open"},
			},
		},
		ActionOptions: map[string]fi.ActionOptions{
			"tabopen": {Quit: ptr(false)},
		},
		ActionParams: map[string]fi.Params{
			"tabopen": {"command": "tabedit"},
		},
	})

	b.Main()
}

func ptr[T any](v T) *T { return &v }
