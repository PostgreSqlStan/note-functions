nnote () {
	local _version='0.1'
	emulate -LR zsh
	local flag_help flag_version flag_bullet flag_dts arg_note flag_squeeze
	local flag_paste
	local usage=(
		"nnote  - add entry to default note"
		" "
		"Usage:"
		"  nnote [OPTIONS] [TEXT]       add entry to default note"
		" "
		"Options:"
		"  -b --bullet                  include bullet"
		"  -d --datetime                include date/time"
		"  -h --help                    show this message"
		"  -n --note NOTE               set default to NOTE"
		"  -s --squeeze                 no empty line before entry"
		"  -v --paste                   add clipboard to entry"
		"  --version                    show version"
		" "
		"Environment parameters:"
		"  NOTE_HOME                    notes directory, default={HOME}/notes"
		"  NOTE_NAME                    note to create/append, set with -n option"
		"  NOTE_BULLET                  default='▶️  '"
		" "
		"The -n option set the default note for the current shell session: "
		" "
		"  nnote -n example Entry Example"
		"  nnote 2nd entry"
		" "
		"Piped text is added to a note entry:"
		" "
		"  print piped text | nnote Pipe Example"
		" "
		"Use -v to add the clipboard to an entry:"
		" "
		"  print pasted text | pbcopy && nnote -v Clipboard Example"
		" "
		"The -b and -d options add a bullet and stampstamp:"
		" "
		"  nnote -bd Bullet Timestamp Example"
		" "
		"If the -n option has not be used and NOTE_NAME is not set, a note "
		"named with the current date (yyyymmdd_note) is used."
		" "
		"See repo for updates, comments, issues, etc:"
		"  https://github.com/PostgreSqlStan/note-functions"
	)
	zmodload zsh/zutil
	zparseopts -D -F -- {h,-help}=flag_help -version=flag_version \
		{b,-bullet}=flag_bullet {d,-datetime}=flag_dts {n,-note}:=arg_note \
		{s,-squeeze}=flag_squeeze {v,-paste}=flag_paste \
		|| return 1
	[[ -z "$flag_help" ]] || { print -l $usage && return }
	[[ -n "$flag_version" ]] && { print "${0} version ${_version}" && return }

	## MAIN ##
	local note_bullet=${NOTE_BULLET:-'▶️  '}
	local note_home=${NOTE_HOME:-~/notes}

	# note option (-n): set NOTE_NAME
	[[ -n "$arg_note" ]] && export NOTE_NAME=${arg_note[-1]}
	local note_name=${NOTE_NAME:-$(date "+%Y%m%d")"_note"}

	local header
	[[ -n "$flag_bullet" ]] && header=${header}${note_bullet}
	[[ -n "$flag_dts"  ]] && header=${header}'['$(date)'] '
	[[ -n $@ ]] && header=${header}"${@}"

	local msg
	local pasted
	[[ -p "/dev/stdin" ]] && msg="$(cat)"
	[[ -n "$flag_paste" ]] && pasted="$(pbpaste | col -b)"

	[[ -n "$msg" ]] && [[ -n "$pasted" ]] && msg="${msg}""\n"
	msg="${msg}""${pasted}"

	# add '\n' to header if header & msg not empty
	[[ -n "$header" ]] && [[ -n "$msg" ]] && header=${header}"\n"

	# prepend '\n' if note exists & not --squeeze
	[[ -a "${note_home}/${note_name}" ]] && [[ -z "$flag_squeeze" ]] \
		&& header='\n'${header}

	print -- "${header}${msg}" >> ${note_home}/${note_name}
}
