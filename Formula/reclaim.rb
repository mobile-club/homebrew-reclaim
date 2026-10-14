# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.14.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.14.0/reclaim-0.14.0-darwin-arm64.tar.gz"
      sha256 "bdb267179c55111ac1b6b69ac2ed0af77f7eb8a3850325452f9762f55ab12bc7"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.14.0/reclaim-0.14.0-darwin-x64.tar.gz"
      sha256 "ccc07faabe91dbc76aab329bcf0e1e2cf254d6cf02d079b28da61c8932b85a6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.14.0/reclaim-0.14.0-linux-arm64.tar.gz"
      sha256 "08d24a9e1051570e3fa65959c1cd0b0d265ebbcb9eea72a48cd4a819928a6cc0"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.14.0/reclaim-0.14.0-linux-x64.tar.gz"
      sha256 "ee89da8ee7e25b24be3214f58ae8d5f65f75825130dfd103fe4a30384b02d436"
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
