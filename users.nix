let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  users = {
    # 1. Generate an SSH key for your root account and add the public
    #    key to a file matching your name in ./keys/
    #
    # 2. Copy / paste this in order, alphabetically:
    #
    #    youruser = {
    #      trusted = true;
    #      keys = ./keys/youruser;
    #    };

    andir = {
      trusted = true;
      keys = ./keys/andir;
    };

    dezgeg = {
      trusted = true;
      keys = ./keys/dezgeg;
    };

    dhess = {
      trusted = true;
      keys = ./keys/dhess;
    };

    flokli = {
      trusted = true;
      keys = ./keys/flokli;
    };

    grahamc = {
      sudo = true;
      trusted = true;
      password = "$6$lAjIm6PyElKewH$WfO/3pGei09YstCXghkCx5bDUvxsou2h63HMMTHgA/5tF8AsU6iw36PZm66z34n4oxW13yTUXaUAuKP/aHepg.";
      keys = ./keys/grahamc;
    };

    globin = {
      trusted = true;
      keys = ./keys/globin;
    };

    jtojnar = {
      trusted = true;
      keys = ./keys/jtojnar;
    };

    kamilchm = {
      trusted = true;
      keys = ./keys/kamilchm;
    };

    lheckemann = {
      trusted = true;
      keys = ./keys/lheckemann;
    };

    moretea = {
      trusted = true;
      keys = ./keys/moretea;
    };

    vcunat = {
      trusted = true;
      keys = ./keys/vcunat;
    };

    yegortimoshenko = {
      trusted = true;
      keys = ./keys/yegortimoshenko;
    };
  };

  ifAttr = key: default: result: opts:
    if (opts ? "${key}") && opts."${key}"
      then result
      else default;

  maybeTrusted = ifAttr "trusted" [] [ "trusted" ];
  maybeWheel = ifAttr "sudo" [] [ "wheel" ];

  userGroups = opts:
    (maybeTrusted opts) ++
    (maybeWheel opts);

  descToUser = name: opts:
    {
      isNormalUser = true;
      extraGroups = userGroups opts;
      createHome = true;
      home = "/home/${name}";
      hashedPassword = opts.password or null;
      openssh.authorizedKeys.keyFiles = [
        opts.keys
      ];
    };
in {
  users = {
    groups.trusted = {};

    mutableUsers = false;
    users = lib.mapAttrs descToUser users;
  };
}
