# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.15.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.15.0/reclaim-0.15.0-darwin-arm64.tar.gz"
      sha256 "59c96e99952d475851b3b2bb71954802e9f7c58751f1a26dff20d44b9263d8df"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.15.0/reclaim-0.15.0-darwin-x64.tar.gz"
      sha256 "c0fa6600ff5a0a6fbe4b55640135b0ed79a13f047384583f717ac6d2b8f43c8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.15.0/reclaim-0.15.0-linux-arm64.tar.gz"
      sha256 "2148d106b841aacbf3562157c4afab15b120ebe90b237c00be5b9857db5a4a76"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.15.0/reclaim-0.15.0-linux-x64.tar.gz"
      sha256 "bbbba22c0f06c713f40a1f8772734385520b37bc717326430398d76464fd5f9f"
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
