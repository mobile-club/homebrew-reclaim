# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.9.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.9.0/reclaim-0.9.0-darwin-arm64.tar.gz"
      sha256 "bac71fcba5936e5780a1775a116a66861420874daa54097a0c867fde22f4aed5"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.9.0/reclaim-0.9.0-darwin-x64.tar.gz"
      sha256 "acbf43d219bc60b8868d0d3da500583dc51acdb3d6237b15379bbf09a2c74976"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.9.0/reclaim-0.9.0-linux-arm64.tar.gz"
      sha256 "57c3f386e6ed78822a59f208b79734b3881a04b2592db7f5ccb4953975138c2a"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.9.0/reclaim-0.9.0-linux-x64.tar.gz"
      sha256 "170f45409de4397141681d0f2aa337010c68a9e18e86d9dfbba28a04fdeb0bc7"
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
