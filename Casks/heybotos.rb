cask "heybotos" do
  arch arm: "arm64", intel: "x64"

  version "0.3.0"
  sha256 arm:   "07865e353cd30ec3db6023c5c95ab614fa5b219845c9d338b71ad71cee46bc7d",
         intel: "9f85c629a3cf21d99481c6864885119d993f5117e24da7ccedfcea6b5110877a"

  url "https://github.com/jannikco/heybotos/releases/download/v#{version}/HeyBotOS-#{version}-#{arch}.zip"
  name "HeyBotOS"
  desc "Manager agent and a team of worker agents on your own coding CLI subscriptions"
  homepage "https://github.com/jannikco/heybotos"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "HeyBotOS.app"
  binary "#{appdir}/HeyBotOS.app/Contents/Resources/heybotos/bin/heybotos"

  uninstall launchctl: "com.heybotos.daemon",
            quit:      "com.heybotos.app"

  zap trash: [
    "~/heybotos",
    "~/Library/Application Support/HeyBotOS",
    "~/Library/Preferences/com.heybotos.app.plist",
    "~/Library/Saved Application State/com.heybotos.app.savedState",
  ]

  caveats <<~EOS
    HeyBotOS runs the official coding CLIs with your own subscriptions. Install and
    sign in to at least one of: claude, codex, grok.

    This build is not notarised by Apple. The first time, macOS will refuse to
    open it: go to System Settings > Privacy & Security and choose "Open Anyway".

    Open HeyBotOS once after installing or upgrading: the app sets up and starts
    its background service.
  EOS
end
