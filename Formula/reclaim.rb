# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.34.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.34.0/reclaim-0.34.0-darwin-arm64.tar.gz"
      sha256 "ee82e0730a225b66d5dd92fa637b2129d27ca42076821438941c0dbadd51d599"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.34.0/reclaim-0.34.0-darwin-x64.tar.gz"
      sha256 "13efa25e46d3ee867bef14b0e5650dbf6f97c48e110633cd8cbd9a5fed8726ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.34.0/reclaim-0.34.0-linux-arm64.tar.gz"
      sha256 "6bb49cbc14de09437298dcf0b7995ab9a199f0a79c19d6e4e68b2c402f070279"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.34.0/reclaim-0.34.0-linux-x64.tar.gz"
      sha256 "df593eefdb8e956f126d254b44486678c71cbfa11755d1d9b608738c0c22da18"
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
