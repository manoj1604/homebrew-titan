class Titan < Formula
  desc "Reproducible per-project Linux dev environments on your Mac, in lightweight VMs"
  homepage "https://github.com/manoj1604/titan"
  version "0.4.0"
  url "https://github.com/manoj1604/titan/releases/download/v#{version}/titan-#{version}-macos-arm64.tar.gz"
  sha256 "24d6bc8f5fc62cd4c551ec54f07e4078716ec9500b2da750dfb66eb8dc979c7f"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia # builds run here; Apple container itself needs macOS 26+ at runtime
  depends_on "container"

  def install
    bin.install "bin/titan"
    (share/"titan").install Dir["share/titan/*"]   # in-VM port forwarder + tunnel gate
    man1.install "share/man/man1/titan.1"
    zsh_completion.install "share/zsh/site-functions/_titan"
    bash_completion.install "share/bash-completion/completions/titan"
    fish_completion.install "share/fish/vendor_completions.d/titan.fish"
  end

  def caveats
    <<~EOS
      Finish setup (starts Apple container, adds the shell hook after asking):
        titan setup
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/titan --version").strip
    assert_predicate share/"titan/titan-fwd-linux-arm64", :exist?
    assert_predicate share/"titan/titan-gate", :executable?
  end
end
