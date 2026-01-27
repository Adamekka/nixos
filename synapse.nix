{ config, pkgs, ... }:

let
  email = "adam.wasd4@gmail.com";
  home = "/home/adamekka";
  secretsPath = "${home}/secrets";
  tunnelId = "f879390b-0647-4df7-b9ff-1a6acff23d64";
  url = "matrix.adamekka.com";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "${email}";
  };

  services = {
    cloudflared = {
      enable = true;
      tunnels."matrix-synapse" = {
        certificateFile = "${home}/.cloudflared/cert.pem";
        credentialsFile = "${home}/.cloudflared/${tunnelId}.json";
        default = "http_status:404";
        ingress."${url}".service = "http://127.0.0.1:8008";
      };
    };
    matrix-synapse = {
      enable = true;
      settings = {
        database = {
          args.database = "matrix-synapse";
          type = "psycopg2";
        };
        enable_registration = true;
        enable_registration_captcha = true;
        listeners = [
          {
            # Federation
            bind_addresses = [ ];
            port = 8448;
            resources = [
              { compress = true; names = [ "client" ]; }
              { compress = false; names = [ "federation" ]; }
            ];
            tls = true;
            type = "http";
            x_forwarded = false;
          }
          {
            # Client
            bind_addresses = [
              "127.0.0.1"
            ];
            port = 8008;
            resources = [
              { compress = true; names = [ "client" ]; }
            ];
            tls = false;
            type = "http";
            x_forwarded = true;
          }
        ];
        recaptcha_private_key = (builtins.readFile "${secretsPath}/recaptcha-private-key");
        recaptcha_public_key = (builtins.readFile "${secretsPath}/recaptcha-public-key");
        registration_shared_secret = "password";
        server_name = "${url}";
        tls_certificate_path = "/var/lib/acme/${url}/fullchain.pem";
        tls_private_key_path = "/var/lib/acme/${url}/key.pem";
      };
    };
    nginx = {
      enable = true;
      virtualHosts = {
        "matrix.adamekka.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:8008";
        };
      };
    };
    postgresql = {
      enable = true;
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE USER "matrix-synapse" WITH LOGIN PASSWORD 'password';

        CREATE DATABASE "matrix-synapse"
          ENCODING 'UTF8'
          LC_COLLATE='C'
          LC_CTYPE='C'
          template=template0
          OWNER "matrix-synapse";
      '';
    };
  };

  users.users."matrix-synapse".extraGroups = [ "nginx" ];
}
