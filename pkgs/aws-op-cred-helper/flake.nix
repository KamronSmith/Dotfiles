{
  description = "AWS credential helper for 1password";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.my-script;

    packages.x86_64-linux.my-script =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
        pkgs.writeShellScriptBin "aws-op-cred-helper" ''
                                 cat <<END | ${pkgs._1password-cli}/bin/op inject
                                {
                                "Version": 1,
                                "AccessKeyId": "{{ op://Personal/AWS Access Key/aws_access_key_id }}",
                                "SecretAccessKey": "{{ op://Personal/AWS Access Key/aws_secret_access_key }}"
                                }
                                END '';
  }
}
