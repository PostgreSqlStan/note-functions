note () {
	local _version='0.1'
	local flag_help flag_version flag_edit
	local usage=(
		"note  - display file(s) stored configurable notes directory"
		" "
		"Usage:"
		"  note NOTE                    show NOTE"
		"  note                         list files in notes directory"
		" "
		"Options:"
		"  -e --edit NOTE               edit note"
		"  -h --help                    show this message"
		"  --version                    show version"
		" "
		"Environment parameters:"
		"  NOTE_HOME                    notes directory, default={HOME}/notes"
		" "
		"See repo for updates, comments, issues, etc:"
		"  https://github.com/PostgreSqlStan/note-functions"
	)
	zmodload zsh/zutil
	zparseopts -D -F -- {h,-help}=flag_help -version=flag_version \
		{e,-edit}=flag_edit \
		|| return 1
	[[ -z "$flag_help" ]] || { print -l $usage && return }
	[[ -n "$flag_version" ]] && { print "${0} version ${_version}" && return }

	## MAIN ##
	local note_home=${NOTE_HOME:-~/notes}
	local editor=(${VISUAL:-${EDITOR:-vi}})

	if [[ -n $* ]]; then
		(
			cd ${note_home}
			if [[ -n "$flag_edit" ]]; then
				eval ${editor} $*
			else
				less -FX $*
			fi
		)
	else
		ls ${note_home}
	fi
}
