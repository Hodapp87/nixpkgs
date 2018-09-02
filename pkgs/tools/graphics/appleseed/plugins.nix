{ stdenv, fetchFromGitHub, cmake, boost165, openexr,
openimageio, osl, appleseed
}:

# To use this, you need "nix-shell -p appleseed appleseed-plugins" and
# then to set APPLESEED_SEARCHPATH to the /lib directory of
# appleseed-plugins.  For now, run 'which heightfield' to find the
# path to /bin, and adjust accordingly.
# TODO: Figure out how to get that path more easily.

let boost_static = boost165.override {
      enableStatic = true;
      enablePython = true;
    };
in stdenv.mkDerivation rec {

  name = "appleseed-plugins-${version}";
  version = "1.9.0-beta";

  src = fetchFromGitHub {
    owner  = "appleseedhq";
    repo   = "appleseed";
    rev    = "1.9.0-beta";
    sha256 = "0m7zvfkdjfn48zzaxh2wa1bsaj4l876a05bzgmjlfq5dz3202anr";
  };
  buildInputs = [ boost_static appleseed openimageio osl openexr cmake ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/sandbox/samples/cpp
    cat << EOF > $sourceRoot/CMakeLists.txt
add_subdirectory(sphereflake)
add_subdirectory(heightfield)
add_subdirectory(distancefieldobject)
add_subdirectory(sphereobject)
add_subdirectory(infiniteplaneobject)
# Broken:
# add_subdirectory(alembicassembly)
add_subdirectory(basic)
EOF
  '';

  installPhase = ''
mkdir -p $out/lib $out/bin
cp basic/basic $out/bin
cp heightfield/heightfield $out/bin
cp distancefieldobject/*.so $out/lib
cp infiniteplaneobject/*.so $out/lib
cp sphereflake/*.so $out/lib
cp sphereobject/*.so $out/lib
  '';

  cmakeFlags = [
      "-DUSE_STATIC_BOOST=OFF"
      "-DBoost_SYSTEM_LIBRARY_RELEASE=${boost_static}/lib/libboost_system-mt.so.1.65.1"
      "-DAPPLESEED_INCLUDE_DIR=${appleseed}/include"
      "-DAPPLESEED_LIBRARY=${appleseed}/lib/libappleseed.so"
  ];
  # TODO: How do I avoid hard-coding 1.6.5.1 above?

  meta = with stdenv.lib; {
    description = "Plugins and dev environment for Appleseed renderer";
    homepage = https://appleseedhq.net/;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.mit;
    platforms = platforms.linux;
  };

  postInstall = ''
    chmod a+x $out/bin/*
  '';
}
