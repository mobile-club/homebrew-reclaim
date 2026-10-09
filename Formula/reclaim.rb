# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.6.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.6.0/reclaim-0.6.0-darwin-arm64.tar.gz"
      sha256 "580b744f197de57321922a3a81083fe041d0dcd98744693b90682d5709dba887"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.6.0/reclaim-0.6.0-darwin-x64.tar.gz"
      sha256 "9b18df02b706a5d92e337524706822b745553f48e14b2ef72702ab7b415b552e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.6.0/reclaim-0.6.0-linux-arm64.tar.gz"
      sha256 "a0122b24d487cfeb1cd15874ae8686299d47c25542db49ba6f1fc511bc4a9ef1"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.6.0/reclaim-0.6.0-linux-x64.tar.gz"
      sha256 "e6a7251d1cd03069df8f7f629fcb80f2802257172d0c056d8cac574c1202d893"
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
