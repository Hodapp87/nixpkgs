{ stdenv, fetchFromGitHub, rsync }:

# Suggested:
# https://github.com/svanderburg/node2nix

stdenv.mkDerivation rec {
  name = "turtl-desktop-${version}";
  version = "cb4f73e";

  src = fetchFromGitHub {
    owner = "turtl";
    repo = "desktop";
    rev = "cb4f73eb3d3d515812bb85b41ef00fbed3a0d82c";
    sha256 = "1m9fb6vd76ywgl4blr1pwbqln8md6rbpc28r9vsss0vbwswwd3hp";
  };

  src_js = fetchFromGitHub {
    owner = "turtl";
    repo = "js";
    rev = "61923ffb47d95d172f80d14c76aa032a4d5f5d6d";
    sha256 = "0d4fnzb7fag7wcv95ca6vsdwh3jm4n1863kk99amrqd1l89i38r3";
  };

  # npm?
  buildInputs = [ rsync ];
  # does nwjs need a version?

  meta = with stdenv.lib; {
    # Do I need to explain Turtl, or just say that it's *for* Turtl?
    description = "Desktop client for Turtl";
    homepage = https://turtlapp.com/;
    longDescription = "Turtl lets you take notes, bookmark websites,
    and store documents for sensitive projects. From sharing passwords
    with your coworkers to tracking research on an article you're
    writing, Turtl keeps it all safe from everyone but you and those
    you share with."
    # It's anywhere that can run nwjs...?
    #platforms = ["i686-linux" "x86_64-linux"];
    # Me?
    #maintainers = [ maintainers.offline ];
    license = licenses.gpl3;
  };
}
