" Location: plugin/rbnew
" Author:   Joakim Reinert <mail+rbnew@jreinert.com>
" Version:  1.0
" Licence:  MIT

if exists("g:loaded_rbnew") || &cp
  finish
endif

let g:loaded_rbnew = 1

" Utility Functions {{{
fun! s:constant_split(constant)
	split(a:constant, '::')
endfun

fun! s:underscore(string)
	let parts = s:constant_split(string)
	call map(parts, 'tolower(substitute(v:val, "[a-z]\@<=[A-Z]", "_&", "g"))')
	return join(parts, '/')
endfun

fun! s:template(type, constant)
	let parts = s:constant_split(constant)
	let modules = parts[:-2]
	let inner_constant = parts[-1]
	let padding = ''
	let begin_lines = []
	let end_lines = []

	for module in modules
		call add(begin_lines, padding . 'module ' . part)
		call insert(end_lines, padding . 'end')
		let padding .= '  '
	endfor

	let inner_line = padding . a:type . ' ' . inner_constant
	call extend(begin_lines, [inner_line, padding . '  '])
	call insert(end_lines, padding . 'end')

	return begin_lines + end_lines
endfun

fun! s:dirname(path)
	return substitute(path, '\(.*\)/.*', '\1', '')
endfun

fun! s:prompt_root()
	call inputsave()
	let root = ''
	if !empty(glob('app'))
		let root = 'app'
	elseif !empty(glob('lib'))
		let root = 'lib'
	endif
	let root = input('Root: ', root, 'dir')
	call inputrestore()

	return root
endfun

fun! s:create_dir(dir)
	if empty(glob(a:dir))
		call mkdir(a:dir, 'p')
	endif
endfun

fun! s:file_exists(file)
	return !empty(glob(a:file))
endfun

fun! s:inner_line(constant)
	return len(s:constant_split(a:constant)) + 1
endfun
" }}}
"
fun! rbnew#rbnew(type, constant)
	let root = s:prompt_root()
	let file_path = join([root, s:underscore(a:constant) . '.rb'], '/')
	let directory_path = s:dirname(file_path)
	call s:create_dir(directory_path)
	silent exe 'edit ' . file

	if s:file_exists(file_path)
		echo 'The file "' . file_path . '" already exists.'
		return
	endif

	call append(0, s:template(a:type, a:constant))
	normal dd
	call cursor([s:inner_line(a:constant), 0])
	start!
endfun

com! -nargs=* Rbnew :call rbnew#rbnew(<f-args>)
