if [[ $OS = Linux ]]; then
	for file in $ZSH/custom/linux/*.zsh; do
		source $file
	done
else
	for file in $ZSH/custom/mac/*.zsh; do
		source $file
	done
fi
