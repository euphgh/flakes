{ stdenv, lib, fetchurl }:
stdenv.mkDerivation rec {
  pname = "fcitx5-pinyin-zhwiki";
  version = "0.2.4";
  date = "20231205";

  src = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${version}/zhwiki-${date}.dict";
    sha256 = "sha256-crMmSqQ7QgmjgEG8QpvBgQYfvttCUsKYo8gHZGXIZmc=";
  };

  dontUnpack = true;
  installPhase = ''
    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/zhwiki.dict
  '';
  meta = with lib; {
    description = "Fcitx 5 Pinyin Dictionary from zh.wikipedia.org";
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    license = licenses.unlicense;
  };
}
