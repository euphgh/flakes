{ verilator
, fetchFromGitHub
, version ? "5.018"
}:
let
  hashMap = {
    "5.016" = "sha256-MVQbAZXSIdzX7+yKbSrFLLd0j6dfLSXpES3uu6bcPt8=";
    "5.018" = "sha256-f06UzNw2MQ5me03EPrVFhkwxKum/GLDzQbDNTBsJMJs=";
    "5.020" = "sha256-7kxH/RPM+fjDuybwJgTYm0X6wpaqesGfu57plrExd8c=";
  };
in
verilator.overrideAttrs {
  version = version;

  src = fetchFromGitHub {
    owner = "verilator";
    repo = "verilator";
    rev = "v${version}";
    hash = hashMap.${version};
  };
  patches = [ ];
}

