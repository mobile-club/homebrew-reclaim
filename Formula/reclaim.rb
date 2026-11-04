# The Reclaim CLI formula for the public tap. `scripts/cli-release.mjs formula`
# renders this file from the published SHA256SUMS: every archive below is the
# exact release asset the CLI's own `update` command downloads, byte for byte.
# The release is public, so the download needs no token.
require "json"

class Reclaim < Formula
  desc "Reclaim command line: every product action through the public API contract"
  homepage "https://github.com/mobile-club/reclaim-cli"
  version "0.33.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.33.0/reclaim-0.33.0-darwin-arm64.tar.gz"
      sha256 "7cd4f7dd7b210deb73eaff608f08df116589b4e950d30ddc770356c36c6f3b33"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.33.0/reclaim-0.33.0-darwin-x64.tar.gz"
      sha256 "2ca418699be371f73ba37a0774a0cb28a5587762e108b2a22ff7a90182a91bfa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.33.0/reclaim-0.33.0-linux-arm64.tar.gz"
      sha256 "13f3f9502b8530b11a19c9a9e874f8d7d4f06a1038ff63921f6795ed3148819f"
    end
    on_intel do
      url "https://github.com/mobile-club/reclaim-cli/releases/download/v0.33.0/reclaim-0.33.0-linux-x64.tar.gz"
      sha256 "ffec475da1b7d79f3973881ac08a48a69f18df21c10957d852a460c717d40356"
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
