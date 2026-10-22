# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.21.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.21.0/reclaim-0.21.0-darwin-arm64.tar.gz"
      sha256 "5a1553b5d1f00978246799c0c250385142b335d499da3548bb54695ba8876a07"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.21.0/reclaim-0.21.0-darwin-x64.tar.gz"
      sha256 "f6e428617f1563d9c47ab51c8d7bee0354d0fcec2cb88303bd3b49dd1338d3e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.21.0/reclaim-0.21.0-linux-arm64.tar.gz"
      sha256 "5a9055207968266d039001c8039aa7a39eb3d3500f48e8d59f72f520025ffeb2"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.21.0/reclaim-0.21.0-linux-x64.tar.gz"
      sha256 "a5750adc43c974bae355417be69146d016c1655a50d6ddf735d2aee4bf9f77f7"
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
