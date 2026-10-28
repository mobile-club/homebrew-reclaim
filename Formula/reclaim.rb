# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.30.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.30.0/reclaim-0.30.0-darwin-arm64.tar.gz"
      sha256 "9f17e15003545c33cd0c09c45b7225e974dfc61ce84cf77c4cad2ea7a203ec39"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.30.0/reclaim-0.30.0-darwin-x64.tar.gz"
      sha256 "f161686b763a31fc4bb0a357e2746bfd809e066153b79379ffed56c9d4caa73e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.30.0/reclaim-0.30.0-linux-arm64.tar.gz"
      sha256 "5b9bcf7f460151de6925670e096cc94ecd2eb2871aff81f67cbfeffeac5b3236"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.30.0/reclaim-0.30.0-linux-x64.tar.gz"
      sha256 "d0d0022f5c71c6cf850e0f2f60df36dfb797895eed6751af2c8830adb46592db"
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
