{
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ibm-plex-mono";
  version = "2.5.0";

  src = fetchzip {
    url = "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%40${finalAttrs.version}/ibm-plex-mono.zip";
    hash = "sha256-mb48lQSF8qy1yjz3J9UigfXkbv7Jhpp0SoF6iT4DwO0=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/woff2 ibm-plex-mono/fonts/complete/woff2/*.woff2

    runHook postInstall
  '';
})
