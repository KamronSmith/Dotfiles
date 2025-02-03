{ pkgs }:

{
  pkgs.writeShellScriptBin "aws-op-cred-helper" ''
  cat <<END | op inject
  {
    "Version": 1,
    "AccessKeyID": "{{ op://Personal/AWS Access Key/access_key_id }}",
    "SecretAccessKey": "{{ op://Personal/AWS Access Key/secret_access_key}}",
  }
  END
'';
}
