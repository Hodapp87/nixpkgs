{ stdenv
, fetchurl
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, isPy27
, protobuf3_2
, pillow
, lxml
, matplotlib
, jupyter
, tensorflow
, tf_slim
}:

buildPythonPackage rec {

  pname = "tensorflow_object_detection";
  version = "09a32f32";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "models";
      rev = "09a32f32905c47b7c7453d6438b7c3cf758f4675";
      sha256 = "0hcy7vlf0kag5w4q9mnfkp0flzjg14xf1ysbdhkpkj340md2lzbs";
  };
  
  disabled = ! (isPy3k || isPy27);
  
  buildInputs = with stdenv.lib;
    [ pillow lxml matplotlib jupyter tensorflow ];
  propagatedBuildInputs = [ tf_slim ];

  # TODO (maybe):
  # https://github.com/tensorflow/models/blob/master/object_detection/g3doc/installation.md#protobuf-compilation

  postPatch = ''
    echo --------------------
    protoc object_detection/protos/*.proto --python_out=.
    ls object_detection/protos
    echo ---------------------
  '';
    
  patchPhase = if isPy3k then ''
    runHook prePatch

    2to3 -w cognitive_mapping_and_planning/scripts/script_env_vis.py
    2to3 -w cognitive_mapping_and_planning/scripts/script_plot_trajectory.py
    2to3 -w cognitive_mapping_and_planning/src/utils.py
    2to3 -w real_nvp/real_nvp_multiscale_dataset.py
    2to3 -w real_nvp/lsun_formatting.py
    2to3 -w real_nvp/imnet_formatting.py
    2to3 -w real_nvp/celeba_formatting.py
    2to3 -w slim/nets/mobilenet_v1_test.py

    runHook postPatch
  '' else
  ''
    runHook prePatch
    runHook postPatch
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tensorflow Object Detection API";
    homepage = https://github.com/tensorflow/models/tree/master/object_detection;
    license = licenses.asl20;
    maintainers = with maintainers; [ hodapp ];
    platforms = with platforms; linux ++ darwin;
  };
}
