# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.31.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.31.0/reclaim-0.31.0-darwin-arm64.tar.gz"
      sha256 "5c4e8c2d7ed6c8dbb3bbc2bb6a5d78f619711b1a425c4ed916f42433386064f6"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.31.0/reclaim-0.31.0-darwin-x64.tar.gz"
      sha256 "07d0fef48d228a92f6ccc349d5722cc4a22019a4c4fd43611464acbc8d0b13c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.31.0/reclaim-0.31.0-linux-arm64.tar.gz"
      sha256 "b21a747ab076c0b5b2b03cec98c634389ec6e94a86d21a144547fb8730cab3b6"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.31.0/reclaim-0.31.0-linux-x64.tar.gz"
      sha256 "6eaa633cb449dc40bceb1ea92b70377f2fb383ae87bbae3a826d556e7eb41a0d"
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
