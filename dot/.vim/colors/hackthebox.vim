" Vim Color File
" Name:       hackthebox.vim
" Maintainer: https://github.com/audibleblink/hackthebox.vim/
" License:    The MIT License (MIT)
" Based On:   https://github.com/silofy/hackthebox, https://github.com/joshdick/onedark.vim

" +-----------------+
" | Color Reference |
" +-----------------+

" +------------------------+
" |  Color Name  |   Hex   |
" |--------------+---------|
" | Black        | #1a2332 |
" |--------------+---------|
" | White        | #a4b1cd |
" |--------------+---------|
" | Light Red    | #ff8484 |
" |--------------+---------|
" | Dark Red     | #ff3e3e |
" |--------------+---------|
" | Green        | #9fef00 |
" |--------------+---------|
" | Light Yellow | #ffcc5c |
" |--------------+---------|
" | Dark Yellow  | #ffaf00 |
" |--------------+---------|
" | Blue         | #5cb2ff |
" |--------------+---------|
" | Magenta      | #c16cfa |
" |--------------+---------|
" | Cyan         | #5cecc6 |
" |--------------+---------|

" +----------------+
" | Initialization |
" +----------------+

set background=dark

highlight clear

if exists("syntax_on")
  syntax reset
endif

set t_Co=256

let g:colors_name="hackthebox"

" Set to "256" for 256-color terminals, or
" set to "16" to use your terminal emulator's native colors
" (a 16-color palette for this color scheme is available; see
" < https://github.com/joshdick/hackthebox.vim/blob/master/README.md >
" for more information.)
if !exists("g:hackthebox_termcolors")
  let g:hackthebox_termcolors = 256
endif

let g:hackthebox_terminal_italics = 1
" Not all terminals support italics properly. If yours does, opt-in.
if !exists("g:hackthebox_terminal_italics")
  let g:hackthebox_terminal_italics = 0
endif

" This function was borrowed from FlatColor: https://github.com/MaxSt/FlatColor/
" It was based on one found in hemisu: https://github.com/noahfrederick/vim-hemisu/
function! s:h(group, style)
  if g:hackthebox_terminal_italics == 0 && has_key(a:style, "cterm") && a:style["cterm"] == "italic"
    unlet a:style.cterm
  endif
  if g:hackthebox_termcolors == 16
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm16 : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm16 : "NONE")
  else
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
  end
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
    \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
    \ "ctermfg=" . l:ctermfg
    \ "ctermbg=" . l:ctermbg
    \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

" +-----------------+
" | Color Variables |
" +-----------------+

let s:red = { "gui": "#ff8484", "cterm": "210", "cterm16": "1" } " Alternate cterm: 168
let s:dark_red = { "gui": "#ff3e3e", "cterm": "203", "cterm16": "9" }

let s:green = { "gui": "#c5f467", "cterm": "191", "cterm16": "2" }

let s:yellow = { "gui": "#ffcc5c", "cterm": "221", "cterm16": "3" }
let s:dark_yellow = { "gui": "#ffaf00", "cterm": "214", "cterm16": "11" }

let s:blue = { "gui": "#5cb2ff", "cterm": "75", "cterm16": "4" } " Alternate cterm: 75

let s:purple = { "gui": "#c16cfa", "cterm": "135", "cterm16": "5" } " Alternate cterm: 176

let s:cyan = { "gui": "#5cecc6", "cterm": "86", "cterm16": "6" } " Alternate cterm: 73

let s:white = { "gui": "#ffffff", "cterm": "231", "cterm16" : "16" }

let s:black = { "gui": "#1a2332", "cterm": "17", "cterm16": "0" }
let s:visual_black = { "gui": "NONE", "cterm": "NONE", "cterm16": s:black.cterm16 } " Black out selected text in 16-color visual mode

let s:comment_grey = { "gui": "#5C6370", "cterm": "59", "cterm16": "15" }
let s:gutter_fg_grey = { "gui": "#636D83", "cterm": "238", "cterm16": "15" }
let s:cursor_grey =  { "gui": "#2C323C", "cterm": "236", "cterm16": "8" }
let s:visual_grey = { "gui": "#3E4452", "cterm": "237", "cterm16": "15" }
let s:menu_grey = { "gui": s:visual_grey.gui, "cterm": s:visual_grey.cterm, "cterm16": "8" }
let s:special_grey = { "gui": "#3B4048", "cterm": "238", "cterm16": "15" }
let s:vertsplit = { "gui": "#181A1F", "cterm": "59", "cterm16": "15" }

" +---------------------------------------------------------+
" | Syntax Groups (descriptions and ordering from `:h w18`) |
" +---------------------------------------------------------+

call s:h("Comment", { "fg": s:comment_grey, "gui": "italic", "cterm": "italic" }) " any comment
call s:h("Constant", { "fg": s:cyan }) " any constant
call s:h("String", { "fg": s:green }) " a string constant: "this is a string"
call s:h("Character", { "fg": s:green }) " a character constant: 'c', '\n'
call s:h("Number", { "fg": s:dark_yellow }) " a number constant: 234, 0xff
call s:h("Boolean", { "fg": s:dark_yellow }) " a boolean constant: TRUE, false
call s:h("Float", { "fg": s:dark_yellow }) " a floating point constant: 2.3e10
call s:h("Identifier", { "fg": s:red }) " any variable name
call s:h("Function", { "fg": s:blue }) " function name (also: methods for classes)
call s:h("Statement", { "fg": s:purple }) " any statement
call s:h("Conditional", { "fg": s:purple }) " if, then, else, endif, switch, etc.
call s:h("Repeat", { "fg": s:purple }) " for, do, while, etc.
call s:h("Label", { "fg": s:purple }) " case, default, etc.
call s:h("Operator", {}) " sizeof", "+", "*", etc.
call s:h("Keyword", { "fg": s:red }) " any other keyword
call s:h("Exception", { "fg": s:purple }) " try, catch, throw
call s:h("PreProc", { "fg": s:yellow }) " generic Preprocessor
call s:h("Include", { "fg": s:blue }) " preprocessor #include
call s:h("Define", { "fg": s:purple }) " preprocessor #define
call s:h("Macro", { "fg": s:purple }) " same as Define
call s:h("PreCondit", { "fg": s:yellow }) " preprocessor #if, #else, #endif, etc.
call s:h("Type", { "fg": s:yellow }) " int, long, char, etc.
call s:h("StorageClass", { "fg": s:yellow }) " static, register, volatile, etc.
call s:h("Structure", { "fg": s:yellow }) " struct, union, enum, etc.
call s:h("Typedef", { "fg": s:yellow }) " A typedef
call s:h("Special", { "fg": s:blue }) " any special symbol
call s:h("SpecialChar", {}) " special character in a constant
call s:h("Tag", {}) " you can use CTRL-] on this
call s:h("Delimiter", {}) " character that needs attention
call s:h("SpecialComment", {}) " special things inside a comment
call s:h("Debug", {}) " debugging statements
call s:h("Underlined", {}) " text that stands out, HTML links
call s:h("Ignore", {}) " left blank, hidden
call s:h("Error", { "fg": s:red }) " any erroneous construct
call s:h("Todo", { "fg": s:purple }) " anything that needs extra attention; mostly the keywords TODO FIXME and XXX

" +----------------------------------------------------------------------+
" | Highlighting Groups (descriptions and ordering from `:h hitest.vim`) |
" +----------------------------------------------------------------------+

call s:h("ColorColumn", { "bg": s:cursor_grey }) " used for the columns set with 'colorcolumn'
call s:h("Conceal", {}) " placeholder characters substituted for concealed text (see 'conceallevel')
call s:h("Cursor", { "fg": s:black, "bg": s:blue }) " the character under the cursor
call s:h("CursorIM", {}) " like Cursor, but used when in IME mode
call s:h("CursorColumn", { "bg": s:cursor_grey }) " the screen column that the cursor is in when 'cursorcolumn' is set
call s:h("CursorLine", { "bg": s:cursor_grey }) " the screen line that the cursor is in when 'cursorline' is set
call s:h("Directory", {}) " directory names (and other special names in listings)
call s:h("DiffAdd", { "fg": s:green }) " diff mode: Added line
call s:h("DiffChange", { "fg": s:dark_yellow }) " diff mode: Changed line
call s:h("DiffDelete", { "fg": s:red }) " diff mode: Deleted line
call s:h("DiffText", { "fg": s:blue }) " diff mode: Changed text within a changed line
call s:h("ErrorMsg", {}) " error messages on the command line
call s:h("VertSplit", { "fg": s:vertsplit }) " the column separating vertically split windows
call s:h("Folded", { "fg": s:comment_grey }) " line used for closed folds
call s:h("FoldColumn", {}) " 'foldcolumn'
call s:h("SignColumn", {}) " column where signs are displayed
call s:h("IncSearch", { "fg": s:black, "bg": s:yellow }) " 'incsearch' highlighting; also used for the text replaced with ":s///c"
call s:h("LineNr", { "fg": s:gutter_fg_grey }) " Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
call s:h("CursorLineNr", {}) " Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
call s:h("MatchParen", { "fg": s:blue, "gui": "underline" }) " The character under the cursor or just before it, if it is a paired bracket, and its match.
call s:h("ModeMsg", {}) " 'showmode' message (e.g., "-- INSERT --")
call s:h("MoreMsg", {}) " more-prompt
call s:h("NonText", { "fg": s:special_grey }) " '~' and '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
call s:h("Normal", { "fg": s:white, "bg": s:black }) " normal text
call s:h("Pmenu", { "bg": s:menu_grey }) " Popup menu: normal item.
call s:h("PmenuSel", { "bg": s:black }) " Popup menu: selected item.
call s:h("PmenuSbar", { "bg": s:special_grey }) " Popup menu: scrollbar.
call s:h("PmenuThumb", { "bg": s:white }) " Popup menu: Thumb of the scrollbar.
call s:h("Question", { "fg": s:purple }) " hit-enter prompt and yes/no questions
call s:h("Search", { "fg": s:black, "bg": s:yellow }) " Last search pattern highlighting (see 'hlsearch'). Also used for highlighting the current line in the quickfix window and similar items that need to stand out.
call s:h("SpecialKey", { "fg": s:special_grey }) " Meta and special keys listed with ":map", also for text used to show unprintable characters in the text, 'listchars'. Generally: text that is displayed differently from what it really is.
call s:h("SpellBad", { "fg": s:red, "gui": "underline", "cterm": "underline" }) " Word that is not recognized by the spellchecker. This will be combined with the highlighting used otherwise.
call s:h("SpellCap", { "fg": s:dark_yellow }) " Word that should start with a capital. This will be combined with the highlighting used otherwise.
call s:h("SpellLocal", { "fg": s:dark_yellow }) " Word that is recognized by the spellchecker as one that is used in another region. This will be combined with the highlighting used otherwise.
call s:h("SpellRare", { "fg": s:dark_yellow }) " Word that is recognized by the spellchecker as one that is hardly ever used. spell This will be combined with the highlighting used otherwise.
call s:h("StatusLine", { "fg": s:white, "bg": s:cursor_grey }) " status line of current window
call s:h("StatusLineNC", { "fg": s:comment_grey }) " status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
call s:h("TabLine", { "fg": s:comment_grey }) " tab pages line, not active tab page label
call s:h("TabLineFill", {}) " tab pages line, where there are no labels
call s:h("TabLineSel", { "fg": s:white }) " tab pages line, active tab page label
call s:h("Title", { "fg": s:green }) " titles for output from ":set all", ":autocmd" etc.
call s:h("Visual", { "fg": s:visual_black, "bg": s:visual_grey }) " Visual mode selection
call s:h("VisualNOS", { "bg": s:visual_grey }) " Visual mode selection when vim is "Not Owning the Selection". Only X11 Gui's gui-x11 and xterm-clipboard supports this.
call s:h("WarningMsg", { "fg": s:red }) " warning messages
call s:h("WildMenu", {}) " current match in 'wildmenu' completion

" +--------------------------------+
" | Language-Specific Highlighting |
" +--------------------------------+

" CSS
call s:h("cssAttrComma", { "fg": s:purple })
call s:h("cssAttributeSelector", { "fg": s:green })
call s:h("cssBraces", { "fg": s:white })
call s:h("cssClassName", { "fg": s:dark_yellow })
call s:h("cssClassNameDot", { "fg": s:dark_yellow })
call s:h("cssDefinition", { "fg": s:purple })
call s:h("cssFontAttr", { "fg": s:dark_yellow })
call s:h("cssFontDescriptor", { "fg": s:purple })
call s:h("cssFunctionName", { "fg": s:blue })
call s:h("cssIdentifier", { "fg": s:blue })
call s:h("cssImportant", { "fg": s:purple })
call s:h("cssInclude", { "fg": s:white })
call s:h("cssIncludeKeyword", { "fg": s:purple })
call s:h("cssMediaType", { "fg": s:dark_yellow })
call s:h("cssProp", { "fg": s:white })
call s:h("cssPseudoClassId", { "fg": s:dark_yellow })
call s:h("cssSelectorOp", { "fg": s:purple })
call s:h("cssSelectorOp2", { "fg": s:purple })
call s:h("cssTagName", { "fg": s:red })

" HTML
call s:h("Title", { "fg": s:white })
call s:h("htmlArg", { "fg": s:dark_yellow })
call s:h("htmlEndTag", { "fg": s:white })
call s:h("htmlH1", { "fg": s:white })
call s:h("htmlLink", { "fg": s:purple })
call s:h("htmlSpecialChar", { "fg": s:dark_yellow })
call s:h("htmlSpecialTagName", { "fg": s:red })
call s:h("htmlTag", { "fg": s:white })
call s:h("htmlTagName", { "fg": s:red })

" JavaScript
call s:h("javaScriptBraces", { "fg": s:white })
call s:h("javaScriptFunction", { "fg": s:purple })
call s:h("javaScriptIdentifier", { "fg": s:purple })
call s:h("javaScriptNull", { "fg": s:dark_yellow })
call s:h("javaScriptNumber", { "fg": s:dark_yellow })
call s:h("javaScriptRequire", { "fg": s:cyan })
call s:h("javaScriptReserved", { "fg": s:purple })
" https://github.com/pangloss/vim-javascript
call s:h("jsArrowFunction", { "fg": s:purple })
call s:h("jsClassKeywords", { "fg": s:purple })
call s:h("jsDocParam", { "fg": s:blue })
call s:h("jsDocTags", { "fg": s:purple })
call s:h("jsFuncCall", { "fg": s:blue })
call s:h("jsFunction", { "fg": s:purple })
call s:h("jsGlobalObjects", { "fg": s:yellow })
call s:h("jsModuleWords", { "fg": s:purple })
call s:h("jsModules", { "fg": s:purple })
call s:h("jsNull", { "fg": s:dark_yellow })
call s:h("jsOperator", { "fg": s:purple })
call s:h("jsStorageClass", { "fg": s:purple })
call s:h("jsTemplateBraces", { "fg": s:dark_red })
call s:h("jsTemplateVar", { "fg": s:green })
call s:h("jsThis", { "fg": s:red })
call s:h("jsUndefined", { "fg": s:dark_yellow })
" https://github.com/othree/yajs.vim
call s:h("javascriptArrowFunc", { "fg": s:purple })
call s:h("javascriptClassExtends", { "fg": s:purple })
call s:h("javascriptClassKeyword", { "fg": s:purple })
call s:h("javascriptDocNotation", { "fg": s:purple })
call s:h("javascriptDocParamName", { "fg": s:blue })
call s:h("javascriptDocTags", { "fg": s:purple })
call s:h("javascriptEndColons", { "fg": s:white })
call s:h("javascriptExport", { "fg": s:purple })
call s:h("javascriptFuncArg", { "fg": s:white })
call s:h("javascriptFuncKeyword", { "fg": s:purple })
call s:h("javascriptIdentifier", { "fg": s:red })
call s:h("javascriptImport", { "fg": s:purple })
call s:h("javascriptObjectLabel", { "fg": s:white })
call s:h("javascriptOpSymbol", { "fg": s:cyan })
call s:h("javascriptOpSymbols", { "fg": s:cyan })
call s:h("javascriptPropertyName", { "fg": s:green })
call s:h("javascriptTemplateSB", { "fg": s:dark_red })
call s:h("javascriptVariable", { "fg": s:purple })

" JSON
call s:h("jsonCommentError", { "fg": s:white })
call s:h("jsonKeyword", { "fg": s:red })
call s:h("jsonQuote", { "fg": s:white })
call s:h("jsonMissingCommaError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonNoQuotesError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonNumError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonString", { "fg": s:green })
call s:h("jsonStringSQError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonSemicolonError", { "fg": s:red, "gui": "reverse" })

" Markdown
call s:h("markdownCode", { "fg": s:green })
call s:h("markdownCodeBlock", { "fg": s:green })
call s:h("markdownCodeDelimiter", { "fg": s:green })
call s:h("markdownHeadingDelimiter", { "fg": s:red })
call s:h("markdownRule", { "fg": s:comment_grey })
call s:h("markdownHeadingRule", { "fg": s:comment_grey })
call s:h("markdownH1", { "fg": s:red })
call s:h("markdownH2", { "fg": s:red })
call s:h("markdownH3", { "fg": s:red })
call s:h("markdownH4", { "fg": s:red })
call s:h("markdownH5", { "fg": s:red })
call s:h("markdownH6", { "fg": s:red })
call s:h("markdownIdDelimiter", { "fg": s:purple })
call s:h("markdownId", { "fg": s:purple })
call s:h("markdownBlockquote", { "fg": s:comment_grey })
call s:h("markdownItalic", { "fg": s:purple, "gui": "italic", "cterm": "italic" })
call s:h("markdownBold", { "fg": s:dark_yellow, "gui": "bold", "cterm": "bold" })
call s:h("markdownListMarker", { "fg": s:red })
call s:h("markdownOrderedListMarker", { "fg": s:red })
call s:h("markdownIdDeclaration", { "fg": s:blue })
call s:h("markdownLinkText", { "fg": s:blue })
call s:h("markdownLinkDelimiter", { "fg": s:white })
call s:h("markdownUrl", { "fg": s:purple })

" Ruby
call s:h("rubyBlockParameter", { "fg": s:red})
call s:h("rubyBlockParameterList", { "fg": s:red })
call s:h("rubyClass", { "fg": s:purple})
call s:h("rubyConstant", { "fg": s:yellow})
call s:h("rubyControl", { "fg": s:purple })
call s:h("rubyEscape", { "fg": s:red})
call s:h("rubyFunction", { "fg": s:blue})
call s:h("rubyGlobalVariable", { "fg": s:red})
call s:h("rubyInclude", { "fg": s:blue})
call s:h("rubyIncluderubyGlobalVariable", { "fg": s:red})
call s:h("rubyInstanceVariable", { "fg": s:red})
call s:h("rubyInterpolation", { "fg": s:cyan })
call s:h("rubyInterpolationDelimiter", { "fg": s:red })
call s:h("rubyInterpolationDelimiter", { "fg": s:red})
call s:h("rubyRegexp", { "fg": s:cyan})
call s:h("rubyRegexpDelimiter", { "fg": s:cyan})
call s:h("rubyStringDelimiter", { "fg": s:green})
call s:h("rubySymbol", { "fg": s:cyan})

" Sass
call s:h("sassAmpersand", { "fg": s:red })
call s:h("sassClass", { "fg": s:dark_yellow })
call s:h("sassControl", { "fg": s:purple })
call s:h("sassExtend", { "fg": s:purple })
call s:h("sassFor", { "fg": s:white })
call s:h("sassFunction", { "fg": s:cyan })
call s:h("sassId", { "fg": s:blue })
call s:h("sassInclude", { "fg": s:purple })
call s:h("sassMedia", { "fg": s:purple })
call s:h("sassMediaOperators", { "fg": s:white })
call s:h("sassMixin", { "fg": s:purple })
call s:h("sassMixinName", { "fg": s:blue })
call s:h("sassMixing", { "fg": s:purple })

" XML
call s:h("xmlAttrib", { "fg": s:dark_yellow })
call s:h("xmlEndTag", { "fg": s:red })
call s:h("xmlTag", { "fg": s:red })
call s:h("xmlTagName", { "fg": s:red })

" +---------------------+
" | Plugin Highlighting |
" +---------------------+

" mhinz/vim-signify
call s:h("SignifySignAdd", { "fg": s:green })
call s:h("SignifySignChange", { "fg": s:yellow })
call s:h("SignifySignDelete", { "fg": s:red })

" airblade/vim-gitgutter
hi link GitGutterAdd    SignifySignAdd
hi link GitGutterChange SignifySignChange
hi link GitGutterDelete SignifySignDelete

" tpope/vim-fugitive
call s:h("diffAdded", { "fg": s:green })
call s:h("diffRemoved", { "fg": s:red })

" +------------------+
" | Git Highlighting |
" +------------------+

call s:h("gitcommitComment", { "fg": s:comment_grey })
call s:h("gitcommitUnmerged", { "fg": s:green })
call s:h("gitcommitOnBranch", {})
call s:h("gitcommitBranch", { "fg": s:purple })
call s:h("gitcommitDiscardedType", { "fg": s:red })
call s:h("gitcommitSelectedType", { "fg": s:green })
call s:h("gitcommitHeader", {})
call s:h("gitcommitUntrackedFile", { "fg": s:cyan })
call s:h("gitcommitDiscardedFile", { "fg": s:red })
call s:h("gitcommitSelectedFile", { "fg": s:green })
call s:h("gitcommitUnmergedFile", { "fg": s:yellow })
call s:h("gitcommitFile", {})
hi link gitcommitNoBranch gitcommitBranch
hi link gitcommitUntracked gitcommitComment
hi link gitcommitDiscarded gitcommitComment
hi link gitcommitSelected gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow gitcommitSelectedFile
hi link gitcommitUnmergedArrow gitcommitUnmergedFile

" +------------------------+
" | Neovim terminal colors |
" +------------------------+

if has("nvim")
  let g:terminal_color_0 =  s:black.gui
  let g:terminal_color_1 =  s:red.gui
  let g:terminal_color_2 =  s:green.gui
  let g:terminal_color_3 =  s:yellow.gui
  let g:terminal_color_4 =  s:blue.gui
  let g:terminal_color_5 =  s:purple.gui
  let g:terminal_color_6 =  s:cyan.gui
  let g:terminal_color_7 =  s:white.gui
  let g:terminal_color_8 =  s:visual_grey.gui
  let g:terminal_color_9 =  s:dark_red.gui
  let g:terminal_color_10 = s:green.gui " No dark version
  let g:terminal_color_11 = s:dark_yellow.gui
  let g:terminal_color_12 = s:blue.gui " No dark version
  let g:terminal_color_13 = s:purple.gui " No dark version
  let g:terminal_color_14 = s:cyan.gui " No dark version
  let g:terminal_color_15 = s:comment_grey.gui
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_7

  " +--------------------+
  " | Nvim Lsp Reference |
  " +--------------------+
  call s:h("LspReferenceText",{"bg": s:visual_grey})  " Used for highlighting 'text' references
  call s:h("LspReferenceRead",{"bg": s:visual_grey})  " Used for highlighting 'read' references
  call s:h("LspReferenceWrite",{"bg": s:visual_grey}) " Used for highlighting 'write' references
  call s:h("LspCodeLens",{"fg": s:comment_grey})
  call s:h("LspSignatureActiveParameter",{"fg": s:dark_yellow})

  " +---------------------+
  " | Nvim Lsp Diagnostic |
  " +---------------------+
  call s:h("DiagnosticError",{"fg": s:dark_red}) " Used as the base highlight group. Other Diagnostic highlights link to this by default
  call s:h("DiagnosticWarn",{"fg": s:yellow})    " Used as the base highlight group. Other Diagnostic highlights link to this by default
  call s:h("DiagnosticInfo",{"fg": s:blue})      " Used as the base highlight group. Other Diagnostic highlights link to this by default
  call s:h("DiagnosticHint",{"fg": s:cyan})      " Used as the base highlight group. Other Diagnostic highlights link to this by default

  call s:h("DiagnosticUnderlineError" , { "style" : "undercurl", "sp" : s:red })   " Used to underline 'Error' diagnostics
  call s:h("DiagnosticUnderlineWarn" , { "style" : "undercurl", "sp" : s:yellow }) " Used to underline 'Warning' diagnostics
  call s:h("DiagnosticUnderlineInfo" , { "style" : "undercurl", "sp" : s:blue })   " Used to underline 'Information' diagnostics
  call s:h("DiagnosticUnderlineHint" , { "style" : "undercurl", "sp" : s:cyan })   " Used to underline 'Hint' diagnostics

  call s:h("DiagnosticVirtualTextError" , { "bg" : s:dark_red, "fg" : s:red })      " Used for 'Error' diagnostic virtual text
  call s:h("DiagnosticVirtualTextWarn" , { "bg" : s:dark_yellow, "fg" : s:yellow }) " Used for 'Warning' diagnostic virtual text
  call s:h("DiagnosticVirtualTextInfo" , { "bg" : s:blue, "fg" : s:blue })          " Used for 'Information' diagnostic virtual text
  call s:h("DiagnosticVirtualTextHint" , { "bg" : s:cyan, "fg" : s:cyan })          " Used for 'Hint' diagnostic virtual text

  " This is the old way of Lsp diagnostics highlights
  call s:h("LspDiagnosticsVirtualTextError",{"fg": s:dark_red})
  call s:h("LspDiagnosticsError",{"fg": s:dark_red})

  call s:h("LspDiagnosticsWarning",{"fg": s:yellow})
  call s:h("LspDiagnosticsVirtualTextWarning",{"fg": s:yellow})

  call s:h("LspDiagnosticsInformation",{"fg": s:blue})
  call s:h("LspDiagnosticsVirtualTextInformation",{"fg": s:blue})

  call s:h("LspDiagnosticsHint",{"fg": s:green})
  call s:h("LspDiagnosticsVirtualTextHint",{"fg": s:green})
endif

