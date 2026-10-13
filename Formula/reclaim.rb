# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.11.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.11.0/reclaim-0.11.0-darwin-arm64.tar.gz"
      sha256 "935fc0d1b403360ba3ccd169f877194ac008e9e8f0159aa8e9d85e3521974e44"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.11.0/reclaim-0.11.0-darwin-x64.tar.gz"
      sha256 "8f2855a913e2accb538b38fbc2fa5594689e76eb257ea3dfe4c2d8ddea58e302"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.11.0/reclaim-0.11.0-linux-arm64.tar.gz"
      sha256 "bc82b3fbe237fa4d7ec367a0566b3e22897bc32b243ea024927d539d545fa216"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.11.0/reclaim-0.11.0-linux-x64.tar.gz"
      sha256 "08685b7afbae9e951ec8a1384aa8644ce73a5737f7120ad67704a61cec907e1a"
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
