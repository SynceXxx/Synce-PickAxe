local savedTheme = "Amethyst"
pcall(function()
   if readfile and isfile and isfile("SynceScript_Theme.txt") then
      savedTheme = readfile("SynceScript_Theme.txt")
   end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Synce Script | Pickaxe Simulator",
   Icon = "command",
   LoadingTitle = "Synce Script",
   LoadingSubtitle = "Professional Script Hub | Loading Resources...",
   Theme = savedTheme,

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "SynceScriptGui"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerStatsFolder = nil
local settingsFolder = nil

task.spawn(function()
    local stats = ReplicatedStorage:WaitForChild("Stats", 10)
    if not stats then return end

    playerStatsFolder = stats:WaitForChild(player.Name, 10)
    if not playerStatsFolder then return end

    settingsFolder = playerStatsFolder:WaitForChild("Settings", 10)
end)

local POCTab = Window:CreateTab("⚙️ Menu", nil)

Rayfield:Notify({
   Title = "🎉 Welcome!",
   Content = "Synce Script Loaded Successfully!",
   Duration = 6.5,
   Image = nil,
})

local SpecialSection = POCTab:CreateSection("⭐ Special Feature ⭐")

local MiningWarning = POCTab:CreateParagraph({
   Title = "⚠️ Warning",
   Content = "Going too fast may cause bugs."
})

local MiningSpeedInput = POCTab:CreateInput({
   Name = "⛏️ Mining Speed Boost (1-9)",
   PlaceholderText = "Enter value 1-9",
   RemoveTextAfterFocusLost = false,
   Flag = "MiningSpeedInput",
   Callback = function(Text)
      local value = tonumber(Text)
      
      if value == nil then
         Rayfield:Notify({
            Title = "❌ Invalid Input",
            Content = "Please enter a valid number!",
            Duration = 3,
         })
         return
      end
      
      if value < 1 or value > 9 then
         Rayfield:Notify({
            Title = "⚠️ Out of Range",
            Content = "Please enter a value between 1-9!",
            Duration = 3,
         })
         return
      end
      
      local boost = ReplicatedStorage.Stats:FindFirstChild(player.Name)
      if boost then
         boost = boost:FindFirstChild("MiningSpeedBoost")
         if boost and boost:IsA("NumberValue") then
            boost.Value = value
            Rayfield:Notify({
               Title = "✅ Success!",
               Content = "Mining Speed set to " .. value .. "x",
               Duration = 3,
            })
         end
      end
   end,
})

local MainFeaturesSection = POCTab:CreateSection("🔧 Main Features")

local AutoRebirthToggle = POCTab:CreateToggle({
   Name = "🔄 Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      if settingsFolder then
         local setting = settingsFolder:FindFirstChild("AutoRebirth")
         if setting and setting:IsA("BoolValue") then
            setting.Value = Value
         end
      end
   end,
})

local AutoTrainToggle = POCTab:CreateToggle({
   Name = "💪 Auto Train",
   CurrentValue = false,
   Flag = "AutoTrain",
   Callback = function(Value)
      if settingsFolder then
         local setting = settingsFolder:FindFirstChild("AutoTrain")
         if setting and setting:IsA("BoolValue") then
            setting.Value = Value
         end
      end
   end,
})

local EggHatchToggle = POCTab:CreateToggle({
   Name = "🥚 Egg Hatch Speed Boost",
   CurrentValue = false,
   Flag = "EggHatchSpeed",
   Callback = function(Value)
      local eggStats = ReplicatedStorage.Stats:FindFirstChild(player.Name)
      if eggStats then
         eggStats = eggStats:FindFirstChild("EggStats")
         if eggStats then
            local stat = eggStats:FindFirstChild("HatchSpeed")
            if stat and stat:IsA("NumberValue") then
               if Value then
                  stat.Value = 7
               else
                  stat.Value = 1
               end
            end
         end
      end
   end,
})

local PremiumToggle = POCTab:CreateToggle({
   Name = "👑 Active 10% Premium",
   CurrentValue = false,
   Flag = "Premium",
   Callback = function(Value)
      task.spawn(function()
         local analytics = ReplicatedStorage.Stats:WaitForChild(player.Name):WaitForChild("Analytics")
         local isPremium = analytics:WaitForChild("IsPremium")
         if isPremium and isPremium:IsA("BoolValue") then
            isPremium.Value = Value
         end
      end)
   end,
})

local InGroupToggle = POCTab:CreateToggle({
   Name = "👥 Claim Reward Group Chest",
   CurrentValue = false,
   Flag = "InGroup",
   Callback = function(Value)
      task.spawn(function()
         local analytics = ReplicatedStorage.Stats:WaitForChild(player.Name):WaitForChild("Analytics")
         local isInGroup = analytics:WaitForChild("IsInGroup")
         if isInGroup and isInGroup:IsA("BoolValue") then
            isInGroup.Value = Value
         end
      end)
   end,
})

local autoRewardEnabled = false
local AutoRewardToggle = POCTab:CreateToggle({
   Name = "🎁 Auto Reward Egg",
   CurrentValue = false,
   Flag = "AutoRewardEgg",
   Callback = function(Value)
      autoRewardEnabled = Value
   end,
})

task.spawn(function()
    while true do
        task.wait(0.25)
        if autoRewardEnabled then
            local menus = player.PlayerGui:FindFirstChild("Menus")
            if not menus then continue end
            local rewardUI = menus:FindFirstChild("Reward")
            if not rewardUI then continue end
            local main = rewardUI.Frame.Main
            local available = main.Claim.Main:FindFirstChild("Available")
            if available and available.Visible == true then
                pcall(function()
                    main.Claim:Activate()
                end)
            end
        end
    end
end)

local CreditsSection = POCTab:CreateSection("⚡ Made by Synce Script ⚡")

local MainTab = Window:CreateTab("👤 Player", nil)
local MainSection = MainTab:CreateSection("🎮 Fun Stuff")

local InfiniteJumpEnabled = false
local JumpConnection = nil

local JumpToggle = MainTab:CreateToggle({
   Name = "🦘 Infinite Jump",
   CurrentValue = false,
   Flag = "JumpForever",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
      
      if Value then
         JumpConnection = game:GetService("UserInputService").JumpRequest:connect(function()
            if InfiniteJumpEnabled then
               game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
            end
         end)
      else
         if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
         end
      end
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "🏃 Walkspeed",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local InfoTab = Window:CreateTab("ℹ️ Information", nil)

local OwnerSection = InfoTab:CreateSection("👑 Script Owner")

local OwnerInfo = InfoTab:CreateParagraph({
   Title = "Developer",
   Content = "This script is created and maintained by Synce Script. A dedicated developer focused on creating high-quality Roblox scripts with user-friendly interfaces and powerful features."
})

local FeaturesSection = InfoTab:CreateSection("⚡ Script Features")

local FeaturesList = InfoTab:CreateParagraph({
   Title = "Current Features",
   Content = "• Mining Speed Boost (1-9x multiplier)\n• Auto Rebirth System\n• Auto Training Mode\n• Egg Hatch Speed Boost (7x)\n• Premium Benefits (10% boost)\n• Group Reward Auto Claim\n• Auto Reward Egg Collection\n• Infinite Jump\n• Custom Walkspeed (0-500)\n• Configuration Saving"
})

local ComingSoonSection = InfoTab:CreateSection("🔮 Coming Soon")

local UpcomingFeatures = InfoTab:CreateParagraph({
   Title = "Upcoming Updates",
   Content = "• Auto Sell System\n• Auto Upgrade Tools\n• Teleport to Areas\n• Custom Mining Areas\n• Pet Auto Equip\n• Daily Rewards Auto Claim\n• Performance Optimization"
})

local VersionSection = InfoTab:CreateSection("📌 Version Information")

local VersionInfo = InfoTab:CreateParagraph({
   Title = "Current Version",
   Content = "Version: 1.0.0\nRelease Date: November 2025\nStatus: Stable\nGame: Pickaxe Simulator"
})

local SupportSection = InfoTab:CreateSection("💬 Support & Feedback")

local SupportInfo = InfoTab:CreateParagraph({
   Title = "Need Help?",
   Content = "If you encounter any bugs or have suggestions for new features, please report them through our feedback system. Your feedback helps us improve the script and add features that you want!"
})

local InfoCredits = InfoTab:CreateSection("⚡ Thank You for Using Synce Script! ⚡")
