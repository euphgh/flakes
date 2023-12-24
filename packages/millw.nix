{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "millw";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "lefou";
    repo = pname;
    rev = "${version}";
    hash = "sha256-QZQ46wk343aaKzo5adHdSW6PX2dLaZSHaPKyrJRpIjk=";
  };
  buildPhase = '''';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install $src/millw $out/bin/$pname
    runHook postInstall
  '';
  meta = with lib; {
    description = "Mill Wrapper Script";
    homepage = "https://github.com/lefou/millw";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "millw";
  };
}
