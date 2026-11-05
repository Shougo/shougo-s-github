package main

import (
	"github.com/Shougo/goda-hex.vim/ext/analyzer/elf"
	"github.com/Shougo/goda-hex.vim/ext/analyzer/zip"
	hexui "github.com/Shougo/goda-hex.vim/ext/ui/hex"
	"github.com/Shougo/goda-hex.vim/hex"
)

func main() {
	b := hex.New()

	b.AddUI(hexui.New())

	b.AddAnalyzer(elf.New())
	b.AddAnalyzer(zip.New())

	b.PatchGlobal(hex.Options{
		UI:        "hex",
		Analyzers: []string{"elf", "zip"},
		UIParams: map[string]hex.Params{
			"hex": {"split": "no"},
		},
	})

	b.Main()
}
