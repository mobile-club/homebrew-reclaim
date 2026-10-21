# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.20.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.20.0/reclaim-0.20.0-darwin-arm64.tar.gz"
      sha256 "316ed9c47f35e88bcf32e4f24186f06c835dfb576305f98916a011a275257b75"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.20.0/reclaim-0.20.0-darwin-x64.tar.gz"
      sha256 "aa608fb2a7d0c32abfca3ad93ebe9d550daeb2876fd3ea20cab5d11895c6ceba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.20.0/reclaim-0.20.0-linux-arm64.tar.gz"
      sha256 "5bff58eebec5d2bb6ec6848b913553e10fd40e2200aa367553c9c53d29c3c3db"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.20.0/reclaim-0.20.0-linux-x64.tar.gz"
      sha256 "22d15452ca5e82f324e7cb237c64c7d0cfa5845e1c62d6ce6dd8bb449f2f585b"
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
