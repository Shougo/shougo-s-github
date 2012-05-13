" Vim syntax file
" Language:     Haskell
" Maintainer:   Rui Carlos A. Goncalves <rcgoncalves.pt@gmail.com>
" 		Yang Zhang <treblih.divad@gmail.com>
" Last Change:  July 31, 2010
"
" Version:      1.3
" Url:          http://www.rcg-pt.net/programacao/haskell.vim.gz
"
" Original Author: John Williams <jrw@pobox.com>

" Remove any old syntax stuff hanging around
if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif


" (Qualified) identifiers (no default highlighting)
syn match ConId         "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[A-Z][a-zA-Z0-9_']*\>"
syn match VarId         "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[a-z][a-zA-Z0-9_']*\>"


" Infix operators--most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match hsVarSym      "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match hsConSym      "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match hsVarSym      "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match hsConSym      "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"


" Reserved symbols--cannot be overloaded.
syn match hsDelimiter  "(\|)\|\[\|\]\|,\|;\|_\|{\|}"


" Strings and constants
syn match   hsSpecialChar	contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match   hsSpecialChar	contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match   hsSpecialCharError	contained "\\&\|'''\+"
syn region  hsString		start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=hsSpecialChar
syn match   hsCharacter		"[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=hsSpecialChar,hsSpecialCharError
syn match   hsCharacter		"^'\([^\\]\|\\[^']\+\|\\'\)'" contains=hsSpecialChar,hsSpecialCharError
syn match   hsNumber		"\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>"
syn match   hsFloat		"\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"


" Keyword definitions. These must be patters instead of keywords
" because otherwise they would match as keywords at the start of a
" "literate" comment (see lhs.vim).
syn match hsModule	"\<module\>"
syn match hsImport	"\<import\>.*"he=s+6 contains=hsImportMod
syn match hsImportMod	contained "\<\(as\|qualified\|hiding\)\>"
syn match hsInfix	"\<\(infix\|infixl\|infixr\)\>"
syn match hsStructure	"\<\(class\|data\|deriving\|instance\|default\|where\)\>"
syn match hsTypedef	"\<\(type\|newtype\)\>"
syn match hsStatement	"\<\(do\|return\|case\|of\|let\|in\)\>"
syn match hsConditional	"\<\(if\|then\|else\)\>"


" Types
syn keyword hsType	Array
syn keyword hsType	Bool BufferMode
syn keyword hsType	CalendarTime Char ClockTime Complex Complex
syn keyword hsType	Day Double
syn keyword hsType	Either ExitCode
syn keyword hsType	FilePath Float
syn keyword hsType	Handle HandlePosn
syn keyword hsType	Int Integer IO IOError IOMode
syn keyword hsType	Maybe Month
syn keyword hsType	Ordering
syn keyword hsType	Permissions
syn keyword hsType	Ratio Rational Rational Read ReadS
syn keyword hsType	SeekMode Show ShowS StdGen String
syn keyword hsType	TimeDiff  TimeLocale


" Classes from the standard prelude
syn keyword hsCls	Bounded
syn keyword hsCls	Enum Eq
syn keyword hsCls	Floating Fractional Functor
syn keyword hsCls	Integral Ix
syn keyword hsCls	Monad MonadPlus
syn keyword hsCls	Num
syn keyword hsCls	Ord
syn keyword hsCls	Random RandomGen Read Real RealFloat RealFrac
syn keyword hsCls	Show


" Functions 
syn keyword hsFunc	abs
syn keyword hsFunc	accum
syn keyword hsFunc	accumArray
syn keyword hsFunc	acos
syn keyword hsFunc	acosh
syn keyword hsFunc	addToClockTime
syn keyword hsFunc	all
syn keyword hsFunc	and
syn keyword hsFunc	any
syn keyword hsFunc	ap
syn keyword hsFunc	appendFile
syn keyword hsFunc	approxRational
syn keyword hsFunc	array
syn keyword hsFunc	asin
syn keyword hsFunc	asinh
syn keyword hsFunc	assocs
syn keyword hsFunc	asTypeOf
syn keyword hsFunc	atan
syn keyword hsFunc	atan2
syn keyword hsFunc	atanh

syn keyword hsFunc	bounds
syn keyword hsFunc	bracket
syn keyword hsFunc	bracket_
syn keyword hsFunc	break

syn keyword hsFunc	calendarTimeToString
syn keyword hsFunc	catch
syn keyword hsFunc	catMaybes
syn keyword hsFunc	ceiling
syn keyword hsFunc	chr
syn keyword hsFunc	cis
syn keyword hsFunc	compare
syn keyword hsFunc	concat
syn keyword hsFunc	concatMap
syn keyword hsFunc	conjugate
syn keyword hsFunc	const
syn keyword hsFunc	cos
syn keyword hsFunc	cosh
syn keyword hsFunc	cpuTimePrecision
syn keyword hsFunc	createDirectory
syn keyword hsFunc	curry
syn keyword hsFunc	cycle

syn keyword hsFunc	decodeFloat
syn keyword hsFunc	defaultTimeLocale
syn keyword hsFunc	delete
syn keyword hsFunc	deleteBy
syn keyword hsFunc	denominator
syn keyword hsFunc	diffClockTimes
syn keyword hsFunc	digitToInt
syn keyword hsFunc	div
syn keyword hsFunc	divMod
syn keyword hsFunc	doesDirectoryExist
syn keyword hsFunc	doesFileExist
syn keyword hsFunc	drop
syn keyword hsFunc	dropWhile

syn keyword hsFunc	either
syn keyword hsFunc	elem
syn keyword hsFunc	elemIndex
syn keyword hsFunc	elemIndices
syn keyword hsFunc	elems
syn keyword hsFunc	encodeFloat
syn keyword hsFunc	enumFrom
syn keyword hsFunc	enumFromThen
syn keyword hsFunc	enumFromThenTo
syn keyword hsFunc	enumFromTo
syn keyword hsFunc	error
syn keyword hsFunc	even
syn keyword hsFunc	executable
syn keyword hsFunc	exitFailure
syn keyword hsFunc	exitWith
syn keyword hsFunc	exp
syn keyword hsFunc	exponent

syn keyword hsFunc	fail
syn keyword hsFunc	filter
syn keyword hsFunc	filterM
syn keyword hsFunc	find
syn keyword hsFunc	findIndex
syn keyword hsFunc	findIndices
syn keyword hsFunc	flip
syn keyword hsFunc	floatDigits
syn keyword hsFunc	floatRadix
syn keyword hsFunc	floatRange
syn keyword hsFunc	floatToDigits
syn keyword hsFunc	floor
syn keyword hsFunc	fmap
syn keyword hsFunc	foldl
syn keyword hsFunc	foldl1
syn keyword hsFunc	foldM
syn keyword hsFunc	foldr
syn keyword hsFunc	foldr1
syn keyword hsFunc	formatCalendarTime
syn keyword hsFunc	fromEnum
syn keyword hsFunc	fromInteger
syn keyword hsFunc	fromIntegral
syn keyword hsFunc	fromJust
syn keyword hsFunc	fromMaybe
syn keyword hsFunc	fromRat
syn keyword hsFunc	fromRational
syn keyword hsFunc	fst

syn keyword hsFunc	gcd
syn keyword hsFunc	genericDrop
syn keyword hsFunc	genericIndex
syn keyword hsFunc	genericLength
syn keyword hsFunc	genericReplicate
syn keyword hsFunc	genericSplitAt
syn keyword hsFunc	genericTake
syn keyword hsFunc	getArgs
syn keyword hsFunc	getChar
syn keyword hsFunc	getClockTime
syn keyword hsFunc	getContents
syn keyword hsFunc	getCPUTime
syn keyword hsFunc	getCurrentDirectory
syn keyword hsFunc	getDirectoryContents
syn keyword hsFunc	getEnv
syn keyword hsFunc	getLine
syn keyword hsFunc	getModificationTime
syn keyword hsFunc	getPermissions
syn keyword hsFunc	getProgName
syn keyword hsFunc	getStdGen
syn keyword hsFunc	getStdRandom
syn keyword hsFunc	group
syn keyword hsFunc	groupBy
syn keyword hsFunc	guard

syn keyword hsFunc	hClose
syn keyword hsFunc	head
syn keyword hsFunc	hFileSize
syn keyword hsFunc	hFlush
syn keyword hsFunc	hGetBuffering
syn keyword hsFunc	hGetChar
syn keyword hsFunc	hGetContents
syn keyword hsFunc	hGetLine
syn keyword hsFunc	hGetPosn
syn keyword hsFunc	hIsClosed
syn keyword hsFunc	hIsEOF
syn keyword hsFunc	hIsOpen
syn keyword hsFunc	hIsReadable
syn keyword hsFunc	hIsSeekable
syn keyword hsFunc	hIsWritable
syn keyword hsFunc	hLookAhead
syn keyword hsFunc	hPrint
syn keyword hsFunc	hPutChar
syn keyword hsFunc	hPutStr
syn keyword hsFunc	hPutStrLn
syn keyword hsFunc	hReady
syn keyword hsFunc	hSeek
syn keyword hsFunc	hSetBuffering
syn keyword hsFunc	hSetPosn
syn keyword hsFunc	hWaitForInput

syn keyword hsFunc	id
syn keyword hsFunc	imagPart
syn keyword hsFunc	index
syn keyword hsFunc	indices
syn keyword hsFunc	init
syn keyword hsFunc	inits
syn keyword hsFunc	inRange
syn keyword hsFunc	insert
syn keyword hsFunc	insertBy
syn keyword hsFunc	interact
syn keyword hsFunc	intersect
syn keyword hsFunc	intersectBy
syn keyword hsFunc	intersperse
syn keyword hsFunc	intToDigit
syn keyword hsFunc	ioeGetErrorString
syn keyword hsFunc	ioeGetFileName
syn keyword hsFunc	ioeGetHandle
syn keyword hsFunc	ioError
syn keyword hsFunc	isAlpha
syn keyword hsFunc	isAlphaNum
syn keyword hsFunc	isAlreadyExistsError
syn keyword hsFunc	isAlreadyInUseError
syn keyword hsFunc	isAscii
syn keyword hsFunc	isControl
syn keyword hsFunc	isDenormalized
syn keyword hsFunc	isDigit
syn keyword hsFunc	isDoesNotExistError
syn keyword hsFunc	isEOF
syn keyword hsFunc	isEOFError
syn keyword hsFunc	isFullError
syn keyword hsFunc	isHexDigit
syn keyword hsFunc	isIEEE
syn keyword hsFunc	isIllegalOperation
syn keyword hsFunc	isInfinite
syn keyword hsFunc	isJust
syn keyword hsFunc	isLatin1
syn keyword hsFunc	isLower
syn keyword hsFunc	isNaN
syn keyword hsFunc	isNegativeZero
syn keyword hsFunc	isNothing
syn keyword hsFunc	isOctDigit
syn keyword hsFunc	isPermissionError
syn keyword hsFunc	isPrefixOf
syn keyword hsFunc	isPrint
syn keyword hsFunc	isSpace
syn keyword hsFunc	isSuffixOf
syn keyword hsFunc	isUpper
syn keyword hsFunc	isUserError
syn keyword hsFunc	iterate
syn keyword hsFunc	ixmap

syn keyword hsFunc	join

syn keyword hsFunc	last
syn keyword hsFunc	lcm
syn keyword hsFunc	length
syn keyword hsFunc	lex
syn keyword hsFunc	lexDigits
syn keyword hsFunc	lexLitChar
syn keyword hsFunc	liftM
syn keyword hsFunc	liftM2
syn keyword hsFunc	liftM3
syn keyword hsFunc	liftM4
syn keyword hsFunc	liftM5
syn keyword hsFunc	lines
syn keyword hsFunc	listArray
syn keyword hsFunc	listToMaybe
syn keyword hsFunc	log
syn keyword hsFunc	logBase
syn keyword hsFunc	lookup

syn keyword hsFunc	magnitude
syn keyword hsFunc	map
syn keyword hsFunc	mapAccumL
syn keyword hsFunc	mapAccumR
syn keyword hsFunc	mapAndUnzipM
syn keyword hsFunc	mapM
syn keyword hsFunc	mapM_
syn keyword hsFunc	mapMaybe
syn keyword hsFunc	max
syn keyword hsFunc	maxBound
syn keyword hsFunc	maximum
syn keyword hsFunc	maximumBy
syn keyword hsFunc	maybe
syn keyword hsFunc	maybeToList
syn keyword hsFunc	min
syn keyword hsFunc	minBound
syn keyword hsFunc	minimum
syn keyword hsFunc	minimumBy
syn keyword hsFunc	mkPolar
syn keyword hsFunc	mkStdGen
syn keyword hsFunc	mod
syn keyword hsFunc	msum

syn keyword hsFunc	negate
syn keyword hsFunc	newStdGen
syn keyword hsFunc	next
syn keyword hsFunc	not
syn keyword hsFunc	notElem
syn keyword hsFunc	nub
syn keyword hsFunc	nubBy
syn keyword hsFunc	null
syn keyword hsFunc	numerator

syn keyword hsFunc	odd
syn keyword hsFunc	openFile
syn keyword hsFunc	or
syn keyword hsFunc	ord
syn keyword hsFunc	otherwise

syn keyword hsFunc	partition
syn keyword hsFunc	phase
syn keyword hsFunc	pi
syn keyword hsFunc	polar
syn keyword hsFunc	pred
syn keyword hsFunc	print
syn keyword hsFunc	product
syn keyword hsFunc	properFraction
syn keyword hsFunc	putChar
syn keyword hsFunc	putStr
syn keyword hsFunc	putStrLn

syn keyword hsFunc	quot
syn keyword hsFunc	quotRem

syn keyword hsFunc	random
syn keyword hsFunc	randomIO
syn keyword hsFunc	randomR
syn keyword hsFunc	randomRIO
syn keyword hsFunc	randomRs
syn keyword hsFunc	randoms
syn keyword hsFunc	range
syn keyword hsFunc	rangeSize
syn keyword hsFunc	read
syn keyword hsFunc	readable
syn keyword hsFunc	readDec
syn keyword hsFunc	readFile
syn keyword hsFunc	readFloat
syn keyword hsFunc	readHex
syn keyword hsFunc	readInt
syn keyword hsFunc	readIO
syn keyword hsFunc	readList
syn keyword hsFunc	readLitChar
syn keyword hsFunc	readLn
syn keyword hsFunc	readOct
syn keyword hsFunc	readParen
syn keyword hsFunc	reads
syn keyword hsFunc	readSigned
syn keyword hsFunc	readsPrec
syn keyword hsFunc	realPart
syn keyword hsFunc	realToFrac
syn keyword hsFunc	recip
syn keyword hsFunc	rem
syn keyword hsFunc	removeDirectory
syn keyword hsFunc	removeFile
syn keyword hsFunc	renameDirectory
syn keyword hsFunc	renameFile
syn keyword hsFunc	repeat
syn keyword hsFunc	replicate
syn keyword hsFunc	return
syn keyword hsFunc	reverse
syn keyword hsFunc	round

syn keyword hsFunc	scaleFloat
syn keyword hsFunc	scanl
syn keyword hsFunc	scanl1
syn keyword hsFunc	scanr
syn keyword hsFunc	scanr1
syn keyword hsFunc	searchable
syn keyword hsFunc	seq
syn keyword hsFunc	sequence
syn keyword hsFunc	sequence_
syn keyword hsFunc	setCurrentDirectory
syn keyword hsFunc	setPermissions
syn keyword hsFunc	setStdGen
syn keyword hsFunc	show
syn keyword hsFunc	showChar
syn keyword hsFunc	showEFloat
syn keyword hsFunc	showFFloat
syn keyword hsFunc	showFloat
syn keyword hsFunc	showGFloat
syn keyword hsFunc	showInt
syn keyword hsFunc	showList
syn keyword hsFunc	showLitChar
syn keyword hsFunc	showParen
syn keyword hsFunc	shows
syn keyword hsFunc	showSigned
syn keyword hsFunc	showsPrec
syn keyword hsFunc	showString
syn keyword hsFunc	significand
syn keyword hsFunc	signum
syn keyword hsFunc	sin
syn keyword hsFunc	sinh
syn keyword hsFunc	snd
syn keyword hsFunc	sort
syn keyword hsFunc	sortBy
syn keyword hsFunc	split
syn keyword hsFunc	splitAt
syn keyword hsFunc	sqrt
syn keyword hsFunc	stderr
syn keyword hsFunc	stdin
syn keyword hsFunc	stdout
syn keyword hsFunc	subtract
syn keyword hsFunc	succ
syn keyword hsFunc	sum
syn keyword hsFunc	system

syn keyword hsFunc	tail
syn keyword hsFunc	tails
syn keyword hsFunc	take
syn keyword hsFunc	takeWhile
syn keyword hsFunc	tan
syn keyword hsFunc	tanh
syn keyword hsFunc	toCalendarTime
syn keyword hsFunc	toClockTime
syn keyword hsFunc	toEnum
syn keyword hsFunc	toInteger
syn keyword hsFunc	toLower
syn keyword hsFunc	toRational
syn keyword hsFunc	toUpper
syn keyword hsFunc	toUTCTime
syn keyword hsFunc	transpose
syn keyword hsFunc	truncate
syn keyword hsFunc	try

syn keyword hsFunc	uncurry
syn keyword hsFunc	undefined
syn keyword hsFunc	unfoldr
syn keyword hsFunc	union
syn keyword hsFunc	unionBy
syn keyword hsFunc	unless
syn keyword hsFunc	unlines
syn keyword hsFunc	until
syn keyword hsFunc	unwords
syn keyword hsFunc	unzip
syn keyword hsFunc	unzip3
syn keyword hsFunc	unzip4
syn keyword hsFunc	unzip5
syn keyword hsFunc	unzip6
syn keyword hsFunc	unzip7
syn keyword hsFunc	userError

syn keyword hsFunc	when
syn keyword hsFunc	words
syn keyword hsFunc	writable
syn keyword hsFunc	writeFile

syn keyword hsFunc	zip
syn keyword hsFunc	zip3
syn keyword hsFunc	zip4
syn keyword hsFunc	zip5
syn keyword hsFunc	zip6
syn keyword hsFunc	zip7
syn keyword hsFunc	zipWith
syn keyword hsFunc	zipWith3
syn keyword hsFunc	zipWith4
syn keyword hsFunc	zipWith5
syn keyword hsFunc	zipWith6
syn keyword hsFunc	zipWith7
syn keyword hsFunc	zipWithM
syn keyword hsFunc	zipWithM_


" Constants 
syn match hsBoolean     "\<\(True\|False\)\>"
syn match hsMaybe       "\<\(Nothing\|Just\)\>"
syn match hsConstant    "\<\(Left\|Right\)\>"
syn match hsOrdering    "\<\(LT\|EQ\|GT\)\>"


" Comments
syn match   hsLineComment      "--.*"
syn region  hsBlockComment     start="{-"  end="-}" contains=hsBlockComment
syn region  hsPragma	       start="{-#" end="#-}"

" Literate comments--any line not starting with '>' is a comment.
if exists("b:hs_literate_comments")
  syn region  hsLiterateComment   start="^" end="^>"
endif


if !exists("hs_minlines")
  let hs_minlines = 50
endif
exec "syn sync lines=" . hs_minlines

if version >= 508 || !exists("did_hs_syntax_inits")
  if version < 508
    let did_hs_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  hi link hsModule              hsStructure
  hi link hsImport              Include
  hi link hsImportMod           hsImport
  hi link hsInfix               PreProc
  hi link hsStructure           Structure
  hi link hsStatement           Statement
  hi link hsConditional         Conditional
  hi link hsSpecialChar	        SpecialChar
  hi link hsTypedef             Typedef
  hi link hsVarSym              hsOperator
  hi link hsConSym              hsOperator
  hi link hsOperator            Operator
  hi link hsSpecialCharError    Error
  hi link hsString              String
  hi link hsCharacter           Character
  hi link hsNumber              Number
  hi link hsFloat               Float
  hi link hsConditional         Conditional
  hi link hsLiterateComment     hsComment
  hi link hsBlockComment        hsComment
  hi link hsLineComment         hsComment
  hi link hsComment             Comment
  hi link hsPragma              SpecialComment
  hi link hsBoolean             Boolean
  hi link hsType                Type
  hi link hsFunc            	Function
  hi link hsMaybe               hsEnumConst
  hi link hsOrdering            hsEnumConst
  hi link hsEnumConst           Constant
  hi link hsConstant            Constant
  hi link hsDebug               Debug
  hi link hsCls                 Debug

  delcommand HiLink
endif

let b:current_syntax = "haskell"
