// Command config is a user's goda-cmp configuration: an ordinary Go program.
// Build it with :call goda_cmp#build() (or go build) and goda-cmp.vim runs the result.
//
// It is the counterpart of a ddc.ts: extensions are imported (and so type
// checked and completed by your editor), and configured with PatchGlobal and
// PatchFiletype.
package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterlength"
	"github.com/Shougo/goda-cmp.vim/ext/filter/truncateabbr"
	"github.com/Shougo/goda-cmp.vim/ext/source/around"
)

func main() {
	b := cmp.New()

	// Extensions: anything implementing cmp.Source / cmp.Filter / cmp.UI,
	// from this repository or from your own modules.
	b.AddSource(around.New(around.Params{MinLength: 2}))
	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(sorterlength.New())
	b.AddFilter(truncateabbr.New(truncateabbr.Params{MaxWidth: 40}))

	configure(b)
	b.Main()
}
