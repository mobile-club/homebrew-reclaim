# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.26.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.26.0/reclaim-0.26.0-darwin-arm64.tar.gz"
      sha256 "2c5c73ab816ef57868b765f3f44eba6811a6d3d516fba093a320e42a991751d9"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.26.0/reclaim-0.26.0-darwin-x64.tar.gz"
      sha256 "e4e3f62033ed03758a2b68ef85f0f1dfa33e11749c2e4f5cf543892507b871e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.26.0/reclaim-0.26.0-linux-arm64.tar.gz"
      sha256 "79d523aadd7549d42c27b62bb3aa8a2638d7da77a120ba9b7b11f1ac2b63141e"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.26.0/reclaim-0.26.0-linux-x64.tar.gz"
      sha256 "caa41358d7156aff6f1da5100b699abae06a1c42ada12f74b025f476eefeee08"
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
