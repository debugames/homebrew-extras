cask "xppen" do
  version "4.0.8_250414,2025,04"
  sha256 "c792fc0c5df8c38b75267d302d0c3ced49371ac7be73998875279bc627dad3ca"

  url "https://download01.xp-pen.com/file/#{version.csv.second}/#{version.csv.third}/XPPenMac_#{version.csv.first}.zip",
      verified: "download01.xp-pen.com/"
  name "XPPen"
  desc "Driver for XP-Pen tablets"
  homepage "https://www.xp-pen.jp/download-978.html"

  livecheck do
    url "https://www.xp-pen.jp/download-978.html"
    strategy :page_match do |page|
      version = page[/class="name_text".*?>XPPenMac_(.*?)</, 1]
      date = Date.parse(page[/class="name_time".*?>(\w{3} \d{2},\d{4})/, 1])
      "#{version},#{date.year},#{date.month.to_s.rjust(2, "0")}"
    end
  end

  depends_on macos: ">= :high_sierra"

  pkg "XPPenMac_#{version.csv.third}.pkg"

  uninstall launchctl: "com.ugee.PenTablet",
            quit:      "com.ugee.PenTablet",
            script:    {
              # As described in the caveats, this uninstaller requires GUI operations.
              executable: "/Applications/XPPen/UninstallPenTablet.app/Contents/MacOS/UninstallPenTablet",
              sudo:       true,
            },
            pkgutil:   "com.ugee.PenTablet"

  zap trash: [
    "/Users/.localized/.XPPen",
    "/Users/root/.XPPen",
    "/Users/Shared/.XPPen",
    "~/.XPPen",
    "~/Library/Saved Application State/com.ugee.PenTablet.savedState/",
  ]

  caveats <<~EOS
    When you run 'brew uninstall xppen', UninstallPenTablet.app will ask for GUI operations.
    If you accidentally press Cancel in the GUI, please run 'brew uninstall --zap -f xppen' again.
  EOS
end
