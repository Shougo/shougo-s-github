package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortertext"
	"github.com/Shougo/goda-cmp.vim/ext/source/lsp"
)

// configure holds the settings, like the patchGlobal calls of a ddc.ts.
// The settings can also be changed from Vim script at any time, for example
// goda_cmp#patch_global({'ui': 'pum'}); see the README.
func configure(b *cmp.Builder) {
	b.PatchGlobal(cmp.Config{
		UI:      "pum", // "native" or "pum"
		Sources: []string{"around"},
		SourceOptions: map[string]cmp.SourceOption{
			"_": {
				Matchers:              []string{"matcher_head"},
				Sorters:               []string{"sorter_length"},
				Converters:            []string{"converter_truncate_abbr"},
				MinAutoCompleteLength: new(2),
			},
			"around": {Mark: "A"},
		},
		AutoCompleteDelay: new(10),
	})

	// Per filetype, laid over the global settings.
	b.PatchFiletype("markdown", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"around": {MinAutoCompleteLength: new(3)},
		},
	})
	b.PatchFiletypes([]string{"gitcommit", "text"}, cmp.Config{
		AutoCompleteDelay: new(100),
	})

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

	b.AddFilter(sortertext.New())

	b.PatchFiletypes([]string{"go", "gomod"}, cmp.Config{
		Sources: []string{"gopls", "around"},
		SourceOptions: map[string]cmp.SourceOption{
			"gopls": {
				Mark:                   "LSP",
				ForceCompletionPattern: `\.\w*`,
				Matchers:               []string{},
				Sorters:                []string{"sorter_text"},
			},
		},
	})
}
