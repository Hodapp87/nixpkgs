{ stdenv
, fetchurl
, buildPythonPackage
, isPy35, isPy27
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, linuxPackages ? null
, numpy
, six
, protobuf3_3
, swig
, werkzeug
, mock
, tensorflow_tensorboard
, markdown
, html5lib_0_9999999
, bleach_150
, zlib
}:

# TODO, CMH: Perhaps look at
# pkgs/development/libraries/protobuf/generic.nix for an example of
# how to factor out common things

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && linuxPackages != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.

buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.3.0";
  name = "${pname}-${version}";
  format = "wheel";
  disabled = ! (isPy35 || isPy27);

  src = let
      tfurl = sys: proc: pykind:
        let
          tfpref = if proc == "gpu"
            then "gpu/tensorflow_gpu"
            else "cpu/tensorflow";
        in
        "https://storage.googleapis.com/tensorflow/${sys}/${tfpref}-${version}-${pykind}.whl";
      dls =
        {
        darwin.cpu = {
          py2 = {
            url = tfurl "mac" "cpu" "py2-none-any" ;
            sha256 = "0nkymqbqjx8rsmc8vkc26cfsg4hpr6lj9zrwhjnfizvkzbbsh5z4";
          };
          py3 = {
            url = tfurl "mac" "cpu" "py3-none-any" ;
            sha256 = "1rj4m817w3lajnb1lgn3bwfwwk3qwvypyx11dim1ybakbmsc1j20";
          };
        };
        linux-x86_64.cpu = {
          py2 = {
            url = tfurl "linux" "cpu" "cp27-none-linux_x86_64";
            sha256 = "09pcyx0yfil4dm6cij8n3907pfgva07a38avrbai4qk5h6hxm8w9";
          };
          py3 = {
            url = tfurl "linux" "cpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0p10zcf41pi33bi025fibqkq9rpd3v0rrbdmc9i9yd7igy076a07";
          };
        };
        linux-x86_64.cuda = {
          py2 = {
            url = tfurl "linux" "gpu" "cp27-none-linux_x86_64";
            sha256 = "10yyyn4g2fsv1xgmw99bbr0fg7jvykay4gb5pxrrylh7h38h6wah";
          };
          py3 = {
            url = tfurl "linux" "gpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0icwnhkcf3fxr6bmbihqzipnn4pxybd06qv7l3k0p4xdgycwzmzk";
          };
        };
      };
    in
    fetchurl (
      if stdenv.isDarwin then
        if isPy35 then
          dls.darwin.cpu.py3
        else
          dls.darwin.cpu.py2
      else if isPy35 then
        if cudaSupport then
          dls.linux-x86_64.cuda.py3
        else dls.linux-x86_64.cpu.py3
      else
        if cudaSupport then
          dls.linux-x86_64.cuda.py2
        else
          dls.linux-x86_64.cpu.py2
    );

  buildInputs = [ tensorflow_tensorboard bleach_150 html5lib_0_9999999];
  propagatedBuildInputs = with stdenv.lib;
    [ markdown numpy six protobuf3_3 swig werkzeug mock ]
    ++ optionals cudaSupport [ cudatoolkit cudnn stdenv.cc ];

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup = let
    rpath = stdenv.lib.makeLibraryPath
      (if cudaSupport then
        [ stdenv.cc.cc.lib zlib cudatoolkit cudnn
          linuxPackages.nvidia_x11 ]
      else
        [ stdenv.cc.cc.lib zlib ]
      );
  in
  ''
    find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpbernardy ];
    platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
  };
}
