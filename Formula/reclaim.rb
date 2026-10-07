# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.5.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.5.0/reclaim-0.5.0-darwin-arm64.tar.gz"
      sha256 "c0029e0544cb7a72080dc4d7c359923ea9c680647191a0026cb7745ef5691953"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.5.0/reclaim-0.5.0-darwin-x64.tar.gz"
      sha256 "520df83df13a149e142a38b096ffcb395f12a8c56bfd54d007747b15dd57cf43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.5.0/reclaim-0.5.0-linux-arm64.tar.gz"
      sha256 "f0a7c5f0f3dc0e8ece9ea26edf103d077f15df7ca2304698461b848b90941a8d"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.5.0/reclaim-0.5.0-linux-x64.tar.gz"
      sha256 "4d81f58d9875e1fe87e029cfae6ea89bfa4745c0162e6006734216dae011665a"
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
