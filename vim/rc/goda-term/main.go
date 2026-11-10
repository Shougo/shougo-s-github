// Command goda-term is a configuration of goda-term.vim: put it in
// ~/.vim/goda-term (Neovim: stdpath('config') .. '/goda-term') and build it
// with goda_term#build().
package main

import (
	"fmt"
	"runtime"

	"github.com/Shougo/goda-term-ui-shell.vim/ext/ui/shell"
	"github.com/Shougo/goda-term-ui-terminal.vim/ext/ui/terminal"
	"github.com/Shougo/goda-term.vim/term"
)

func main() {
	prompt := `\w*% \?`
	if runtime.GOOS == "windows" {
		prompt = `\f\+>`
	}

	b := term.New()

	b.AddUI(shell.New())
	b.AddUI(terminal.New())

	var fgs, bgs []string
	for i := range 16 {
		fgs = append(fgs, fmt.Sprintf("TerminalFG%d", i))
		bgs = append(bgs, fmt.Sprintf("TerminalBG%d", i))
	}

	const userPrompt = "'| ' .. fnamemodify(getcwd(), ':~') .. GodaShellGitStatus()"

	b.PatchGlobal(term.Options{
		UIParams: map[string]term.Params{
			"shell": {
				"aliases": map[string]string{"ls": "ls --color"},
				"ansiColorHighlights": shell.ANSIColorHighlights{
					Bgs:       bgs,
					Fgs:       fgs,
					Bold:      "Bold",
					Italic:    "Italic",
					Underline: "Underlined",
				},
				"noSaveHistoryCommands": []string{"history"},
				"userPrompt":            userPrompt,
				"shellHistoryPath":      "~/.cache/goda-term-shell-history",
			},
			"terminal": {
				"command":       []string{"zsh"},
				"promptPattern": prompt,
			},
		},
	})

	b.Main()
}
