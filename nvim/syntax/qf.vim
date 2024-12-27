if exists("b:current_syntax")
  finish
endif

" Compiler may spit out lines which we really do not care about, default to
" less intrusive color
syn match	qfText		"^.*"

" Code may be outputed by compiler in the form
"       |
"    20 |	function some(method) {
"       |
" which we want in the normal color and not darkened.
syn match	qfCode		"\s*\d*\s*|.*"

" Actual quick fix items
syn match	qfItem		"\w*\.\w*:\d*:\d*" nextgroup=qfError,qfWarning,qfInfo,qfHint contains=qfFileName,qfLineCol
syn match	qfFileName	"\w*\.\w*" contained
syn match	qfLineCol	"\d*:\d*" contained

syn match	qfError		" error:" nextgroup=qfMessage contained
syn match	qfWarning	" warning:" nextgroup=qfMessage contained
syn match	qfInfo		" info:" nextgroup=qfMessage contained
syn match	qfHint		" hint:" nextgroup=qfMessage contained

" Some helpful bits

" Match inside ` and whatever that char GCC uses is.
syn match 	qfVariable	"`\|‘[^’`]*" contains=qfVarName
syn match 	qfVarName	"\w*" contained

" Match inside brackets, which tells us the error code usually
syn match 	qfErrGroup	"\[.\+\]" contains=qfErrCode
syn match 	qfErrCode	"[^\[\]]\+" contained

" Highlights

hi! def link qfText 	Comment
hi! def link qfCode 	Normal

hi! def link qfFileName	Directory
hi! def link qfLineCol	Number

hi! def link qfError 	DiagnosticError
hi! def link qfWarning 	DiagnosticWarn
hi! def link qfInfo 	DiagnosticInfo
hi! def link qfHint 	DiagnosticHint

hi! def link qfErrCode 	Operator
hi! def link qfVarName 	Identifier

let b:current_syntax = "qf"
