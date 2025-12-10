web_test:
	lime test html5 -debug -clean
build_web:
	lime build html5 -clean
build_win:
	lime build windows -clean
build_linux:
	lime build linux -clean
build_mac:
	lime build mac -clean
