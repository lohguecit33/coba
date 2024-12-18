-- Script Auto Farming Quest Blox Fruits
-- DISCLAIMER: Gunakan script ini dengan risiko Anda sendiri. Menggunakan script bisa melanggar TOS Roblox.

repeat wait() until game:IsLoaded()

-- **Konfigurasi Awal**
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- **Fungsi Teleportasi**
local function teleportTo(position)
    humanoidRootPart.CFrame = CFrame.new(position)
    wait(1) -- Delay untuk memastikan teleportasi stabil
end

-- **Fungsi Mendapatkan Level Pemain**
local function getPlayerLevel()
    local stats = player:FindFirstChild("Stats")
    if stats then
        local level = stats:FindFirstChild("Level")
        if level and level.Value then
            return level.Value
        end
    end
    return nil -- Jika level tidak ditemukan
end

-- **Data Quest Berdasarkan Level**
local questData = {
    {minLevel = 1, maxLevel = 29, npc = "Bandit Quest Giver", enemy = "Bandit", location = Vector3.new(1030, 40, 1000)},
    {minLevel = 30, maxLevel = 59, npc = "Pirate Quest Giver", enemy = "Pirate", location = Vector3.new(1200, 10, 1500)},
    {minLevel = 60, maxLevel = 89, npc = "Desert Quest Giver", enemy = "Desert Bandit", location = Vector3.new(1350, 15, 1700)},
    {minLevel = 90, maxLevel = 119, npc = "Frozen Village Quest Giver", enemy = "Snow Bandit", location = Vector3.new(1700, 40, 1900)},
    {minLevel = 120, maxLevel = 149, npc = "Skylands Quest Giver", enemy = "Sky Bandit", location = Vector3.new(2200, 50, 2500)},
    {minLevel = 150, maxLevel = 179, npc = "Underwater City Quest Giver", enemy = "Fishman Warrior", location = Vector3.new(3000, 15, 2800)},
    {minLevel = 180, maxLevel = 209, npc = "Kingdom of Rose Quest Giver", enemy = "Raider", location = Vector3.new(3500, 40, 3000)},
    {minLevel = 210, maxLevel = 239, npc = "Swan Pirate Quest Giver", enemy = "Swan Pirate", location = Vector3.new(4000, 50, 3200)},
    -- Tambahkan data quest lainnya di sini jika diperlukan
}

-- **Fungsi Menemukan Quest Berdasarkan Level**
local function getQuestForLevel(level)
    for _, quest in ipairs(questData) do
        if level >= quest.minLevel and level <= quest.maxLevel then
            return quest
        end
    end
    return nil -- Jika tidak ada quest yang sesuai
end

-- **Fungsi Mengambil Quest**
local function takeQuest(npcName, location)
    local questNPC = workspace:FindFirstChild(npcName)
    if questNPC then
        teleportTo(location)
        wait(1)
        local prompt = questNPC:FindFirstChild("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
            print("Quest diambil dari NPC:", npcName)
            wait(1)
        else
            print("ProximityPrompt tidak ditemukan untuk NPC:", npcName)
        end
    else
        print("NPC quest tidak ditemukan:", npcName)
    end
end

-- **Fungsi Menyelesaikan Quest**
local function completeQuest(enemyName)
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            teleportTo(enemy.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            wait(0.5)
            local tool = player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                character.Humanoid:EquipTool(tool)
                tool:Activate()
                wait(0.5)
            end
        end
    end
end

-- **Fungsi untuk auto leveling dan pertempuran**
local function autoLeveling()
    local level = getPlayerLevel()
    if level then
        print("Melakukan auto leveling untuk level: " .. level)

        -- Melawan musuh berdasarkan level
        local quest = getQuestForLevel(level)
        if quest then
            print("Menyerang musuh: " .. quest.enemy)
            completeQuest(quest.enemy)
        end
    else
        print("Level pemain tidak ditemukan.")
    end
end

-- **Loop Utama**
while true do
    local level = getPlayerLevel()
    if level then
        local quest = getQuestForLevel(level)
        if quest then
            -- Ambil Quest
            if not player.PlayerGui:FindFirstChild("Quest") then
                print("Mengambil quest untuk level:", level)
                takeQuest(quest.npc, quest.location)
            end
            
            -- Selesaikan Quest
            print("Menyerang musuh:", quest.enemy)
            completeQuest(quest.enemy)
            
            -- Periksa Apakah Quest Selesai
            if player.PlayerGui:FindFirstChild("Quest") == nil then
                print("Quest selesai, mengambil ulang...")
            end
        else
            print("Tidak ada quest yang tersedia untuk level:", level)
            wait(5)
        end
    else
        print("Level pemain tidak ditemukan.")
        wait(5)
    end
    wait(1) -- Delay antar loop
end

-- End of script
