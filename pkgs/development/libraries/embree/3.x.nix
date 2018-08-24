{ stdenv, fetchFromGitHub, cmake, pkgconfig, ispc, tbb, glfw,
openimageio, libjpeg, libpng, libpthreadstubs, libX11
}:

stdenv.mkDerivation rec {
  name = "embree-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v3.2.0";
    sha256 = "1z8gxwwxqvbj1f0v55isg4nq1y5v7dsvd4mxdcgwcvvz1050drbb";
  };

  cmakeFlags = [ "-DEMBREE_TUTORIALS=OFF" ];
  enableParallelBuilding = true;
  
  buildInputs = [ pkgconfig cmake ispc tbb glfw openimageio libjpeg libpng libX11 libpthreadstubs ];
  meta = with stdenv.lib; {
    description = "High performance ray tracing kernels from Intel"; 
    homepage = https://embree.github.io/;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
