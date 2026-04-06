{ ... }:
let
  secrets = import ../secrets.nix;
  inherit (secrets) email1 email2 email3;
in
{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
    };
  };

  accounts.email.accounts = {
    ${email1} = {
      primary = true;
      address = email1;
      realName = "Jeppe Allerslev";
      userName = email1;

      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };

    ${email2} = {
      address = email2;
      realName = "Jeppe Allerslev";
      userName = email2;

      imap = {
        host = "imap-mail.outlook.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp-mail.outlook.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };

    ${email3} = {
      address = email3;
      realName = "Jeppe Allerslev";
      userName = email3;

      imap = {
        host = "imap-mail.outlook.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp-mail.outlook.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };
  };
}
