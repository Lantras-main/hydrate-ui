local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("HYDRATE_UI") then
	CoreGui.HYDRATE_UI:Destroy()
end

local Library = {}
Library.__index = Library

local Theme = {
	MainBg = Color3.fromRGB(10, 10, 10),
	SectionBg = Color3.fromRGB(16, 16, 16),
	Border = Color3.fromRGB(50, 50, 50),
	Accent = Color3.fromRGB(255, 255, 255),
	Text = Color3.fromRGB(240, 240, 240),
	TextDark = Color3.fromRGB(110, 110, 110),
	Hover = Color3.fromRGB(28, 28, 28)
}

local function Tween(obj, info, props)
	local tween = TweenService:Create(obj, TweenInfo.new(unpack(info)), props)
	tween:Play()
	return tween
end

function Library.new(titleText)
	local self = setmetatable({}, Library)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "HYDRATE_UI"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	
	local success = pcall(function() ScreenGui.Parent = CoreGui end)
	if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

	local LoadScreen = Instance.new("Frame")
	LoadScreen.Size = UDim2.new(0, 220, 0, 80)
	LoadScreen.Position = UDim2.new(0.5, -110, 0.5, -40)
	LoadScreen.BackgroundColor3 = Theme.MainBg
	LoadScreen.BorderSizePixel = 0
	LoadScreen.BackgroundTransparency = 1
	LoadScreen.Parent = ScreenGui

	local LoadStroke = Instance.new("UIStroke")
	LoadStroke.Color = Theme.Border
	LoadStroke.Transparency = 1
	LoadStroke.Thickness = 1
	LoadStroke.Parent = LoadScreen

	local LoadText = Instance.new("TextLabel")
	LoadText.Size = UDim2.new(1, 0, 0, 30)
	LoadText.Position = UDim2.new(0, 0, 0, 15)
	LoadText.BackgroundTransparency = 1
	LoadText.Font = Enum.Font.Code
	LoadText.Text = "HYDRATE LOADING..."
	LoadText.TextColor3 = Theme.Accent
	LoadText.TextSize = 13
	LoadText.TextTransparency = 1
	LoadText.Parent = LoadScreen

	local LoadBarBg = Instance.new("Frame")
	LoadBarBg.Size = UDim2.new(1, -30, 0, 4)
	LoadBarBg.Position = UDim2.new(0, 15, 0, 55)
	LoadBarBg.BackgroundColor3 = Theme.SectionBg
	LoadBarBg.BorderSizePixel = 0
	LoadBarBg.BackgroundTransparency = 1
	LoadBarBg.Parent = LoadScreen

	local LoadBarFill = Instance.new("Frame")
	LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
	LoadBarFill.BackgroundColor3 = Theme.Accent
	LoadBarFill.BorderSizePixel = 0
	LoadBarFill.BackgroundTransparency = 1
	LoadBarFill.Parent = LoadBarBg

	Tween(LoadScreen, {0.3, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})
	Tween(LoadStroke, {0.3, Enum.EasingStyle.Quad}, {Transparency = 0})
	Tween(LoadText, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 0})
	Tween(LoadBarBg, {0.3, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})
	Tween(LoadBarFill, {0.3, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})

	task.wait(0.2)
	Tween(LoadBarFill, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 1, 0)})
	task.wait(0.9)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 560, 0, 440)
	MainFrame.Position = UDim2.new(0.5, -280, 0.5, -220)
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.BorderSizePixel = 0
	MainFrame.BackgroundTransparency = 1
	MainFrame.Parent = ScreenGui

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Theme.Border
	MainStroke.Transparency = 1
	MainStroke.Thickness = 1
	MainStroke.Parent = MainFrame

	Tween(LoadScreen, {0.4, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
	Tween(LoadStroke, {0.4, Enum.EasingStyle.Quad}, {Transparency = 1})
	Tween(LoadText, {0.4, Enum.EasingStyle.Quad}, {TextTransparency = 1})
	Tween(LoadBarBg, {0.4, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
	Tween(LoadBarFill, {0.4, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
	task.delay(0.4, function() LoadScreen:Destroy() end)

	Tween(MainFrame, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {BackgroundTransparency = 0})
	Tween(MainStroke, {0.4, Enum.EasingStyle.Quad}, {Transparency = 0})

	local TitleBar = Instance.new("TextLabel")
	TitleBar.Size = UDim2.new(1, 0, 0, 28)
	TitleBar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	TitleBar.BorderSizePixel = 0
	TitleBar.Font = Enum.Font.Code
	TitleBar.Text = "  HYDRATE // " .. titleText
	TitleBar.TextColor3 = Theme.Text
	TitleBar.TextSize = 12
	TitleBar.TextXAlignment = Enum.TextXAlignment.Left
	TitleBar.Parent = MainFrame

	local TitleStroke = Instance.new("UIStroke")
	TitleStroke.Color = Theme.Border
	TitleStroke.Thickness = 1
	TitleStroke.Parent = TitleBar

	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local TabBar = Instance.new("ScrollingFrame")
	TabBar.Size = UDim2.new(1, -12, 0, 26)
	TabBar.Position = UDim2.new(0, 6, 0, 34)
	TabBar.BackgroundTransparency = 1
	TabBar.BorderSizePixel = 0
	TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
	TabBar.ScrollBarThickness = 0
	TabBar.Parent = MainFrame

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.Padding = UDim.new(0, 4)
	TabListLayout.Parent = TabBar

	local ContainerArea = Instance.new("Frame")
	ContainerArea.Size = UDim2.new(1, -12, 1, -70)
	ContainerArea.Position = UDim2.new(0, 6, 0, 64)
	ContainerArea.BackgroundTransparency = 1
	ContainerArea.Parent = MainFrame

	self.ContainerArea = ContainerArea
	self.TabBar = TabBar
	self.Tabs = {}
	self.FirstTab = true

	return self
end

function Library:AddTab(name)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(0, 110, 1, 0)
	TabButton.BackgroundColor3 = Theme.SectionBg
	TabButton.BorderSizePixel = 0
	TabButton.Font = Enum.Font.Code
	TabButton.Text = name
	TabButton.TextColor3 = Theme.TextDark
	TabButton.TextSize = 12
	TabButton.Parent = self.TabBar

	local TabStroke = Instance.new("UIStroke")
	TabStroke.Color = Theme.Border
	TabStroke.Thickness = 1
	TabStroke.Parent = TabButton

	local TabContent = Instance.new("Frame")
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.BackgroundTransparency = 1
	TabContent.Visible = false
	TabContent.Parent = self.ContainerArea

	local LeftCol = Instance.new("ScrollingFrame")
	LeftCol.Size = UDim2.new(0.488, 0, 1, 0)
	LeftCol.BackgroundTransparency = 1
	LeftCol.BorderSizePixel = 0
	LeftCol.ScrollBarThickness = 2
	LeftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
	LeftCol.CanvasSize = UDim2.new(0, 0, 0, 0)
	LeftCol.Parent = TabContent

	local LeftLayout = Instance.new("UIListLayout")
	LeftLayout.Padding = UDim.new(0, 8)
	LeftLayout.Parent = LeftCol

	local RightCol = Instance.new("ScrollingFrame")
	RightCol.Size = UDim2.new(0.488, 0, 1, 0)
	RightCol.Position = UDim2.new(0.512, 0, 0, 0)
	RightCol.BackgroundTransparency = 1
	RightCol.BorderSizePixel = 0
	RightCol.ScrollBarThickness = 2
	RightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
	RightCol.CanvasSize = UDim2.new(0, 0, 0, 0)
	RightCol.Parent = TabContent

	local RightLayout = Instance.new("UIListLayout")
	RightLayout.Padding = UDim.new(0, 8)
	RightLayout.Parent = RightCol

	if self.FirstTab then
		self.FirstTab = false
		TabContent.Visible = true
		TabButton.TextColor3 = Theme.Accent
		TabButton.BackgroundColor3 = Theme.Hover
	end

	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Content.Visible = false
			tab.Button.TextColor3 = Theme.TextDark
			Tween(tab.Button, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = Theme.SectionBg})
		end
		TabContent.Visible = true
		TabButton.TextColor3 = Theme.Accent
		Tween(TabButton, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = Theme.Hover})
	end)

	local tabObj = {Content = TabContent, Button = TabButton}
	table.insert(self.Tabs, tabObj)

	local SectionAPI = {}

	function SectionAPI:AddSection(side, titleText)
		local parentCol = (side:lower() == "left") and LeftCol or RightCol

		local SectionFrame = Instance.new("Frame")
		SectionFrame.Size = UDim2.new(1, 0, 0, 30)
		SectionFrame.BackgroundColor3 = Theme.SectionBg
		SectionFrame.BorderSizePixel = 0
		SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
		SectionFrame.Parent = parentCol

		local SecStroke = Instance.new("UIStroke")
		SecStroke.Color = Theme.Border
		SecStroke.Thickness = 1
		SecStroke.Parent = SectionFrame

		local SecTitle = Instance.new("TextLabel")
		SecTitle.Size = UDim2.new(1, -12, 0, 24)
		SecTitle.Position = UDim2.new(0, 6, 0, 0)
		SecTitle.BackgroundTransparency = 1
		SecTitle.Font = Enum.Font.Code
		SecTitle.Text = titleText
		SecTitle.TextColor3 = Theme.Text
		SecTitle.TextSize = 12
		SecTitle.TextXAlignment = Enum.TextXAlignment.Left
		SecTitle.Parent = SectionFrame

		local InnerList = Instance.new("UIListLayout")
		InnerList.Padding = UDim.new(0, 6)
		InnerList.SortOrder = Enum.SortOrder.LayoutOrder
		InnerList.Parent = SectionFrame

		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 28)
		Padding.PaddingBottom = UDim.new(0, 8)
		Padding.PaddingLeft = UDim.new(0, 8)
		Padding.PaddingRight = UDim.new(0, 8)
		Padding.Parent = SectionFrame

		local ElementAPI = {}

		function ElementAPI:AddButton(name, callback)
			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1, 0, 0, 26)
			Button.BackgroundColor3 = Theme.MainBg
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.Code
			Button.Text = name
			Button.TextColor3 = Theme.Text
			Button.TextSize = 11
			Button.Parent = SectionFrame

			local BtnStroke = Instance.new("UIStroke")
			BtnStroke.Color = Theme.Border
			BtnStroke.Thickness = 1
			BtnStroke.Parent = Button

			Button.MouseButton1Click:Connect(function()
				Tween(Button, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.MainBg})
				task.delay(0.1, function()
					Tween(Button, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Theme.MainBg, TextColor3 = Theme.Text})
				end)
				if callback then callback() end
			end)
		end

		function ElementAPI:AddToggle(name, default, callback)
			local Toggled = default or false

			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Size = UDim2.new(1, 0, 0, 20)
			ToggleBtn.BackgroundTransparency = 1
			ToggleBtn.Text = ""
			ToggleBtn.Parent = SectionFrame

			local CheckBox = Instance.new("Frame")
			CheckBox.Size = UDim2.new(0, 12, 0, 12)
			CheckBox.Position = UDim2.new(0, 0, 0.5, -6)
			CheckBox.BackgroundColor3 = Toggled and Theme.Accent or Theme.MainBg
			CheckBox.BorderSizePixel = 0
			CheckBox.Parent = ToggleBtn

			local CheckStroke = Instance.new("UIStroke")
			CheckStroke.Color = Theme.Border
			CheckStroke.Thickness = 1
			CheckStroke.Parent = CheckBox

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -20, 1, 0)
			Label.Position = UDim2.new(0, 20, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = name
			Label.TextColor3 = Theme.Text
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleBtn

			local ToggleObj = {}
			function ToggleObj:Set(newState)
				Toggled = newState
				Tween(CheckBox, {0.15, Enum.EasingStyle.Quad}, {
					BackgroundColor3 = Toggled and Theme.Accent or Theme.MainBg
				})
				if callback then callback(Toggled) end
			end

			ToggleBtn.MouseButton1Click:Connect(function()
				ToggleObj:Set(not Toggled)
			end)

			return ToggleObj
		end

		function ElementAPI:AddSlider(name, min, max, default, precise, callback)
			local Value = default or min
			if type(precise) == "function" then
				callback = precise
				precise = false
			end

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 35)
			SliderFrame.BackgroundTransparency = 1
			SliderFrame.Parent = SectionFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 15)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = name .. " // " .. tostring(Value)
			Label.TextColor3 = Theme.Text
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, 0, 0, 8)
			Track.Position = UDim2.new(0, 0, 0, 20)
			Track.BackgroundColor3 = Theme.MainBg
			Track.BorderSizePixel = 0
			Track.Parent = SliderFrame

			local TrackStroke = Instance.new("UIStroke")
			TrackStroke.Color = Theme.Border
			TrackStroke.Thickness = 1
			TrackStroke.Parent = Track

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = Theme.Accent
			Fill.BorderSizePixel = 0
			Fill.Parent = Track

			local draggingSlider = false

			local function UpdateSlider(input)
				local mousePos = input.Position.X
				local absPos = Track.AbsolutePosition.X
				local absSize = Track.AbsoluteSize.X
				if absSize > 0 then
					local pct = math.clamp((mousePos - absPos) / absSize, 0, 1)
					local rawVal = min + (max - min) * pct
					if precise then
						Value = math.floor(rawVal * 100 + 0.5) / 100
					else
						Value = math.floor(rawVal + 0.5)
					end
					Fill.Size = UDim2.new(pct, 0, 1, 0)
					Label.Text = name .. " // " .. tostring(Value)
					if callback then callback(Value) end
				end
			end

			Track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
					UpdateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateSlider(input)
				end
			end)

			local SliderObj = {}
			function SliderObj:Set(newValue)
				Value = math.clamp(newValue, min, max)
				local pct = (Value - min) / (max - min)
				Fill.Size = UDim2.new(pct, 0, 1, 0)
				Label.Text = name .. " // " .. tostring(Value)
				if callback then callback(Value) end
			end

			return SliderObj
		end

		function ElementAPI:AddDropdown(name, list, default, callback)
			local Selected = default or list[1]
			local Dropped = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
			DropdownFrame.BackgroundTransparency = 1
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = SectionFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 15)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = name
			Label.TextColor3 = Theme.TextDark
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = DropdownFrame

			local MainBtn = Instance.new("TextButton")
			MainBtn.Size = UDim2.new(1, 0, 0, 22)
			MainBtn.Position = UDim2.new(0, 0, 0, 18)
			MainBtn.BackgroundColor3 = Theme.MainBg
			MainBtn.AutoButtonColor = false
			MainBtn.Font = Enum.Font.Code
			MainBtn.Text = "  " .. tostring(Selected)
			MainBtn.TextColor3 = Theme.Text
			MainBtn.TextSize = 11
			MainBtn.TextXAlignment = Enum.TextXAlignment.Left
			MainBtn.Parent = DropdownFrame

			local BtnStroke = Instance.new("UIStroke")
			BtnStroke.Color = Theme.Border
			BtnStroke.Thickness = 1
			BtnStroke.Parent = MainBtn

			local DropList = Instance.new("Frame")
			DropList.Size = UDim2.new(1, 0, 0, (#list * 22))
			DropList.Position = UDim2.new(0, 0, 0, 44)
			DropList.BackgroundTransparency = 1
			DropList.Visible = false
			DropList.Parent = DropdownFrame

			local DropLayout = Instance.new("UIListLayout")
			DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
			DropLayout.Parent = DropList

			for _, item in ipairs(list) do
				local ItemBtn = Instance.new("TextButton")
				ItemBtn.Size = UDim2.new(1, 0, 0, 22)
				ItemBtn.BackgroundColor3 = Theme.MainBg
				ItemBtn.AutoButtonColor = false
				ItemBtn.Font = Enum.Font.Code
				ItemBtn.Text = "  " .. tostring(item)
				ItemBtn.TextColor3 = Theme.TextDark
				ItemBtn.TextSize = 11
				ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
				ItemBtn.Parent = DropList

				local ItemStroke = Instance.new("UIStroke")
				ItemStroke.Color = Theme.Border
				ItemStroke.Thickness = 1
				ItemStroke.Parent = ItemBtn

				ItemBtn.MouseButton1Click:Connect(function()
					Selected = item
					MainBtn.Text = "  " .. tostring(Selected)
					Dropped = false
					Tween(DropdownFrame, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, 0, 0, 42)})
					DropList.Visible = false
					if callback then callback(Selected) end
				end)
			end

			MainBtn.MouseButton1Click:Connect(function()
				Dropped = not Dropped
				if Dropped then
					DropList.Visible = true
					Tween(DropdownFrame, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, 0, 0, 44 + (#list * 22))})
				else
					Tween(DropdownFrame, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, 0, 0, 42)})
					task.delay(0.15, function() if not Dropped then DropList.Visible = false end end)
				end
			end)
		end

		function ElementAPI:AddTextbox(name, placeholder, callback)
			local TextboxFrame = Instance.new("Frame")
			TextboxFrame.Size = UDim2.new(1, 0, 0, 42)
			TextboxFrame.BackgroundTransparency = 1
			TextboxFrame.Parent = SectionFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 15)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = name
			Label.TextColor3 = Theme.TextDark
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = TextboxFrame

			local Box = Instance.new("TextBox")
			Box.Size = UDim2.new(1, 0, 0, 22)
			Box.Position = UDim2.new(0, 0, 0, 18)
			Box.BackgroundColor3 = Theme.MainBg
			Box.ClearTextOnFocus = false
			Box.Font = Enum.Font.Code
			Box.PlaceholderText = placeholder or ""
			Box.PlaceholderColor3 = Theme.TextDark
			Box.Text = ""
			Box.TextColor3 = Theme.Text
			Box.TextSize = 11
			Box.TextXAlignment = Enum.TextXAlignment.Left
			Box.Parent = TextboxFrame

			local BoxStroke = Instance.new("UIStroke")
			BoxStroke.Color = Theme.Border
			BoxStroke.Thickness = 1
			BoxStroke.Parent = Box

			Box.FocusLost:Connect(function(enterPressed)
				if callback then callback(Box.Text, enterPressed) end
			end)
		end

		function ElementAPI:AddKeybind(name, defaultKey, callback)
			local SelectedKey = defaultKey or Enum.KeyCode.E
			local Binding = false

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Size = UDim2.new(1, 0, 0, 26)
			KeybindFrame.BackgroundTransparency = 1
			KeybindFrame.Parent = SectionFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -70, 0, 26)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = name
			Label.TextColor3 = Theme.Text
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = KeybindFrame

			local KeyButton = Instance.new("TextButton")
			KeyButton.Size = UDim2.new(0, 60, 0, 20)
			KeyButton.Position = UDim2.new(1, -60, 0, 3)
			KeyButton.BackgroundColor3 = Theme.MainBg
			KeyButton.AutoButtonColor = false
			KeyButton.Font = Enum.Font.Code
			KeyButton.Text = SelectedKey.Name
			KeyButton.TextColor3 = Theme.TextDark
			KeyButton.TextSize = 10
			KeyButton.Parent = KeybindFrame

			local KeyStroke = Instance.new("UIStroke")
			KeyStroke.Color = Theme.Border
			KeyStroke.Thickness = 1
			KeyStroke.Parent = KeyButton

			KeyButton.MouseButton1Click:Connect(function()
				Binding = true
				KeyButton.Text = "..."
				KeyButton.TextColor3 = Theme.Accent
			end)

			UserInputService.InputBegan:Connect(function(input, gpe)
				if Binding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						SelectedKey = input.KeyCode
						KeyButton.Text = SelectedKey.Name
						KeyButton.TextColor3 = Theme.TextDark
						Binding = false
					end
				elseif not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == SelectedKey then
					if callback then callback(SelectedKey) end
				end
			end)
		end

		function ElementAPI:AddLabel(text)
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 18)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.Code
			Label.Text = text
			Label.TextColor3 = Theme.TextDark
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SectionFrame

			local LabelObj = {}
			function LabelObj:Set(newText)
				Label.Text = newText
			end

			return LabelObj
		end

		return ElementAPI
	end

	return SectionAPI
end

return Library
