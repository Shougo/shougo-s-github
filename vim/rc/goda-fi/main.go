package main

import (
	"github.com/Shougo/goda-fi.vim/ext/filter/converterhldir"
	"github.com/Shougo/goda-fi.vim/ext/filter/matcherfiles"
	"github.com/Shougo/goda-fi.vim/ext/filter/matcherhidden"
	"github.com/Shougo/goda-fi.vim/ext/filter/matcherrelative"
	"github.com/Shougo/goda-fi.vim/ext/filter/matchersubstring"
	"github.com/Shougo/goda-fi.vim/ext/filter/sorteralpha"
	"github.com/Shougo/goda-fi.vim/ext/filter/sortermtime"
	kindfile "github.com/Shougo/goda-fi.vim/ext/kind/file"
	"github.com/Shougo/goda-fi.vim/ext/kind/word"
	"github.com/Shougo/goda-fi.vim/ext/source/buffer"
	"github.com/Shougo/goda-fi.vim/ext/source/file"
	"github.com/Shougo/goda-fi.vim/ext/source/fileexternal"
	"github.com/Shougo/goda-fi.vim/ext/source/fileold"
	"github.com/Shougo/goda-fi.vim/ext/source/filepoint"
	"github.com/Shougo/goda-fi.vim/ext/source/filerec"
	"github.com/Shougo/goda-fi.vim/ext/source/line"
	"github.com/Shougo/goda-fi.vim/ext/source/register"
	"github.com/Shougo/goda-fi.vim/ext/source/rg"
	"github.com/Shougo/goda-fi.vim/fi"
	"github.com/Shougo/goda-fi.vim/ui/ff"
)

func main() {
	b := fi.New()

	b.AddUI(ff.New())

	b.AddSource(file.New(file.Params{}))
	b.AddSource(filerec.New(filerec.Params{}))
	b.AddSource(fileold.New())
	b.AddSource(buffer.New())
	b.AddSource(filepoint.New())
	b.AddSource(line.New(line.Params{}))
	b.AddSource(register.New())
	b.AddSource(rg.New(
		rg.Params{
			Args: []string{
				"--smart-case",
				"--json",
			},
			Category: true,
			Highlights: rg.Highlights{
				Path:   "Directory",
				LineNr: "LineNr",
				Word:   "Search",
			},
		}))
	b.AddSource(fileexternal.New(fileexternal.Params{}))
	b.AddSourceAs("filegit", fileexternal.New(
		fileexternal.Params{
			Cmd: []string{
				"git",
				"ls-files",
				"-co",
				"--exclude-standard",
			},
		},
	))
	b.AddSourceAs("filerg", fileexternal.New(
		fileexternal.Params{
			Cmd: []string{
				"rg",
				"--files",
				"--glob",
				"!.git",
				"--color",
				"never",
				"--no-messages",
			},
			UpdateItems: 50000,
		}))

	b.AddFilter(matchersubstring.New(
		matchersubstring.Params{
			HighlightMatched: "PmenuMatch",
		},
	))
	b.AddFilter(matcherhidden.New())
	b.AddFilter(matcherrelative.New())
	b.AddFilter(matcherfiles.New(matcherfiles.Params{}))
	b.AddFilter(sorteralpha.New())
	b.AddFilter(sortermtime.New())
	b.AddFilter(converterhldir.New(
		converterhldir.Params{
			HlGroup: converterhldir.Groups{
				"Directory",
				"Keyword",
			},
		}))

	b.AddKind(kindfile.New())
	b.AddKind(word.New())

	// setAlias("_", "action", "tabopen", "open")
	b.AddActionAlias("tabopen", "open")

	b.PatchGlobal(fi.Options{
		UI: "ff",
		UIOptions: map[string]fi.UIOptions{
			"_": {
				FilterInputFunc:     "cmdline#input",
				FilterInputOptsFunc: "cmdline#input_opts",
			},
		},
		UIParams: map[string]fi.Params{
			"ff": {
				"autoAction": map[string]any{
					"name": "preview",
				},
				"floatingBlend":  20,
				"floatingBorder": "none",
				"highlights": map[string]any{
					"floating":       "Normal",
					"floatingBorder": "Special",
				},
				"maxHighlightItems":     50,
				"onPreview":             "GodaFiOnPreview",
				"previewFloating":       true,
				"previewFloatingBorder": "single",
				"winWidth":              100,
			},
		},
		SourceOptions: map[string]fi.SourceOptions{
			"_": {
				Matchers: []string{
					"matchersubstring",
				},
				IgnoreCase: new(true),
				SmartCase:  new(true),
			},
			"fileold": {
				Matchers: []string{
					"matcherrelative",
					"matchersubstring",
				},
				Converters: []string{"converterhldir"},
			},
			"filegit": {
				Matchers: []string{
					"matcherrelative",
					"matchersubstring",
				},
				Sorters:    []string{"sortermtime"},
				Converters: []string{"converterhldir"},
			},
			"filerec": {
				Matchers: []string{
					"matchersubstring",
					"matcherhidden",
				},
				Sorters:    []string{"sortermtime"},
				Converters: []string{"converterhldir"},
			},
			"file": {
				Matchers: []string{
					"matchersubstring",
					"matcherhidden",
				},
				Sorters:    []string{"sorteralpha"},
				Converters: []string{"converterhldir"},
			},
			"rg": {
				Matchers: []string{
					"matchersubstring",
					"matcherfiles",
				},
			},
		},
		KindOptions: map[string]fi.KindOptions{
			"file": {DefaultAction: "open"},
			"word": {DefaultAction: "append"},
		},
		ActionOptions: map[string]fi.ActionOptions{
			"tabopen": {Quit: new(false)},
		},
		ActionParams: map[string]fi.Params{
			"tabopen": {"command": "tabedit"},
		},
	})

	b.Main()
}
