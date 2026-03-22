# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
	# include the minecraft flakes
	inputs.nix-minecraft.nixosModules.minecraft-servers
    ];
 
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos-minecraft"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

	# Configure networking
	networking = {
	  interfaces.ens18 = {
	   ipv4.addresses = [{
	      address = "192.168.1.90";
	      prefixLength = 24;
	    }];
	  };
	  defaultGateway = {
	    address = "192.168.1.1";
	    interface = "ens18";
	  };
	  nameservers = [ "1.1.1.1" "8.8.8.8" ];
	};

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jex = {
    isNormalUser = true;
    description = "jex";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
	vim
	openssh
	git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  # program settings
	users.users."jex".openssh.authorizedKeys.keyFiles = [
	    /home/jex/.ssh/authorized_keys
	  ];
    # git
    programs.git = {
	enable = true;
    config = {
      init = {
	defaultBranch = "main";
      };
	user.name = "Magnus Rotvit Perlt Hansen";
	user.email = "magnuha@gmail.com";
	url = {
	    "https://github.com/" = {
	      insteadOf = [
		"gh:"
		"github:"
	      ];
	    };
	  };
    };
    };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    
    package = pkgs.minecraft-server-1-12;
    dataDir = “/var/lib/minecraft-servers”;
 
    servers = {
      cool-server1 = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_18_2;
 
        serverProperties = {/* */};
        whitelist = {/* */};
 
        symlinks = 
        let
          modpack = (pkgs.fetchPackwizModpack {
            url = “https://github.com/Misterio77/Modpack/raw/0.2.9/pack.toml”;
            packHash = “sha256-L5RiSktqtSQBDecVfGj1iDaXV+E90zrNEcf4jtsg+wk=”;
          })
        in
          # Modpack example
          # “mods” = ”${modpack}/mods”;
 
          # Directories
          # “mods” = ./mods;
 
          # Fetching from the internet
          # “mods” = pkgs.linkFarmFromDrvs “mods” (builtins.attrValues {
          #   Starlight = fetchurl { url = “https://cdn.modrinth.com/data/H8CaAYZC/versions/XGIsoVGT/starlight-1.1.2%2Bfabric.dbc156f.jar”; sha512 = “6b0e363fc2d6cd2f73b466ab9ba4f16582bb079b8449b7f3ed6e11aa365734af66a9735a7203cf90f8bc9b24e7ce6409eb04d20f84e04c7c6b8e34f4cc8578bb”; };
          #   Lithium = fetchurl { url = “https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar”; sha512 = “d1b5c90ba8b4879814df7fbf6e67412febbb2870e8131858c211130e9b5546e86b213b768b912fc7a2efa37831ad91caf28d6d71ba972274618ffd59937e5d0d”; };
          #   FerriteCore = fetchurl { url = “https://cdn.modrinth.com/data/uXXizFIs/versions/ULSumfl4/ferritecore-6.0.0-forge.jar”; sha512 = “e78ddd02cca0a4553eb135dbb3ec6cbc59200dd23febf3491d112c47a0b7e9fe2b97f97a3d43bb44d69f1a10aad01143dcd84dc575dfa5a9eaa315a3ec182b37”; };
          #   Krypton = fetchurl { url = “https://cdn.modrinth.com/data/fQEb0iXm/versions/jiDwS0W1/krypton-0.2.3.jar”; sha512 = “92b73a70737cfc1daebca211bd1525de7684b554be392714ee29cbd558f2a27a8bdda22accbe9176d6e531d74f9bf77798c28c3e8559c970f607422b6038bc9e”; };
          #   LazyDFU = fetchurl { url = “https://cdn.modrinth.com/data/hvFnDODi/versions/0.1.3/lazydfu-0.1.3.jar”; sha512 = “dc3766352c645f6da92b13000dffa80584ee58093c925c2154eb3c125a2b2f9a3af298202e2658b039c6ee41e81ca9a2e9d4b942561f7085239dd4421e0cce0a”; };
          #   C2ME = fetchurl { url = “https://cdn.modrinth.com/data/VSNURh3q/versions/t4juSkze/c2me-fabric-mc1.20.1-0.2.0%2Balpha.10.91.jar”; sha512 = “562c87a50f380c6cd7312f90b957f369625b3cf5f948e7bee286cd8075694a7206af4d0c8447879daa7a3bfe217c5092a7847247f0098cb1f5417e41c678f0c1”; };
          # });
        };
      };
      cool-server2 = {
        enable = true;
        package = pkgs.vanillaServers.vanilla-1_21
      };
    };
  };
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
