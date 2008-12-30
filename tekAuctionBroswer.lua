
local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)
local TEXT_GAP = 4


local function GSC(cash)
	if not cash then return end
	local g, s, c = floor(cash/10000), floor((cash/100)%100), cash%100
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d.|cffeda55f%02d", g, s, c)
	elseif s > 0 then return string.format("|cffc7c7cf%d.|cffeda55f%02d", s, c)
	else return string.format("|cffc7c7cf%d", c) end
end


for i=1,8 do
	local butt = _G["BrowseButton"..i]
	butt:Hide()
	butt.Show = butt.Hide
end


local panel = CreateFrame("Frame", nil, AuctionFrameBrowse)
panel:SetWidth(605) panel:SetHeight(305)
panel:SetPoint("TOPLEFT", 188, -103)


local rows = {}
for i=1,NUM_ROWS do
	local row = CreateFrame("CheckButton", nil, panel)
	row:SetHeight(ROW_HEIGHT)
	row:SetPoint("LEFT")
	row:SetPoint("RIGHT")
	if i == 1 then row:SetPoint("TOP")
	else row:SetPoint("TOP", rows[i-1], "BOTTOM") end
	row:Disable()
	rows[i] = row

	row:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.578125)

	row:SetCheckedTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetCheckedTexture():SetTexCoord(0, 1, 0, 0.578125)

	local icon = row:CreateTexture()
	icon:SetWidth(ROW_HEIGHT-2) icon:SetHeight(ROW_HEIGHT-2)
	icon:SetPoint("LEFT", row, TEXT_GAP, 0)
	row.icon = icon

	local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	name:SetWidth(155) name:SetHeight(ROW_HEIGHT)
	name:SetPoint("LEFT", icon, "RIGHT", TEXT_GAP, 0)
	name:SetJustifyH("LEFT")
	row.name = name

	local min = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	min:SetWidth(16)
	min:SetPoint("LEFT", name, "RIGHT", TEXT_GAP, 0)
	min:SetJustifyH("RIGHT")
	row.min = min

	local ilvl = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ilvl:SetWidth(24)
	ilvl:SetPoint("LEFT", min, "RIGHT", TEXT_GAP, 0)
	ilvl:SetJustifyH("RIGHT")
	row.ilvl = ilvl

	local owner = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	owner:SetWidth(75) owner:SetHeight(ROW_HEIGHT)
	owner:SetPoint("LEFT", ilvl, "RIGHT", TEXT_GAP, 0)
	owner:SetJustifyH("RIGHT")
	row.owner = owner

	local timeleft = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	timeleft:SetWidth(45)
	timeleft:SetPoint("LEFT", owner, "RIGHT", TEXT_GAP, 0)
	timeleft:SetJustifyH("RIGHT")
	row.timeleft = timeleft

	local bid = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bid:SetWidth(70)
	bid:SetPoint("LEFT", timeleft, "RIGHT", TEXT_GAP, 0)
	bid:SetJustifyH("RIGHT")
	row.bid = bid

	local buyout = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	buyout:SetWidth(70)
	buyout:SetPoint("LEFT", bid, "RIGHT", TEXT_GAP, 0)
	buyout:SetJustifyH("RIGHT")
	row.buyout = buyout

	local unit = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	unit:SetWidth(70)
	unit:SetPoint("LEFT", buyout, "RIGHT", TEXT_GAP, 0)
	unit:SetJustifyH("RIGHT")
	row.unit = unit

	local qty = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	qty:SetWidth(16)
	qty:SetPoint("LEFT", unit, "RIGHT", TEXT_GAP, 0)
	qty:SetJustifyH("RIGHT")
	row.qty = qty
end

local timeframes = {"<30m", "30m-2h", "2-12hr", ">12hr"}
local function Update(...)
	for i,row in pairs(rows) do
		local name, texture, count, quality, canUse, level, minBid, minIncrement, buyout, bidAmount, highBidder, owner = GetAuctionItemInfo("list", i)

		if name then
			local color = ITEM_QUALITY_COLORS[quality]
			local link = GetAuctionItemLink("list", i)
			local _, _, _, iLevel = GetItemInfo(link)
			local duration = GetAuctionItemTimeLeft("list", i)

			row.icon:SetTexture(texture)
			row.name:SetText(name)
			row.name:SetVertexColor(color.r, color.g, color.b)
			row.min:SetText(level ~= 1 and level)
			row.ilvl:SetText(iLevel)
			row.owner:SetText(owner)
			row.timeleft:SetText(timeframes[duration])
			row.bid:SetText(GSC(minBid) or "----")
			row.buyout:SetText(buyout > 0 and GSC(buyout) or "----")
			row.unit:SetText(buyout > 0 and count > 1 and GSC(buyout/count) or "----")
			row.qty:SetText(count)
			row:Enable()
		else
			row.icon:SetTexture()
			row.name:SetText()
			row.min:SetText()
			row.ilvl:SetText()
			row.owner:SetText()
			row.timeleft:SetText()
			row.bid:SetText()
			row.buyout:SetText()
			row.unit:SetText()
			row.qty:SetText()
			row:Disable()
		end
	end
end

panel:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
panel:SetScript("OnEvent", Update)
panel:SetScript("OnShow", Update)


LibStub("tekKonfig-AboutPanel").new(nil, "tekAuctionBroswer")
