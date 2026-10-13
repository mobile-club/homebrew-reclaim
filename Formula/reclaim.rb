# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.13.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.13.0/reclaim-0.13.0-darwin-arm64.tar.gz"
      sha256 "870c9e23a664281503996dbea7ec33a4e95eea3272e61bdcc4868daab5951868"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.13.0/reclaim-0.13.0-darwin-x64.tar.gz"
      sha256 "130b43b966159649885d91e061c5a6ac0853994570e6e4a2b7f01749d511ea5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.13.0/reclaim-0.13.0-linux-arm64.tar.gz"
      sha256 "a6bed2b0ff489d84e0982daaa07c52a6b4a2987a9143e1f36a6387a4fa561696"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.13.0/reclaim-0.13.0-linux-x64.tar.gz"
      sha256 "6028599d65b90ee68424f05110c3dbf8caf66ec19698f5cac50a329ec91deb34"
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
