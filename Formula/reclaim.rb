# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.23.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.23.0/reclaim-0.23.0-darwin-arm64.tar.gz"
      sha256 "3649c11c723057fdb4ddf2878d27f303da16ffd042eb377f432d14e1973004d3"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.23.0/reclaim-0.23.0-darwin-x64.tar.gz"
      sha256 "a0863015265e8d532fff140e941f30518fa02a454c0e4458f66d11c60280051b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.23.0/reclaim-0.23.0-linux-arm64.tar.gz"
      sha256 "2e040719afe1a6eed157da20fd225358cee3cf85ba1758e52859d8c9d3be3e98"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.23.0/reclaim-0.23.0-linux-x64.tar.gz"
      sha256 "ae028de1913658e172a571ec496478e11fdf8854400ff076d736c10bdbad8e3d"
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
