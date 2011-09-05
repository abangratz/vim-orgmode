syn match org_todo_key /\[\zs[^]]*\ze\]/
hi def link org_todo_key Identifier

let s:todo_headings = ''
let s:i = 1
while s:i <= g:org_heading_highlight_levels
	if s:todo_headings == ''
		let s:todo_headings = 'containedin=org_heading' . s:i
	else
		let s:todo_headings = s:todo_headings . ',org_heading' . s:i
	endif
	let s:i += 1
endwhile
unlet! s:i

if !exists('g:loaded_orgtodo_syntax')
	let g:loaded_orgtodo_syntax = 1
	function! s:ReadTodoKeywords(keywords, todo_headings)
		let l:default_group = 'Todo'
		for l:i in a:keywords
			if type(l:i) == 3
				call s:ReadTodoKeywords(l:i, a:todo_headings)
				continue
			endif
			if l:i == '|'
				let l:default_group = 'Question'
				continue
			endif
			" strip access key
			let l:_i = substitute(l:i, "\(.*$", "", "")

			let l:group = l:default_group
			for l:j in g:org_todo_keyword_faces
				if l:j[0] == l:_i
					let l:group = 'orgtodo_todo_keyword_face_' . l:_i
					call OrgExtendHighlightingGroup(l:default_group, l:group, OrgInterpretFaces(l:j[1]))
					break
				endif
			endfor
			exec 'syntax match orgtodo_todo_keyword_' . l:_i . ' /' . l:_i .'/ ' . a:todo_headings
			exec 'hi def link orgtodo_todo_keyword_' . l:_i . ' ' . l:group
		endfor
	endfunction
endif

call s:ReadTodoKeywords(g:org_todo_keywords, s:todo_headings)
unlet! s:todo_headings

" Timestamps
syn match org_timestamp /^\(<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a>\)/
syn match org_timestamp /^\(<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a \d\d:\d\d>\)/

syn match org_timestamp /^\(<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a>--<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a>\)/
syn match org_timestamp /^\(<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a \d\d:\d\d>--<\d\{4\}-\d\{2\}-\d\{2\} \a\a\a \d\d:\d\d>\)/
syn match org_timestamp /^\(<%%(diary-float.\+>\)/

hi def link org_timestamp PreProc

" special words
syn match today /TODAY$/
hi def link today PreProc

syn match week_agenda /^Week Agenda:$/
hi def link week_agenda PreProc

" Hyperlinks
syntax match hyperlink	"\[\{2}[^][]*\(\]\[[^][]*\)\?\]\{2}" contains=hyperlinkBracketsLeft,hyperlinkURL,hyperlinkBracketsRight containedin=ALL
syntax match hyperlinkBracketsLeft		contained "\[\{2}" conceal
syntax match hyperlinkURL				contained "[^][]*\]\[" conceal
syntax match hyperlinkBracketsRight		contained "\]\{2}" conceal
hi def link hyperlink Underlined