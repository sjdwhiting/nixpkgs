{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, stdenv
, openssl
, libiconv
, sqlite
, Security
, SystemConfiguration
, CoreFoundation
, installShellFiles
, asciidoctor }:

rustPlatform.buildRustPackage rec {
  pname = "listenbrainz-mpd";
  version = "2.3.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-QHhSrmBNvUTffPzjns670Tn3Z3UDcDvarq605Qx9k4w=";
  };

  cargoHash = "sha256-vtU439Pd3zWx+qakh1xTENQhun7S+WsJMndXqPWrPWU=";

  nativeBuildInputs = [ pkg-config installShellFiles asciidoctor ];

  buildInputs = [ sqlite ] ++ (if stdenv.isDarwin then [
    libiconv
    Security
    SystemConfiguration
    CoreFoundation
  ] else [
    openssl
  ]);

  buildFeatures = [
    "shell_completion"
  ] ++ lib.optionals stdenv.isLinux [
    "systemd"
  ];

  postInstall = ''
    installShellCompletion \
      --bash generated_completions/listenbrainz-mpd.bash \
      --fish generated_completions/listenbrainz-mpd.fish \
      --zsh generated_completions/_listenbrainz-mpd

    asciidoctor --backend=manpage listenbrainz-mpd.adoc -o listenbrainz-mpd.1
    installManPage listenbrainz-mpd.1
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ DeeUnderscore ];
    mainProgram = "listenbrainz-mpd";
  };
}
