{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, hypothesis, mypy }:

buildPythonPackage rec {
  pname = "algebraic-data-types";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jspahrsummers";
    repo = "adt";
    rev = "v${version}";
    sha256 = "00q76qbyfvg5vgs5sg7qc2y6fl72b16vgbpn0lgc67mwila9h4r6";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [
    hypothesis
    mypy
  ];

  meta = with lib; {
    description = "Algebraic data types for Python";
    homepage = https://github.com/jspahrsummers/adt;
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.unix;
  };
}
