AddonName, CraftSim = ...

CraftSim.AVERAGEPROFIT.FRAMES = {}

local print = CraftSim.UTIL:SetDebugPrint(CraftSim.CONST.DEBUG_IDS.AVERAGE_PROFIT)

function CraftSim.AVERAGEPROFIT.FRAMES:Init()
    local frameNonWorkOrder = CraftSim.FRAME:CreateCraftSimFrame(
        "CraftSimDetailsFrame", 
        "CraftSim Average Profit", 
        ProfessionsFrame.CraftingPage.SchematicForm,
        ProfessionsFrame.CraftingPage.SchematicForm, 
        "BOTTOMRIGHT", 
        "BOTTOMRIGHT", 
        0, 
        0, 
        320,
        120,
        CraftSim.CONST.FRAMES.STAT_WEIGHTS, false, true, nil, "modulesStatWeights")

    local frameWorkOrder = CraftSim.FRAME:CreateCraftSimFrame(
    "CraftSimDetailsWOFrame", 
    "CraftSim Average Profit " .. CraftSim.UTIL:ColorizeText("WO", CraftSim.CONST.COLORS.GREY), 
    ProfessionsFrame.OrdersPage.OrderView.OrderDetails,
    ProfessionsFrame.OrdersPage.OrderView.OrderDetails, 
    "BOTTOMRIGHT", 
    "BOTTOMRIGHT", 
    0, 
    0, 
    320,
    120,
    CraftSim.CONST.FRAMES.STAT_WEIGHTS_WORK_ORDER, false, true, nil, "modulesStatWeights")

    local function createContent(frame, profitDetailsFrameID, statisticsFrameID)
        frame.content.breakdownButton = CreateFrame("Button", nil, frame.content, "UIPanelButtonTemplate")
        frame.content.breakdownButton:SetPoint("TOP", frame.title, "TOP", (statisticsFrameID and -60) or 0, -15)	
        frame.content.breakdownButton:SetText("Show Explanation")
        frame.content.breakdownButton:SetSize(frame.content.breakdownButton:GetTextWidth() + 15, 20)
        frame.content.breakdownButton:SetScript("OnClick", function(self)
            local profitDetailsFrame = CraftSim.FRAME:GetFrame(profitDetailsFrameID) 
            local isVisible = profitDetailsFrame:IsVisible()
            CraftSim.FRAME:ToggleFrame(profitDetailsFrame, not isVisible)
            frame.content.breakdownButton:SetText(isVisible and "Show Explanation" or not isVisible and "Hide Explanation")
        end)

        frame.content.breakdownButton.tooltip = "Test"

        if statisticsFrameID then
            frame.content.statisticsButton = CraftSim.FRAME:CreateButton("Show Statistics", frame.content, frame.content.breakdownButton, "LEFT", "RIGHT", 1, 0, 15, 20, true, 
            function() 
                local statisticsFrame = CraftSim.FRAME:GetFrame(statisticsFrameID)
                CraftSim.FRAME:ToggleFrame(statisticsFrame, not statisticsFrame:IsVisible())
            end)
        end
        

        frame.content.statText = frame.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.content.statText:SetPoint("LEFT", frame.content, "LEFT", 15, -20)

        frame.content.valueText = frame.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.content.valueText:SetPoint("RIGHT", frame.content, "RIGHT", -15, -20)
        frame:Hide()
    end

    createContent(frameNonWorkOrder, CraftSim.CONST.FRAMES.PROFIT_DETAILS, CraftSim.CONST.FRAMES.STATISTICS)
    createContent(frameWorkOrder, CraftSim.CONST.FRAMES.PROFIT_DETAILS_WORK_ORDER)

    
end

function CraftSim.AVERAGEPROFIT.FRAMES:UpdateAverageProfitDisplay(priceData, statWeights, exportMode)
    local statweightFrame = nil
    if exportMode == CraftSim.CONST.EXPORT_MODE.WORK_ORDER then
        statweightFrame = CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.STAT_WEIGHTS_WORK_ORDER)
    else
        statweightFrame = CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.STAT_WEIGHTS)
    end
    if statWeights == nil then
        statweightFrame.content.statText:SetText("")
        statweightFrame.content.valueText:SetText("")
    else
        local statText = ""
        local valueText = ""

        if statWeights.meanProfit then
            statText = statText .. "Ø Profit / Craft:" .. "\n"
            local relativeValue = CraftSimOptions.showProfitPercentage and priceData.craftingCostPerCraft or nil
            valueText = valueText .. CraftSim.UTIL:FormatMoney(statWeights.meanProfit, true, relativeValue) .. "\n"
        end
        if statWeights.inspiration then
            statText = statText .. "Inspiration:" .. "\n"
            valueText = valueText .. CraftSim.UTIL:FormatMoney(statWeights.inspiration) .. "\n"
        end
        if statWeights.multicraft then
            statText = statText .. "Multicraft:" .. "\n"
            valueText = valueText .. CraftSim.UTIL:FormatMoney(statWeights.multicraft) .. "\n"
        end
        if statWeights.resourcefulness then
            statText = statText .. "Resourcefulness:"
            valueText = valueText .. CraftSim.UTIL:FormatMoney(statWeights.resourcefulness)
        end
        statweightFrame.content.statText:SetText(statText)
        statweightFrame.content.valueText:SetText(valueText)
    end
end

function CraftSim.AVERAGEPROFIT.FRAMES:UpdateExplanation(recipeData, calculationData, exportMode)
    local profitDetailsFrame = nil
    if exportMode == CraftSim.CONST.EXPORT_MODE.WORK_ORDER then
        profitDetailsFrame = CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.PROFIT_DETAILS_WORK_ORDER)
    else
        profitDetailsFrame = CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.PROFIT_DETAILS)
    end
    
end

function CraftSim.AVERAGEPROFIT.FRAMES:InitExplanation()
    local frameNO_WO = CraftSim.FRAME:CreateCraftSimFrame(
        "CraftSimProfitDetailsFrame", 
        "CraftSim Average Profit Explanation", 
        CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.STAT_WEIGHTS),
        UIParent, 
        "CENTER", 
        "CENTER", 
        0, 
        0, 
        1000, 
        600,
        CraftSim.CONST.FRAMES.PROFIT_DETAILS, false, true, "DIALOG")

    local frameWO = CraftSim.FRAME:CreateCraftSimFrame(
        "CraftSimProfitDetailsWOFrame", 
        "CraftSim Average Profit Explanation", 
        CraftSim.FRAME:GetFrame(CraftSim.CONST.FRAMES.STAT_WEIGHTS_WORK_ORDER),
        UIParent, 
        "CENTER", 
        "CENTER", 
        0, 
        0, 
        1000, 
        600,
        CraftSim.CONST.FRAMES.PROFIT_DETAILS_WORK_ORDER, false, true, "DIALOG")

    local function createContent(frame, statweightFrameID)
        frameNO_WO.closeButton:HookScript("OnClick", function(self) 
            CraftSim.FRAME:GetFrame(statweightFrameID).content.breakdownButton:SetText("Show Explanation")
        end)

        frame:Hide()
        frame.content.profitExplanationTab = CraftSim.FRAME:CreateTab("Basic Profit Calculation", frame.content, frame.title, "TOP", "BOTTOM", -50, -15, true, 900, 500, frame.content, frame.title, 0, -50)
        frame.content.hsvExplanationTab = CraftSim.FRAME:CreateTab("HSV and more", frame.content, frame.content.profitExplanationTab, "LEFT", "RIGHT", 0, 0, true, 900, 500, frame.content, frame.title, 0, -50)
        frame.content.profitExplanationTab.content.description = CraftSim.FRAME:CreateText(CraftSim.LOCAL:GetText(CraftSim.CONST.TEXT.PROFIT_EXPLANATION), 
        frame.content.profitExplanationTab.content, frame.content.profitExplanationTab.content, "TOP", "TOP", 0, -20, nil, nil, {type="H", value="LEFT"})

        CraftSim.FRAME:InitTabSystem({frame.content.profitExplanationTab, frame.content.hsvExplanationTab})
    end

    createContent(frameNO_WO, CraftSim.CONST.FRAMES.STAT_WEIGHTS)
    createContent(frameWO, CraftSim.CONST.FRAMES.STAT_WEIGHTS_WORK_ORDER)
end