{ stdenv
, lib
, fetchFromGitHub
, python3
, pcre2
, cmake
, swig }:

stdenv.mkDerivation rec {
  pname = "libyang";
  version = "2.0.97";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v$(version)";
    sha256 = "bfNN0pfZmKqdQlVvYiz6LgpvTJ6Q/UoVjOrNZOixg2g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pcre2 ];

  cmakeFlags = [
    "-DENABLE_LYD_PRIV=ON"
    #"-DENABLE_BUILD_TESTS=ON"
    #"-DGEN_LANGUAGE_BINDINGS=ON"
    #"-DGEN_PYTHON_BINDINGS=OFF" # This gives permission error
    #"-DGEN_CPP_BINDINGS=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/CESNET/libyang/";
    description = "YANG data modelling language parser and toolkit";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
