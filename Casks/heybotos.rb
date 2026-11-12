cask "heybotos" do
  arch arm: "arm64", intel: "x64"

  version "0.3.0"
  sha256 arm:   "ec3494d065da10e0ef00e5e6dc6a7a81d7ad561022128ba5524f85dbdb51cea0",
         intel: "b9737e0be64dafd4c7506018ff9ee1460fd4a7171d611c9058cd6c135659afce"

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

    This build is not notarised by Apple. The first time, macOS will refuse to
    open it: go to System Settings > Privacy & Security and choose "Open Anyway".

    Open HeyBotOS once after installing or upgrading: the app sets up and starts
    its background service.
  EOS
end
