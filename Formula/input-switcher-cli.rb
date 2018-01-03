# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class InputSwitcherCli < Formula
  desc ""
  homepage ""
  url "https://github.com/waynezhang/input-switcher.git", :tag => "0.1"

  def install
    system "unset CC; swift build --disable-sandbox -c release"
    bin.install ".build/release/input-switcher"
  end
end
