# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.24.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.24.0/reclaim-0.24.0-darwin-arm64.tar.gz"
      sha256 "2638f0314a2264a321f5c1464aefc36bb13e0777775cac3f710fe7b5cc3296ca"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.24.0/reclaim-0.24.0-darwin-x64.tar.gz"
      sha256 "c1dbbc784310c88e09279225874b714867816e577dba04a5b3714737e5c9871a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.24.0/reclaim-0.24.0-linux-arm64.tar.gz"
      sha256 "8ca3a9c1c0d1b0673df780cf1ac2130038dbdb6c10af3e104b773a3f5519e3df"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.24.0/reclaim-0.24.0-linux-x64.tar.gz"
      sha256 "52e8795701f3ee226fed5da89621d6825bcca0167dbaf8a17dfc243cd445bce2"
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
