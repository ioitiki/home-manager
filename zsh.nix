{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # system
      lst = "ls -lt --time=ctime";
      # zsh
      rezsh = "source ~/.zshrc";
      zshrc = "cursor ~/.zshrc";
      # cursor
      code = "cursor";
      cod = "cursor";
      s = "cursor";
      scripts = "cursor ~/nft/scripts";
      charts = "cursor ~/nft/charts";
      ".ssh" = "cursor ~/.ssh";
      chainstarters-terraform = "cursor ~/nft/chainstarters-terraform";
      marketplace-graphql = "cursor ~/nft/nft-marketplace-graphql";
      marketplace-contracts = "cursor ~/nft/nft-marketplace-contracts";
      marketplace-react = "cursor ~/nft/nft-marketplace-react";
      marketplace-docs = "cursor ~/nft/nft-marketplace-docs";
      dashboard-graphql = "cursor ~/nft/nft-dashboard-graphql";
      dashboard-react = "cursor ~/nft/nft-dashboard-react";
      monorepo = "cursor ~/nft/monorepo";
      rail = "cursor ~/coding/railbird";
      soad = "cursor ~/system-of-a-dow/soad";
      verified-fans-graphql = "cursor ~/verified-fans/verified-fans-graphql";
      verified-fans-react = "cursor ~/verified-fans/verified-fans-react";
      # k8s
      ke = "kubectl exec -it";
      knreact = "kubens $(kubens -c)-react";
      kngraph = "kubens $(kubens -c | sed 's/-react$//')";
      krd = "kubectl rollout restart deployment";
      kn = "kubens";
      pods = "kubectl get pods";
      pima = "kubectl describe pods | grep 'Image:'";
      # nixos
      clean = "nix-collect-garbage";
      config = "sudo nix-shell -p zed-editor --run 'cursor /etc/nixos'";
      update = "sudo nixos-rebuild switch";
      hms = "home-manager switch --flake .#andy";
      hmsb = "home-manager switch --flake .#andy -b backup";
      nshell = "nix-shell -p";
      # git
      "ga." = "ga .";
      spp = "git stash && git pull && git stash pop";
      icm = "git add -A && git commit -m 'ic' && git push origin main";
      gcm = "git commit -m";
      sgit = "sudo git";
      gs = "git status";
      gck = "git checkout";
      # yarn
      yd = "yarn deploy";
      ydd = "yarn deploy round-five";
      ydp = "yarn deploy release";
      # bun
      b = "bun";
      bi = "bun install";
      br = "bun repl";
      bunx = "bun x";
      buni = "bun run ./index.ts";
      bun-update = "sudo bash ~/.config/bun/update.sh";
      # poetry
      p = "poetry";
      pc = "poetry config";
      pi = "poetry install";
      #

      ".." = "cd ..";
      "myip" = "curl -4 icanhazip.com";

      db_ip_whitelist_bee="doctl db firewalls append bf2de5ef-4084-48d9-a97b-096077dfb482 --rule ip_addr:\$(curl ifconfig.io -4)";
      redis_ip_whitelist_bee="doctl db firewalls append 9559078b-d046-4b3a-b355-bab8d28e77de --rule ip_addr:\$(curl ifconfig.io -4)";
      dbip="db_ip_whitelist_bee && redis_ip_whitelist_bee";

      bd = "base64d";
      be = "base64e";

      nhash = "getHash";

      # cursor = "nohup /run/current-system/sw/bin/cursor > /dev/null 2>&1 &";
    };

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/oh-my-zsh/custom";
      plugins = [
        "git"
        "per-directory-history"
        "kubectl"
        "helm"
        "yarn"
        "bun"
      ];
      theme = "miRobbyRussle";
    };

    envExtra = ''
      export NPM_AUTH_TOKEN=MjA5ODUyZWFlNDI2OTAyNWFjOWVhZjI0NTBjZjk0NTc6Y2JkNzdiMmIwOWIzNmZhMDc2OTgzM2U1MjEwZDAxOWI2OTRmNDk0ZTRlNmU5ZTllNTkzN2ZjMmFjODNjM2IzYmNj
      export KUBE_EDITOR="cursor -w"
    '';

    initContent = ''
      # Base64 helper functions
      base64d() {
        echo "$1" | base64 -d
      }
      
      base64e() {
        printf "$1" | base64 -w 0; echo
      }

      getHash() {
        nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 $1)
      }
    '';
  };
}
