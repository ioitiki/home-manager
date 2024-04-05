{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # zsh
      rezsh = "source ~/.zshrc";
      zshrc = "sublime ~/.zshrc";
      # sublime
      code = "sublime";
      s = "sublime";
      scripts = "sublime ~/nft/scripts";
      charts = "sublime ~/nft/charts";
      ".ssh" = "sublime ~/.ssh";
      chainstarters-terraform = "sublime ~/nft/chainstarters-terraform";
      marketplace-graphql = "sublime ~/nft/nft-marketplace-graphql";
      marketplace-contracts = "sublime ~/nft/nft-marketplace-contracts";
      marketplace-react = "sublime ~/nft/nft-marketplace-react";
      marketplace-docs = "sublime ~/nft/nft-marketplace-docs";
      dashboard-graphql = "sublime ~/nft/nft-dashboard-graphql";
      dashboard-react = "sublime ~/nft/nft-dashboard-react";
      monorepo = "sublime ~/nft/monorepo";
      rail = "sublime ~/coding/railbird";
      verified-fans-graphql = "sublime ~/verified-fans/verified-fans-graphql";
      verified-fans-react = "sublime ~/verified-fans/verified-fans-react";
      # k8s
      ke = "kubectl exec -it";
      knreact = "kubens $(kubens -c)-react";
      kngraph="kubens $(kubens -c | sed 's/-react$//')";
      krd = "kubectl rollout restart deployment";
      kn = "kubens";
      pods = "kubectl get pods";
      pima = "kubectl describe pods | grep 'Image:'";
      # nixos
      clean = "nix-collect-garbage";
      config = "sudo sublime /etc/nixos";
      update = "sudo nixos-rebuild switch";
      # git
      icm = "git add -A && git commit -m 'ic' && git push origin main";
      gcm = "git commit -m";
      sgit = "sudo git";
      # yarn
      yd = "yarn deploy";
      ydd = "yarn deploy round-five";
      ydp = "yarn deploy release";
      # bun
      b = "bun";
      bi = "bun install";
      bd = "bun run deploy";
      bunx = "bun x";
      buni = "bun run ./index.ts";
      bun-update = "sudo bash ~/.config/bun/update.sh";
      # poetry
      p = "poetry";
      pc = "poetry config";
      pi = "poetry install";

      ".." = "cd ..";
      "myip" = "curl -4 icanhazip.com";
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
      ];
      theme = "miRobbyRussle";
    };
  };
}