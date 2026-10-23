# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.25.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.25.0/reclaim-0.25.0-darwin-arm64.tar.gz"
      sha256 "8dd7873e6b163af0d155a3f3c9fe3d2b8ddc9c65e8ce2547349df1df3fead05f"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.25.0/reclaim-0.25.0-darwin-x64.tar.gz"
      sha256 "9ad8c9e749de231bfc5b98d1b5f75b5f1a878ae91a1589fb62f453e7f03e01c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.25.0/reclaim-0.25.0-linux-arm64.tar.gz"
      sha256 "6d01c40ff60f383681ae3a2821fe519dad5c052975a656b38757a940367415d1"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.25.0/reclaim-0.25.0-linux-x64.tar.gz"
      sha256 "7e48dc68ce5b6ae68b0371b0decc87f18bd7b519c5c09c80aae88cf49991d57d"
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
