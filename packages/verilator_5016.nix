{ verilator, fetchFromGitHub, ... }: verilator.overrideAttrs rec {
  pname = "verilator";
  version = "5.016";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MVQbAZXSIdzX7+yKbSrFLLd0j6dfLSXpES3uu6bcPt8=";
  };
}
