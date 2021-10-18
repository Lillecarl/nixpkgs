{ stdenv
, lib
, fetchFromGitHub
, libssh
, cmake }:

stdenv.mkDerivation rec {
  pname = "rtrlib";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rtrlib";
    repo = "rtrlib";
    rev = "v$(version)";
    sha256 = "ISb4ojcDvXY/88GbFMrA5V5+SGE6CmE5D+pokDTwotQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libssh ];

  meta = with lib; {
    homepage = "http://rtrlib.realmv6.org/";
    description = "An open-source C implementation of the RPKI/Router Protocol client";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
