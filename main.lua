-- main.lua
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

spawn(function()
    while true do
        if getgenv().autoBuySelected then
            -- Find your plot/base
            local myPlot
            do
                local map = workspace:FindFirstChild("MAP")
                local plots = map and map:FindFirstChild("Plots")
                if plots then
                    for _,p in ipairs(plots:GetChildren()) do
                        local os = p:FindFirstChild("OwnerSign")
                        if os and os:FindFirstChild("YourBase") then
                            myPlot = p; break
                        end
                    end
                end
            end

            -- Iterate all ProximityPrompts
            for _,prompt in ipairs(workspace:GetDescendants()) do
                if not prompt:IsA("ProximityPrompt") then continue end
                local act = prompt.ActionText:lower()
                local obj = prompt.ObjectText

                -- A) Collect coins
                if act == "collect" and myPlot and prompt:IsDescendantOf(myPlot) then
                    local parent = prompt.Parent
                    local pos = parent:IsA("BasePart") and parent.Position
                              or (parent:IsA("Model") and parent.PrimaryPart and parent.PrimaryPart.Position)
                    if pos then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                        prompt:InputHoldBegin(); task.wait(1); prompt:InputHoldEnd()
                        task.wait(0.3)
                    end

                -- B) Lock door
                elseif act == "lock door" and myPlot and prompt:IsDescendantOf(myPlot) then
                    local parent = prompt.Parent
                    local pos = parent:IsA("BasePart") and parent.Position
                              or (parent:IsA("Model") and parent.PrimaryPart and parent.PrimaryPart.Position)
                    if pos then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                        prompt:InputHoldBegin(); task.wait(0.5); prompt:InputHoldEnd()
                        task.wait(1)
                    end

                -- C) Buy pet
                elseif act == "buy" and getgenv().selectedPets[obj] then
                    if myPlot and prompt:IsDescendantOf(myPlot) then continue end
                    local parent = prompt.Parent
                    local pos = parent:IsA("BasePart") and parent.Position
                              or (parent:IsA("Model") and parent.PrimaryPart and parent.PrimaryPart.Position)
                    if pos then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                        prompt:InputHoldBegin(); task.wait(3); prompt:InputHoldEnd()
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(0.7)
    end
end)
