# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.12.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.12.0/reclaim-0.12.0-darwin-arm64.tar.gz"
      sha256 "81af844ec06212103fb01a443840150887f497d773bf4ec04ae6a574722ef5b5"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.12.0/reclaim-0.12.0-darwin-x64.tar.gz"
      sha256 "a0fd5aab4b0c45bc615f819ae579d56e135a086a2f3a2d69e6227c9e6b9fdd7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.12.0/reclaim-0.12.0-linux-arm64.tar.gz"
      sha256 "a0909b75e3617636295378a7fa65e8a38424d7cdcb3fe1a8517ff7424da3f460"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.12.0/reclaim-0.12.0-linux-x64.tar.gz"
      sha256 "debe336c9455f226600a0570aa4894b3f01e78e6b8b15d5005d9f744d2798445"
    end
  end

  # The archive root moves whole into libexec, so the launcher finds its own
  # private Node and manifest beside it. Nothing under the configuration
  # directory is read or written by an install, an upgrade or an uninstall.
  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/reclaim"
    bash_completion.install libexec/"share/completions/reclaim.bash" => "reclaim"
    zsh_completion.install libexec/"share/completions/_reclaim"
  end

  def caveats
    <<~EOS
      This install is owned by Homebrew: update it with `brew upgrade reclaim`.
      `reclaim update` refuses a Homebrew install and moves only an install root
      it created itself.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/reclaim --output human --version").strip
    identity = JSON.parse(shell_output("#{bin}/reclaim version --output json"))
    assert_equal true, identity.dig("data", "installed")
    assert_equal true, identity.dig("data", "archive", "verified")
  end
end
