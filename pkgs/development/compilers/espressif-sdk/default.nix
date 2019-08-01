{ stdenv, fetchFromGitHub, gawk, gperf, gettext, python, automake,
  autoconf, git, which, unzip, file, ncurses,
  pkgconfig, bison, flex, texinfo, help2man, libtool }:

stdenv.mkDerivation rec {
  name = "espressif-sdk-${version}";
  version = "esp32-2019r1-rc2";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "crosstool-NG";
    rev = "esp32-2019r1-rc2";
    sha256 = "154fxcx18b323927mr98g8dq99sb9n2pjgh36hk8xhr4ikq51d1v";
    #fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig autoconf automake libtool bison flex git which texinfo unzip help2man file ncurses ];
  buildInputs = [ ];

  configureFlags = [
    "--enable-local"
  ];
  
  preConfigure = ''
    bash ./bootstrap
  '';

  installPhase = ''
    make install
    ./ct-ng xtensa-esp32-elf
    ./ct-ng build
  '';

  meta = with stdenv.lib; {
    description = "";
    longDescription = ''
    '';
    homepage = http://openocd.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
