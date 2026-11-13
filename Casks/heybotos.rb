cask "heybotos" do
  arch arm: "arm64", intel: "x64"

  version "0.5.1"
  sha256 arm:   "91ea3fe612f6c3191efe444ab92c5e5765cf139290a06a0b30a78406ab15c1af",
         intel: "6552d9e6026abc60a5b8bc3deab4e003bcc984281f76f20ae90e6c9aae944b07"

  url "https://github.com/jannikco/heybotos/releases/download/v#{version}/HeyBotOS-#{version}-#{arch}.zip"
  name "HeyBotOS"
  desc "Manager agent and a team of worker agents on your own coding CLI subscriptions"
  homepage "https://github.com/jannikco/heybotos"

  # While HeyBotOS is in beta its releases are pre-releases, which the usual check skips.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # The app fetches and installs newer versions itself (Settings > General > Version).
  auto_updates true
  depends_on macos: :monterey

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
    HeyBotOS is in beta: expect rough edges and changes between versions. Its
    workers edit files and run commands without asking first, so start with
    projects that are in git.

    HeyBotOS runs the official coding CLIs with your own subscriptions. Install and
    sign in to at least one of: claude, codex, grok.

    This build is not notarised by Apple, so macOS stops it the first time you
    open it. Choose OK in that message (not "Move to Trash"), then go to System
    Settings > Privacy & Security, scroll to Security and choose "Open Anyway".

    Open HeyBotOS once after installing or upgrading: the app sets up and starts
    its background service.
  EOS
end
