{ stdenv, fetchFromGitHub, cmake, pkgconfig, eigen3_3, zlib
, libpng, boost, qt5, guile
}:

stdenv.mkDerivation rec {
  name = "libfive-${version}";
  version = "4aeba487";

  src = fetchFromGitHub {
    owner  = "libfive";
    repo   = "libfive";
    rev    = "7a46e316ecc755bb3597f4f3ca84e7ea9a8e75b8";
    sha256 = "1cjvmfsjbc3k5zfp22zccmjx0b2rmm2a0vm555f3bqj81yw9v7ps";
  };  
  buildInputs = [ cmake pkgconfig eigen3_3 zlib libpng
                  boost qt5.qtimageformats guile ];

  enableParallelBuilding = true;

  # Rename "Studio" binary to "libfive-studio" to be more obvious
  postFixup = ''
    mv "$out/bin/Studio" "$out/bin/libfive-studio"
  '';
  
  meta = with stdenv.lib; {
    description = "Infrastructure for solid modeling with F-Reps";
    homepage = https://libfive.com/;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.lpgl2;
    platforms = platforms.linux;
  };
}
