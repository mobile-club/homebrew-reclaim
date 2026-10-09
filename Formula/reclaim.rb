# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.7.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.7.0/reclaim-0.7.0-darwin-arm64.tar.gz"
      sha256 "fa875fec2f44aca18909684dc18a52b1058267a118aa793a59fca3ce3773c8c4"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.7.0/reclaim-0.7.0-darwin-x64.tar.gz"
      sha256 "503557417c134993a7cc4ba92f16157ab37ce6451b735816ba168fb2668cfce3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.7.0/reclaim-0.7.0-linux-arm64.tar.gz"
      sha256 "d5195fdf94aa74627144cc12f5ce0d89778f7ecd8d5ce5848f4eb0195740d4c6"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.7.0/reclaim-0.7.0-linux-x64.tar.gz"
      sha256 "35f01e791b638d03eb0d48d965a6a61573d1a6e4d1e03cadcc1953a6a7a82735"
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
