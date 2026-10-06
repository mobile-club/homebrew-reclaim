# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.3.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.3.0/reclaim-0.3.0-darwin-arm64.tar.gz"
      sha256 "db84494e5615cfae3a7b5a33c214dcf1dd5abf41a093dcb3bd72e2929dee4fca"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.3.0/reclaim-0.3.0-darwin-x64.tar.gz"
      sha256 "1e35d485933946ea9fcc1538133a63e7a65a24f3b6daf9716a96f03e406a3222"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.3.0/reclaim-0.3.0-linux-arm64.tar.gz"
      sha256 "4417c0a0c193782706972edd7139e4bdf3e89b704ed25bbcc1973099af4b074b"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.3.0/reclaim-0.3.0-linux-x64.tar.gz"
      sha256 "1ee6ee10862d8eb97155a8e1bf520a4c86e2288036daff9a56f643d5c3fc4fc0"
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
