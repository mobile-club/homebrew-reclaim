# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.18.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.18.0/reclaim-0.18.0-darwin-arm64.tar.gz"
      sha256 "ebc231e60dd8e11df6c1e0894d6608f59cfa08ffad83eecade8cfe31ea513a95"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.18.0/reclaim-0.18.0-darwin-x64.tar.gz"
      sha256 "0f37379d052dacb4b1cc54fd927c2e681546fde3cff0bd4bfdf558ee60b902d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.18.0/reclaim-0.18.0-linux-arm64.tar.gz"
      sha256 "d82e85fd90e1c3307be2ec927bce62b8c1c7042a084279d6b206ac68fedb60b7"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.18.0/reclaim-0.18.0-linux-x64.tar.gz"
      sha256 "58bc17ca07001532950b6d90e9559d4ae0decfa9a73d3daa986d0b7429e832b7"
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
