# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.16.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.16.0/reclaim-0.16.0-darwin-arm64.tar.gz"
      sha256 "3b9c972481e7ac1d15c9489b86c05d1ba4f61100eb6ea43c38dc595690caa385"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.16.0/reclaim-0.16.0-darwin-x64.tar.gz"
      sha256 "240ae903ae2ad8cfa34344d5efd7a3b2369682ea5ded1c22965c284d075ef692"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.16.0/reclaim-0.16.0-linux-arm64.tar.gz"
      sha256 "106f9f08b93f3f26f650cd07db33adcca2cfadd33f6991afd6da3e2d1e9c448a"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.16.0/reclaim-0.16.0-linux-x64.tar.gz"
      sha256 "c1308377fba8ff15dfd3a56fa1186441314a105916e761e7f413fef2a8de4d1a"
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
