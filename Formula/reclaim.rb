# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.10.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.10.0/reclaim-0.10.0-darwin-arm64.tar.gz"
      sha256 "1b85186d94326f4c0b520db3b54828e0bef416ce6053cf5de3b612e24816b5f9"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.10.0/reclaim-0.10.0-darwin-x64.tar.gz"
      sha256 "513f17c1f0351c43f3146ea3f9ba923055556a4b62fcd1f9c58de8d9ed7688a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.10.0/reclaim-0.10.0-linux-arm64.tar.gz"
      sha256 "06dfe580a65019b29b4e41ae7e31e748495b5375698aa253f9253277251aa5e8"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.10.0/reclaim-0.10.0-linux-x64.tar.gz"
      sha256 "fb818c2a8528552259d7f699e454fed200201407d513f3b5507f9951a9fe8b5a"
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
