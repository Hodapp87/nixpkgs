{ stdenv, buildPythonPackage, fetchurl, isPy26, argparse, hypothesis, py }:
buildPythonPackage rec {
  version = "3.0.3";
  pname = "pytest";
  name = "${pname}-${version}";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchurl {
    url = "mirror://pypi/p/pytest/${name}.tar.gz";
    sha256 = "1rxydacrdb8s312l3bn0ybrqsjp13abzyim1x21s80386l5504zj";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
