{ stdenv
, fetchurl
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {

  pname = "tf_slim";
  version = "09a32f32";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "models";
      rev = "09a32f32905c47b7c7453d6438b7c3cf758f4675";
      sha256 = "0hcy7vlf0kag5w4q9mnfkp0flzjg14xf1ysbdhkpkj340md2lzbs";
  };
  
  buildInputs = with stdenv.lib;
    [  ];

  preConfigure = "cd slim";

  #postPatch = ''
  #  2to3 -w nets/mobilenet_v1_test.py
  #'';

  doCheck = false;
   
  meta = with stdenv.lib; {
    description = "TensorFlow-Slim image classification library";
    homepage = https://github.com/tensorflow/models/tree/master/slim;
    license = licenses.asl20;
    maintainers = with maintainers; [ hodapp ];
    platforms = with platforms; linux ++ darwin;
  };
}
