# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.36.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.36.0/reclaim-0.36.0-darwin-arm64.tar.gz"
      sha256 "da3dffe7b7b97c49bf5f0cb9f35d8bdb3d0eb82b691b18c12f087bfdf8042406"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.36.0/reclaim-0.36.0-darwin-x64.tar.gz"
      sha256 "53defc9d320a80855ce81f593dd5e5300f70691ccfde167c53a016a2da967980"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.36.0/reclaim-0.36.0-linux-arm64.tar.gz"
      sha256 "b076657ec5f397d87d810464fcb9054366c42566f3b6d6c1f3bc2d864509e157"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.36.0/reclaim-0.36.0-linux-x64.tar.gz"
      sha256 "bb7edfaa7133e27ae7ef10488365aab1b5331200e3319f251d6f155e29d79512"
    end
  end

  # The archive root moves whole into libexec, so the launcher finds its own
  # private Node and manifest beside it. Nothing under the configuration
  # directory is read or written by an install, an upgrade or an uninstall.
  def install
    libexec.install Dir["*"]
    # The mark tells the CLI that Homebrew owns this tree: a check then names
    # `brew upgrade reclaim` and moves nothing.
    (libexec/"homebrew").write ""
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
