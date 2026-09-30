# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.1.0/reclaim-0.1.0-darwin-arm64.tar.gz"
      sha256 "4953075fff029ce2e5690690bc44d37ea020c2bff671cc057600c721b549bbbd"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.1.0/reclaim-0.1.0-darwin-x64.tar.gz"
      sha256 "6a23f33af60abc65cc90c3facf3662f1e5fa9b21160c1530e95c19cc263ca076"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.1.0/reclaim-0.1.0-linux-arm64.tar.gz"
      sha256 "ffc32a4dd2db786e2b91476b9b3612cd25246d32a42fb1d2b3ce7c7a74a5cfce"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.1.0/reclaim-0.1.0-linux-x64.tar.gz"
      sha256 "d8b0157bda52c4aed19fc289730790613dede0ff123f501e0dcbcf4cf01b573a"
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
