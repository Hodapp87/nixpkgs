{ stdenv
, fetchurl
, buildPythonPackage
, isPy3k, isPy27
, numpy
, six
, protobuf3_2
, werkzeug
, markdown
, bleach_150
}:

buildPythonPackage rec {
  pname = "tensorflow_tensorboard";
  version = "0.1.5";
  name = "${pname}-${version}";
  format = "wheel";
  disabled = ! (isPy3k || isPy27);

  src = fetchurl (
      if isPy3k then
      {
          url = "https://pypi.python.org/packages/ff/5a/9865c4e1bb4482f1ed09e80fe46e680c20c11ee0ceef0f5a9ff6007328e4/${name}-py3-none-any.whl";
          sha256 = "0sfia05y1mzgy371faj96vgzhag1rgpa3gnbz9w1fay13jryw26x";
      }
      else
      {
          url = "https://pypi.python.org/packages/a3/4c/c57a272d6fc9a936f5e79e2b2063f355ecafe8b650fd28ff1b4232e3e94e/${name}-py2-none-any.whl";
          sha256 = "0icwnhkcf3fxr6bmbihqzipnn4pxybd06qv7l3k0p4xdgycwzmzk";
      }
    );

  buildInputs = with stdenv.lib;
    [ numpy six protobuf3_2 werkzeug markdown bleach_150 ];

  # doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorBoard lets you watch Tensors Flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ hodapp ];
    platforms = with platforms; linux ++ darwin;
  };
}
