{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # rust
      cg = "cargo";
      cgr = "cargo run";
      c = "claude";
      claudeupdate = "~/.config/home-manager/claude-code/update.sh";
      # system
      lst = "ls -lt --time=ctime";
      # zsh
      rezsh = "source ~/.zshrc";
      zshrc = "zeditor ~/.zshrc";
      # zeditor
      code = "zeditor";
      cod = "zeditor";
      s = "zeditor";
      scripts = "zeditor ~/nft/scripts";
      charts = "zeditor ~/nft/charts";
      ".ssh" = "zeditor ~/.ssh";
      mfa-trading = "zeditor ~/trading/mfa-trading";
      beelines = "zeditor ~/bee/backend-monorepo";
      chainstarters-terraform = "zeditor ~/nft/chainstarters-terraform";
      marketplace-graphql = "zeditor ~/nft/nft-marketplace-graphql";
      marketplace-contracts = "zeditor ~/nft/nft-marketplace-contracts";
      marketplace-react = "zeditor ~/nft/nft-marketplace-react";
      marketplace-docs = "zeditor ~/nft/nft-marketplace-docs";
      dashboard-graphql = "zeditor ~/nft/nft-dashboard-graphql";
      dashboard-react = "zeditor ~/nft/nft-dashboard-react";
      monorepo = "zeditor ~/nft/monorepo";
      rail = "zeditor ~/coding/railbird";
      soad = "zeditor ~/system-of-a-dow/soad";
      verified-fans-graphql = "zeditor ~/verified-fans/verified-fans-graphql";
      verified-fans-react = "zeditor ~/verified-fans/verified-fans-react";
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
      gcwip = "git add -A && gcm 'wip'";
      gunc = "git reset HEAD^";
      "gs." = "gs .";
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

      db_ip_whitelist_bee = "doctl db firewalls append bf2de5ef-4084-48d9-a97b-096077dfb482 --rule ip_addr:\$(curl ifconfig.io -4)";
      redis_ip_whitelist_bee = "doctl db firewalls append 9559078b-d046-4b3a-b355-bab8d28e77de --rule ip_addr:\$(curl ifconfig.io -4)";
      dbip = "db_ip_whitelist_bee && redis_ip_whitelist_bee";

      bd = "base64d";
      be = "base64e";

      nhash = "getHash";

      cadd = "clipadd";

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
      export KUBE_EDITOR="zeditor --wait"
      export EDITOR="zeditor --wait"
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

      clipadd() {
        echo -n "$1" | wl-copy && echo -n "$1" | cliphist store
      }
    '';
  };
}
