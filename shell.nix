{
  pkgs ? import <nixpkgs> {config = {allowUnfree = true;};},
  system,
  ...
}:
with pkgs; let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
  darwin_packages = [CoreServices ApplicationServices Security];

  ruby = ruby_3_1;

  rakeVersion = {
    version = "13.0.6";
    pname = "rake";
    source.sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
  };
  rubyPackages = ruby.withPackages (ps: with ps; [(rake.override rakeVersion) pry solargraph brakeman rubocop concurrent-ruby]);
in
  mkShell rec {
    name = "raunco.nixpkgs";

    buildInputs =
      [
        bash-completion
        rubyPackages
      ]
      ++ lib.optional stdenv.isDarwin darwin_packages;

    shellHook = ''
      # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
      for p in ''${buildInputs}; do
        if [ -d "$p/share/bash-completion" ]; then
          XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
        fi
      done

      source ${bash-completion}/etc/profile.d/bash_completion.sh
    '';
  }
