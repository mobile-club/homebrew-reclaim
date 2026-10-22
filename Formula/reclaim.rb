# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.22.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.22.0/reclaim-0.22.0-darwin-arm64.tar.gz"
      sha256 "63ded0f0f942a2ca3f61a34140c9aa9a828f7b16d4d40dda255a71675f0f4eaa"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.22.0/reclaim-0.22.0-darwin-x64.tar.gz"
      sha256 "6dbcca45cd37e3beca0ce0c89a86ce2c6cc18e898950084048d89e7e84bf9204"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.22.0/reclaim-0.22.0-linux-arm64.tar.gz"
      sha256 "23781066efe8abad9274f1232184dd0ffaac4f69da1212c4defcc9f532105525"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.22.0/reclaim-0.22.0-linux-x64.tar.gz"
      sha256 "84c74737c20bd0a5eb73a6116151612e0c94a0ca012f7814048ce90585972338"
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
