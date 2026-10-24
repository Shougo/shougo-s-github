package main

import (
	"context"

	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda.vim/sdk"
)

// configure is the patchGlobal and patchFiletype calls of ddc.ts.
func configure(b *cmp.Builder) {
	commonSources := []string{"around", "file", "register"}
	var mocWord []string
	if hasMocword {
		mocWord = []string{"mocword"}
	}

	b.PatchGlobal(cmp.Config{
		UI: "pum",
		// A single candidate inline, except in a terminal.
		DynamicUI: func(_ context.Context, _ sdk.Host, a cmp.DynamicUIArgs) (string, error) {
			if a.Context.Mode != "t" && len(a.Items) == 1 {
				return "inline", nil
			}
			return "pum", nil
		},
		// The shell's completion first on the ":" command line (":!", ...).
		DynamicSources: func(_ context.Context, _ sdk.Host, a cmp.DynamicSourcesArgs) ([]string, error) {
			if a.Context.Mode == "c" && a.Context.CmdType == ":" {
				return append([]string{shellSource}, a.Sources...), nil
			}
			return nil, nil
		},
		AutoCompleteEvents: []string{
			"CmdlineEnter", "CmdlineChanged",
			"InsertEnter", "TextChangedI", "TextChangedP",
			"TextChangedT",
		},
		Sources: commonSources,
		CmdlineSources: map[string][]string{
			":": {"cmdline", "cmdlinehistory", "around", "register"},
			"@": {"input", "cmdlinehistory", "file", "around"},
			">": {"input", "cmdlinehistory", "file", "around"},
			"/": {"around", "line"},
			"?": {"around", "line"},
			"-": {"around", "line"},
			// "=" (the expression register) is not completed by goda-cmp.
		},
		SourceOptions: map[string]cmp.SourceOption{
			"_": {
				IgnoreCase: new(true),
				Matchers:   []string{"matcherhead", "matcherprefix", "matcherlength"},
				Sorters:    []string{"sorterrank"},
				Converters: []string{"converterremoveoverlap"},
				Timeout:    new(1000),
			},
			"around": {Mark: "A"},
			"buffer": {Mark: "B"},
			"cmdline": {
				IsVolatile:             new(true),
				Mark:                   "cmdline",
				Matchers:               []string{"matcherlength"},
				Sorters:                []string{"sortercmdlinehistory"},
				ForceCompletionPattern: `\S/\S*|\.\w*`,
			},
			"cmdlinehistory": {Mark: "history", Sorters: []string{}},
			"file": {
				Mark:                   "F",
				IsVolatile:             new(true),
				VolatilePattern:        "/",
				MinAutoCompleteLength:  new(1000),
				ForceCompletionPattern: `\S/\S*`,
			},
			"input": {
				Mark:                   "input",
				ForceCompletionPattern: `\S/\S*`,
				IsVolatile:             new(true),
				Sorters:                []string{"sortercmdlinehistory"},
			},
			"line": {Mark: "line"},
			"lsp": {
				Mark:                   "lsp",
				ForceCompletionPattern: `\.\w*|::\w*|->\w*`,
				Dup:                    "force",
			},
			"mocword": {
				Mark:                  "mocword",
				MinAutoCompleteLength: new(4),
				IsVolatile:            new(true),
			},
			"register": {Mark: "reg"},
			"shell": {
				Mark:                   "sh",
				IsVolatile:             new(true),
				ForceCompletionPattern: `\S/\S*`,
				MinAutoCompleteLength:  new(3),
				Sorters:                []string{"sortershellhistory"},
			},
			"shellhistory": {Mark: "history", Sorters: []string{}},
			"shellnative": {
				Mark:                   "sh",
				ForceCompletionPattern: `\S/\S*`,
				MinAutoCompleteLength:  new(3),
				Sorters:                []string{"sortershellhistory"},
				IsVolatile:             new(true),
			},
			"vim": {Mark: "vim", IsVolatile: new(true)},
		},
		PostFilters: []string{"sorterhead"},
	})

	// Text files.
	b.PatchFiletypes([]string{"markdown", "markdown_inline", "gitcommit", "comment"}, cmp.Config{
		Sources: concat(commonSources, []string{"line"}, mocWord),
	})

	b.PatchFiletypes([]string{"html", "css"}, cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"_": {KeywordPattern: `[0-9a-zA-Z_:#-]*`},
		},
	})

	// Shells and terminals.
	b.PatchFiletypes([]string{"zsh", "sh", "bash", "ddt-shell", "ddt-terminal"}, cmp.Config{
		SpecialBufferCompletion: new(true),
		SourceOptions: map[string]cmp.SourceOption{
			"_": {KeywordPattern: `[0-9a-zA-Z_./#:-]*`},
		},
		Sources: []string{shellSource, "shellhistory", "around"},
	})

	// "#" in TypeScript identifiers.
	b.PatchFiletype("typescript", cmp.Config{
		SourceOptions: map[string]cmp.SourceOption{
			"_": {KeywordPattern: `#?[a-zA-Z_][0-9a-zA-Z_]*`},
		},
	})

	// Language servers: add a source per server in main.go and list its
	// filetypes here.
	b.PatchFiletypes([]string{"go"}, cmp.Config{
		Sources: concat([]string{"lsp"}, commonSources),
	})

	b.PatchFiletype("vim", cmp.Config{
		// The command-line window is a special buffer.
		SpecialBufferCompletion: new(true),
		Sources:                 concat([]string{"vim", "cmdline"}, commonSources),
	})
}

func concat(lists ...[]string) []string {
	var out []string
	for _, l := range lists {
		out = append(out, l...)
	}
	return out
}
