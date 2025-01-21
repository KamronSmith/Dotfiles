{ config, lib, pkgs, ... }:

{
  pkgs.writeShellScriptBin "aws-op-cred-helper" '' 
   cat <<END | ${pkgs._1password}/bin/op inject
     {
       "Version": 1,
       "AccessKeyId": "{{ op://Personal/AWS Access Key/aws_access_key_id }}",
       "SecretAccessKey": "{{ op://Personal/AWS Access Key/aws_secret_access_key }}",
     }
END
'';
