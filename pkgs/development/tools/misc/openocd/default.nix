{ stdenv, fetchFromGitHub, libftdi, libusb1, pkgconfig, hidapi,
  autoconf, automake, libtool, which }:

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "esp32-1821e343";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "openocd-esp32";
    rev = "1821e343afd655c6737e8fdc6dfc0eeebbb38026";
    sha256 = "0baqfprk1027549pj9xjj44930vhnzsxi5sbgl9x03zasdc6f7vn";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig autoconf automake libtool which ];
  buildInputs = [ libftdi libusb1 hidapi ];

  configureFlags = [
    "--enable-jtag_vpi"
    "--enable-usb_blaster_libftdi"
    "--enable-amtjtagaccel"
    "--enable-gw16012"
    "--enable-presto_libftdi"
    "--enable-openjtag_ftdi"
    "--enable-oocd_trace"
    "--enable-buspirate"
    "--enable-sysfsgpio"
    "--enable-remote-bitbang"
  ];
  
  preConfigure = ''
    SKIP_SUBMODULE=1 ./bootstrap
  '';

  NIX_CFLAGS_COMPILE = [
    "-Wno-implicit-fallthrough"
    "-Wno-format-truncation"
    "-Wno-format-overflow"
  ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = with stdenv.lib; {
    description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing";
    longDescription = ''
      OpenOCD provides on-chip programming and debugging support with a layered
      architecture of JTAG interface and TAP support, debug target support
      (e.g. ARM, MIPS), and flash chip drivers (e.g. CFI, NAND, etc.).  Several
      network interfaces are available for interactiving with OpenOCD: HTTP,
      telnet, TCL, and GDB.  The GDB server enables OpenOCD to function as a
      "remote target" for source-level debugging of embedded systems using the
      GNU GDB program.
    '';
    homepage = http://openocd.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
