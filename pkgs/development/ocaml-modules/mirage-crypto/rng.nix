{ buildDunePackage, mirage-crypto, ounit2, randomconv, dune-configurator
, cstruct, duration, logs, mtime, ocaml_lwt }:

buildDunePackage rec {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src;

  doCheck = true;
  nativeCheckInputs = [ ounit2 randomconv ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ cstruct mirage-crypto duration logs mtime ocaml_lwt ];

  strictDeps = !doCheck;

  meta = mirage-crypto.meta // {
    description = "A cryptographically secure PRNG";
  };
}
