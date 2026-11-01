# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.32.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.32.0/reclaim-0.32.0-darwin-arm64.tar.gz"
      sha256 "059909d21f43654c2044038cc82f906d40460ba924b33f8ef98bc8741a0c5727"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.32.0/reclaim-0.32.0-darwin-x64.tar.gz"
      sha256 "c24bc200212e9905249758554420e10a9f77bf861e7e2c467b9000ce30d00e34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.32.0/reclaim-0.32.0-linux-arm64.tar.gz"
      sha256 "1f3dd17ce04d0683937079bed1dcc735f2a6a9e19005d61821adc59e5c869512"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.32.0/reclaim-0.32.0-linux-x64.tar.gz"
      sha256 "3052276ac13f33a26a41b85d2297aa24ce485f7d58218868c3d90fb5287b711c"
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
