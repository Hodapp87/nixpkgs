{ stdenv
, requireFile
, cudatoolkit
, fetchurl
}:

stdenv.mkDerivation rec {
  version = "6.0";
  cudatoolkit_version = "8.0";

  name = "cudatoolkit-${cudatoolkit_version}-cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-8.0-linux-x64-v${version}.tgz";
    message = '' 
      This nix expression requires that ${name} is
      already part of the store. Register yourself to NVIDIA Accelerated Computing Developer Program
      and download cuDNN library at https://developer.nvidia.com/cudnn, and store it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';  
    #url = "https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v6/prod/8.0_20170307/cudnn-8.0-linux-x64-v6.0-tgz";
    sha256 = "173zpgrk55ri8if7s5yngsc89ajd6hz4pss4cdxlv6lcyh5122cv";
  };

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}" $1
    }
    fixRunPath lib64/libcudnn.so

    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  meta = with stdenv.lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = https://developer.nvidia.com/cudnn;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ mdaiter ];
  };
}
