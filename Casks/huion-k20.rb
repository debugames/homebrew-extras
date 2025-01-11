cask "huion-k20" do
  version "15.6.5.71"
  sha256 "e410c2f133edeb37d93fbf68a53262eb468e3a71555ec8af4433842bac471c69"

  url "https://driverdl.huion.com/driver/K20_K100/HuionTablet_MacDriver_v#{version}.dmg"
  name "Huion K20"
  desc "Driver for Huion K20"
  homepage "https://www.huion.com/jp/index.php?m=content&c=index&a=lists&catid=16&myform=1&down_title=k20"

  livecheck do
    url "https://www.huion.com/jp/index.php?m=content&c=index&a=lists&catid=16&myform=1&down_title=k20"
    regex(/MacDriver_v(\d+(?:\.\d+)*)\.dmg/i)
  end

  depends_on macos: ">= :sierra"

  app "HuionTablet.app"

  # uninstall launchctl: "com.huion.HuionTablet",
  #           quit:      "com.huion.HuionTablet",
  #           pkgutil:   "com.huion.HuionTablet"

  # zap trash: [
  #   "~/Library/Saved Application State/com.huion.HuionTablet.savedState/",
  # ]

  # caveats <<~EOS
  # EOS
end
