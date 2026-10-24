package main

import (
	"context"

	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda.vim/sdk"
)

func configure(b *cmp.Builder) {
	b.PatchGlobal(cmp.Config{
		UI:      "pum", // "native" or "pum"
		Sources: []string{"around", "file", "register"},
		CmdlineSources: map[string][]string{
			":": {"cmdline", "cmdlinehistory"},
			"/": {"cmdlinehistory", "around"},
			"?": {"cmdlinehistory", "around"},
		},
		DynamicUI: func(_ context.Context, _ sdk.Host, a cmp.DynamicUIArgs) (string, error) {
			if a.Context.Mode != "t" && len(a.Items) == 1 {
				return "inline", nil
			}
			return "pum", nil
		},
		SourceOptions: map[string]cmp.SourceOption{
			"_": {
				Matchers:              []string{"matcherhead", "matcherprefix"},
				Sorters:               []string{"sorterrank"},
				Converters:            []string{"convertertruncateabbr"},
				MinAutoCompleteLength: new(2),
			},
			"around": {Mark: "A"},
			"cmdline": {
				Mark:    "cmdline",
				Sorters: []string{"sortercmdlinehistory"},
			},
			"cmdlinehistory": {Mark: "history"},
			"file": {
				IsVolatile:             new(true),
				MinAutoCompleteLength:  new(1000),
				ForceCompletionPattern: `\S/\S*`,
			},
		},
		AutoCompleteDelay: new(10),
		PostFilters:       []string{"sorterhead"},
	})

	b.PatchFiletype("markdown", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"around": {MinAutoCompleteLength: new(3)},
		},
	})

	b.PatchFiletypes([]string{"markdown", "gitcommit"}, cmp.Config{
		Sources: []string{"around", "file", "register", "line"},
	})
	b.PatchFiletype("typescript", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"_": {KeywordPattern: `#?[a-zA-Z_][0-9a-zA-Z_]*`},
		},
	})

	b.PatchFiletypes([]string{"go", "gomod"}, cmp.Config{
		Sources: []string{"gopls", "around"},
		SourceOptions: map[string]cmp.SourceOption{
			"gopls": {
				Mark:                   "LSP",
				ForceCompletionPattern: `\.\w*`,
				Matchers:               []string{},
				Sorters:                []string{"sortertext"},
			},
		},
	})
}
