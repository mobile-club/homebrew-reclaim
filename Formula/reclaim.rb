# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.17.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.17.0/reclaim-0.17.0-darwin-arm64.tar.gz"
      sha256 "c6cb9326d621dde9a051cf24507cea9aed29de0afa6e6db53cd4eae06de4aab5"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.17.0/reclaim-0.17.0-darwin-x64.tar.gz"
      sha256 "1b5743ec47b905e3e44583ef24f5ca7f321c2457897a4dc4c1bffd5c1fa22bfb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.17.0/reclaim-0.17.0-linux-arm64.tar.gz"
      sha256 "9a1bc5bf63392ca92ef6fe1e4cd4ee6703efd601bf2f260a1c753971be95bb98"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.17.0/reclaim-0.17.0-linux-x64.tar.gz"
      sha256 "2fddb0de293419a69994566967912454710f45201f7d5f3118f13ae25daa490b"
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
