{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, postgresql
, lua5_4
}:
let
  lua = lua5_4;
in
stdenv.mkDerivation {
  name = "pllua";
  src = fetchFromGitHub {
    owner = "pllua";
    repo = "pllua";
    rev = "f1d32581014a6e4e532a63d1c1ca79dddfa25336";
    hash = "sha256-xzfuSTzobNT3q4HlJXov1v9OgF8uzaxVFsvl5xBxoEI=";
  };
  dontDisableStatic = true;
  nativeBuildInputs = [
    pkg-config
    lua
  ];
  buildInputs = [
    postgresql
    #lua
  ];
  makeFlags = [
    " PG_CONFIG=${postgresql}/bin/pg_config"
    "LUA_INCDIR=${lua}/include"
    "LUALIB=-L${lua}/lib"
    "LUAC=${lua}/bin/luac"
    "LUA=${lua}/bin/lua"
  ];
  installFlags = [
    # PGXS only supports installing to postgresql prefix so we need to redirect this
    "DESTDIR=${placeholder "out"}"
  ];
  NIX_LDFLAGS = "--export-dynamic";
  postInstall = ''
    # Move the redirected to proper directory.
    # There appear to be no references to the install directories
    # so changing them does not cause issues.
    mv "$out/nix/store"/*/* "$out"
    rmdir "$out/nix/store"/* "$out/nix/store" "$out/nix"
  '';
}

