{ stdenv
, bison
, cmake
, fetchFromGitHub
, flex
, forR2Cutter
, pkgconfig

, qmake ? null
, qtbase ? null
, qtsvg ? null
, qtwebengine ? null
, wrapQtAppsHook ? null

, radare2
}:

# TODO:
# assert forR2Cutter -> qmake != null;

stdenv.mkDerivation rec {
  pname = "r2ghidra-dec";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "r2ghidra-dec";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1r8613nm4gpvp8chcrvgh5yn5n44bxyzj2idaz409kkmsw8893d3";
  };

  cutter-h = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v1.11.0";
    sha256 = "1xvdap7hpkjz6rg0ngnql1p18p93b8w9gv130g818nwcjsh9i2y5";
  } + "/src/core/Cutter.h";

  nativeBuildInputs = with stdenv.lib; [ pkgconfig ]
    ++ optional (forR2Cutter) [ ];
    # ++ optional (forR2Cutter != null) [ qmake ];

  buildInputs = with stdenv.lib; [ bison flex radare2 ]
    # ++ optional (forR2Cutter != null) [];
    ++ optional (forR2Cutter) [ qtbase qtsvg qtwebengine wrapQtAppsHook ];

  propagatedBuildInputs = with stdenv.lib; []
    ++ optional (forR2Cutter) [ ];

  # qmakeFlags = [
  #   "CONFIG+=link_pkgconfig"
  #   "PKGCONFIG+=r_core"
  # ];

  # TODO:
  # hook manually (`ln -s` to a dir in hom that r2 expects) after building...
  buildFlags = "-DCMAKE_INSTALL_PREFIX=$out";
  cutterFlags =
    stdenv.lib.optionalString (forR2Cutter) "-DBUILD_CUTTER_PLUGIN=ON -DCUTTER_SOURCE_DIR=${cutter-h}/../../";

  installPhase = ''
    # echo '-------'
    # cat cutter-plugin/CMakeLists.txt
    # exit

    ${cmake}/bin/cmake ${cutterFlags} ${buildFlags}
    make
    make install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/radareorg/r2ghidra-dec";
    description = "An integration of the Ghidra decompiler for radare2";
    maintainers = [ maintainers.pamplemousse ];
  };
}
