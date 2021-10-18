{ stdenv
, lib
, fetchFromGitHub
, pkgconfig
, autoreconfHook
, c-ares
, libcap
, libnl
, libunwind
, libyang
, libjson
, json_c
, ncurses
, linux-pam
, perl
, readline
, rtrlib
#, python38Packages.pytest_6
, bison
, gcc
, net-snmp
, patch
, python3
#, perlPackages.XMLLibXML
#, python38Packages.sphinx
, libelf
, rsyslog }:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = "frr";
    rev = "frr-$(version)";
    sha256 = "GTSDquc/TZgy6CFvEpRMT2AJZO6o0ILEambaFWyJ1Q0=";
  };

  buildInputs = [
    libyang
    readline
    net-snmp
    c-ares
    autoreconfHook
    libjson 
    libelf ]
    ++ lib.optionals stdenv.isLinux [ libcap libnl ];

  nativeBuildInputs = [ pkgconfig perl libjson libyang json_c python3 ];

  configureFlags = [
    "--sysconfdir=/etc/frr"
    "--localstatedir=/run/frr"
    "--sbindir=$(out)/libexec/frr"
    "--disable-exampledir"
    "--enable-user=frr"
    "--enable-group=frr"
    "--enable-configfile-mask=0640"
    "--enable-logfile-mask=0640"
    "--enable-vtysh"
    "--enable-vty-group=frrvty"
    "--enable-snmp"
    "--enable-multipath=64"
    "--enable-rtadv"
    "--enable-irdp"
    "--enable-opaque-lsa"
    "--enable-ospf-te"
    "--enable-pimd"
    "--enable-isis-topology"
  ];

#  preConfigure = ''
#    substituteInPlace vtysh/vtysh.c --replace \"more\" \"${less}/bin/less\"
#  '';

#  postInstall = ''
#    rm -f $out/bin/test_igmpv3_join
#    mv -f $out/libexec/quagga/ospfclient $out/bin/
#  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Free Range Routing (FRR) BGP/OSPF/ISIS/RIP/RIPNG routing daemon suite";
    longDescription = ''
      FRR is a fully featured, high performance, free software IP routing suite.
      
      FRR implements all standard routing protocols such as BGP, RIP, OSPF, IS-IS and more (see Feature Matrix), as well as many of their extensions.
      
      FRR is a high performance suite written primarily in C. It can easily handle full Internet routing tables and is suitable for use on hardware ranging from cheap SBCs to commercial grade routers. It is actively used in production by hundreds of companies, universities, research labs and governments.
      
      FRR is distributed under GPLv2, with development modeled after the Linux kernel. Anyone may contribute features, bug fixes, tools, documentation updates, or anything else.
      
      FRR is a fork of Quagga.
    '';
    homepage = "https://frrouting.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tavyc ];
  };
}
