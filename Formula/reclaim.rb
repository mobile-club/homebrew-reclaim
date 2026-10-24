# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.27.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.27.0/reclaim-0.27.0-darwin-arm64.tar.gz"
      sha256 "727838bf3983c16561b393a942327858d2e1058649be949ff44866e4175b5463"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.27.0/reclaim-0.27.0-darwin-x64.tar.gz"
      sha256 "fe3388407b29e47c95d26cb3281b548fa3b53f380dd02f826449195a4db3b912"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.27.0/reclaim-0.27.0-linux-arm64.tar.gz"
      sha256 "5fbb1f073c409c2583f31abd0ce3bf1f7aa639521f7e0ce9ae558fef63debd1c"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.27.0/reclaim-0.27.0-linux-x64.tar.gz"
      sha256 "eb4d058b6eb20b4e53074007144788e487220d4637a9274fd038da038f438272"
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
