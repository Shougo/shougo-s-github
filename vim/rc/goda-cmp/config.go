package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
)

func configure(b *cmp.Builder) {
	b.PatchGlobal(cmp.Config{
		UI:      "pum", // "native" or "pum"
		Sources: []string{"around"},
		SourceOptions: map[string]cmp.SourceOption{
			"_": {
				Matchers:              []string{"matcherhead"},
				Sorters:               []string{"sorterlength"},
				Converters:            []string{"convertertruncateabbr"},
				MinAutoCompleteLength: new(2),
			},
			"around": {Mark: "A"},
		},
		AutoCompleteDelay: new(10),
	})

	b.PatchFiletype("markdown", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"around": {MinAutoCompleteLength: new(3)},
		},
	})

	b.PatchFiletypes([]string{"gitcommit", "text"}, cmp.Config{
		AutoCompleteDelay: new(100),
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
