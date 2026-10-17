package main

import "github.com/Shougo/goda-cmp.vim/cmp"

// configure holds the settings, like the patchGlobal calls of a ddc.ts.
// The settings can also be changed from Vim script at any time, for example
// goda_cmp#patch_global({'ui': 'pum'}); see the README.
func configure(b *cmp.Builder) {
	b.PatchGlobal(cmp.Config{
		UI:      "native", // "native" or "pum"
		Sources: []string{"around"},
		SourceOptions: map[string]cmp.SourceOption{
			"_": {
				Matchers:   []string{"matcher_head"},
				Sorters:    []string{"sorter_length"},
				Converters: []string{"converter_truncate_abbr"},
			},
			"around": {Mark: "A"},
		},
		AutoCompleteDelay: cmp.Ptr(10),
	})

	// Per filetype, laid over the global settings.
	b.PatchFiletype("markdown", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"around": {MinAutoCompleteLength: cmp.Ptr(3)},
		},
	})
	b.PatchFiletypes([]string{"gitcommit", "text"}, cmp.Config{
		AutoCompleteDelay: cmp.Ptr(100),
	})
}
