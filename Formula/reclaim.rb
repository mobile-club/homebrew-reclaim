# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.29.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.29.0/reclaim-0.29.0-darwin-arm64.tar.gz"
      sha256 "91b41c7512d069f4c83ccfeda2671c66f65435a69cb32e8ecda6a041494b838d"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.29.0/reclaim-0.29.0-darwin-x64.tar.gz"
      sha256 "b00d829dbc969045fe22904d649366963e76b5b9aec25215e3eafcd2f3b0ef14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.29.0/reclaim-0.29.0-linux-arm64.tar.gz"
      sha256 "61c4e89e7ed8d1b8fef6a94195cdca1ba317af89e1ac308a5ab5dec3ea427bba"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.29.0/reclaim-0.29.0-linux-x64.tar.gz"
      sha256 "a1d9e7edfbcc988344f6c78a27810529e83446a97b7e53160bd275433232bf6d"
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
