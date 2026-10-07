# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.4.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.4.0/reclaim-0.4.0-darwin-arm64.tar.gz"
      sha256 "c3aefce220a5c8a7120f51123661cfc8cf2372a63d1e204e4897a1822739944f"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.4.0/reclaim-0.4.0-darwin-x64.tar.gz"
      sha256 "5393d3e9266d8c018654b5cf7479d9d1563b85a54e76fb1caf4fda8eea961a78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.4.0/reclaim-0.4.0-linux-arm64.tar.gz"
      sha256 "b530a15c342ecdcf8996850e94ba7b962f42ba8d65253280cd15fb499080bcf6"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.4.0/reclaim-0.4.0-linux-x64.tar.gz"
      sha256 "8db5a185f566273ce7d6cdbf61df85c3f3103a700a774f4f91e63898a1d6d9b5"
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
