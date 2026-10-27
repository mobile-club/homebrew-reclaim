# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.28.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.28.0/reclaim-0.28.0-darwin-arm64.tar.gz"
      sha256 "ca85c238fd557e506d5d5e314f8c46814dc17e8fa5ba8e0daff8a095cfa303a6"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.28.0/reclaim-0.28.0-darwin-x64.tar.gz"
      sha256 "265ce33fb00ab6d91dfa627b5b1eccae450266a02eaa24a93c15a0f6b16a1cd6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.28.0/reclaim-0.28.0-linux-arm64.tar.gz"
      sha256 "0f16fbc7778794d40bd762e60943c3313db81a394fdd4a93fd09c26b7a4d1e7a"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.28.0/reclaim-0.28.0-linux-x64.tar.gz"
      sha256 "5677fbacc498c6a79e1aa2f1e0e37bb1964339f356013bec160ced25d321a742"
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
