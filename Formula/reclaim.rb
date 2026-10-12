# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.8.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.8.0/reclaim-0.8.0-darwin-arm64.tar.gz"
      sha256 "346a486f330aedf2a8bc4aef47740bf9bedb82fe456b44c7b8fe9094ec06b4a8"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.8.0/reclaim-0.8.0-darwin-x64.tar.gz"
      sha256 "bf833820f76a04d482348b143436abead5b5fee8efa0e87987029515f3b8a110"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.8.0/reclaim-0.8.0-linux-arm64.tar.gz"
      sha256 "a8945ecacbf6c4122368dc8fe3770cf6aacee4039405917b8fbd1d0522a7bc1f"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.8.0/reclaim-0.8.0-linux-x64.tar.gz"
      sha256 "4004bee4bd437d3224ea234c330a544d384d616b4ab4fa5593f0b41217e30a35"
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
