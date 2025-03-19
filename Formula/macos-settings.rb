class MacosSettings < Formula
  desc "Mike Mackintosh's Personal macOS settings manager for dock, trackpad, and other system preferences"
  homepage "https://github.com/mikemackintosh/homebrew-tap"
  
  # This is a "null" formula that doesn't need to download anything
  url "file://#{HOMEBREW_REPOSITORY}/README.md"
  version "1.0.2"
  sha256 "c3391b9f78c5671810d4ca9e4b6837d54736b8690e12f251c2da7621ed74864e"
  
  # Skip these steps since we're not building anything
  def install
    # Create bin directory
    bin.mkpath
    
    # Copy the scripts from the tap repository to the bin directory
    script_dir = "#{HOMEBREW_REPOSITORY}/Library/Taps/mikemackintosh/homebrew-tap/scripts"
    
    # Create the apply-macos-settings script
    script_path = "#{bin}/apply-macos-settings"
    File.open(script_path, "w") do |file|
      file.puts "#!/bin/bash"
      file.puts "echo 'Applying macOS settings...'"
      file.puts "#{script_dir}/macos-dock-setup.sh"
      file.puts "#{script_dir}/macos-trackpad-setup.sh"
      file.puts "#{script_dir}/macos-screenshot-setup.sh"
      file.puts "#{script_dir}/macos-default-browser-setup.sh"
      file.puts "echo 'All macOS settings have been applied successfully!'"
    end

    # Make the script executable
    FileUtils.chmod 0755, script_path

    # Copy a readme to the share directory
    (share/"macos-settings").mkpath
    (share/"macos-settings").install "README.md" if File.exist?("README.md")
  end
  
  def post_install
    # Run the settings script
    system "#{bin}/apply-macos-settings"
    ohai "MacOS settings have been applied"
  end
  
  def caveats
    <<~EOS
      This formula configures Mike's macOS settings according to personal preferences:
      - Ensures Finder and System Settings are in the dock
      - Adds Applications and Downloads folders to the end of the dock (if not already present)
      - Disables natural scrolling
      - Enables tap to click, dragging, and drag lock
      
      You can reapply these settings at any time by running:
        apply-macos-settings
      
      To reset to default settings, run:
        brew uninstall --zap macos-settings
    EOS
  end
  
  # Method to handle uninstall --zap option
  def zap_info
    {
      delete: [
        "#{HOMEBREW_PREFIX}/bin/apply-macos-settings"
      ]
    }
  end
  
  # Cleanup actions when uninstalling with --zap
  def post_uninstall
    if ARGV.include?("--zap") || ARGV.include?("--with-zap")
      script_dir = "#{HOMEBREW_REPOSITORY}/Library/Taps/mikemackintosh/homebrew-tap/scripts"
      system "#{script_dir}/macos-reset.sh"
    end
  end
end