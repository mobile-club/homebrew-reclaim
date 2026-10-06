# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.2.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.2.0/reclaim-0.2.0-darwin-arm64.tar.gz"
      sha256 "60fe6e479f70aa0ae6b00c4ffddac27a0b4ea01cb0ecbf03edad3ba5083ddb56"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.2.0/reclaim-0.2.0-darwin-x64.tar.gz"
      sha256 "b14c0e866a484d3bdd4a75753f3d8d303f36273576b2c59284d26d480324de7e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.2.0/reclaim-0.2.0-linux-arm64.tar.gz"
      sha256 "7e247f4c14e844f91ba5e8c12ff363008bedeaa235c56ee895e9389dcdbe344d"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.2.0/reclaim-0.2.0-linux-x64.tar.gz"
      sha256 "0478c3787ae004bfe445a187514d9df9d33a8ab467b2c99e3c4b92db36e71463"
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
