# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.35.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.35.0/reclaim-0.35.0-darwin-arm64.tar.gz"
      sha256 "f41b79a27b257a062c17e6d4f756f4000755b04a3baaf7cba73bb5956b91dda1"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.35.0/reclaim-0.35.0-darwin-x64.tar.gz"
      sha256 "100991301d902f4b78f89b9d209810e893665f679794052d137f85b9be6fb89a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.35.0/reclaim-0.35.0-linux-arm64.tar.gz"
      sha256 "28991073c37fd1d4cfac91d296dce07435656b8153fe2892e07ab8dae26b2dfd"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.35.0/reclaim-0.35.0-linux-x64.tar.gz"
      sha256 "e91ae57eae2f9de526a4bc212cdae1869d0337ea01c3fc2f224a0dbae1c7be71"
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
