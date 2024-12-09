cask "popo" do
  version "4.15.0,1733406069478"
  sha256 "4f9cb27195a56af2700542830dfce98202e4555b1828691300488f652bd72de5"

  url "https://popo.netease.com/file/popomac/POPO-setup_prod_#{version.csv.second}.dmg"
  name "NetEase POPO"
  desc "Instant messaging platform"
  homepage "https://popo.netease.com/"

  livecheck do
    url "https://popo.netease.com/api/open/jsonp/check_version?device=4&callback=callback"
    regex(/callback\((.+)\)/i)
    strategy :page_match do |page, regex|
      build_regex = /^.*?(\d+)\.dmg$/

      match = page.match(regex)
      next if match.blank?

      json = Homebrew::Livecheck::Strategy::Json.parse_json(match[1])
      version = json.dig("data", "version")
      build = json.dig("data", "url")&.[](build_regex, 1)
      next if version.blank? || build.blank?

      "#{version},#{build}"
    end
  end

  depends_on macos: ">= :catalina"

  app "popo_mac.app"

  zap trash: [
    "~/Library/Application Support/Netease/Popo",
    "~/Library/Caches/com.netease.game.popo",
    "~/Library/Preferences/com.netease.game.popo.plist",
    "~/Library/Saved Application State/com.netease.game.popo.savedState",
  ]
end
