get_time() {
	tail -1 $HOME/.config/nvim/startup/tmp | cut -d ' ' -f 1
}
pf() {
	printf '%s : ' "$@"
}

nvim --startuptime tmp
get_time



