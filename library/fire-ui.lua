--[[
   ___ _                  _ 
  / __(_)_ __ ___   _   _(_)
 / _\ | | '__/ _ \ | | | | |
/ /   | | | |  __/ | |_| | |
\/    |_|_|  \___|  \__,_|_|
    fire ui library open source
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

for _, oldName in ipairs({"PremiumMobileGui", "PremiumHub", "Fire_ui", "Fireui"}) do
    local oldGui = PlayerGui:FindFirstChild(oldName)
    if oldGui then oldGui:Destroy() end
end

local library = {}
library.CurrentTheme = nil
library.Flags = {}
library._autoSavePath = ""
library._autoSaveEnabled = false
library._fileVersion = 1

local function fixFileName(name)
    if not name or name == "" then
        return "Fireui_AutoSave.json"
    end
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if not name:lower():match("%.json$") then
        name = name .. ".json"
    end
    return name
end

local function getFullPath(fileName)
    fileName = fixFileName(fileName)
    if not fileName:find("/") and not fileName:find("\\") then
        fileName = "Fireui/" .. fileName
    end
    return fileName
end

local function ensureFolder(path)
    if makefolder then
        local folder = path:match("(.+)/[^/]+$")
        if folder and isfolder then
            if not isfolder(folder) then
                pcall(makefolder, folder)
            end
        end
    end
end

local function saveConfig(fullPath)
    if not writefile then return false end
    if not fullPath or fullPath == "" then fullPath = library._autoSavePath end
    if not fullPath or fullPath == "" then return false end
    ensureFolder(fullPath)
    local ok, encoded = pcall(function() return HttpService:JSONEncode(library.Flags) end)
    if ok then pcall(writefile, fullPath, encoded) return true end
    return false
end

local function loadConfig(fullPath)
    if not isfile or not readfile then return false end
    if not fullPath or fullPath == "" then fullPath = library._autoSavePath end
    if not isfile(fullPath) then return false end
    local ok, content = pcall(readfile, fullPath)
    if not ok then return false end
    local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, content)
    if ok2 and type(decoded) == "table" then
        for k,v in pairs(decoded) do library.Flags[k] = v end
        return true
    end
    return false
end

local function onFlagChanged(flag, newVal)
    if flag then
        if typeof(newVal) == "Color3" then
            library.Flags[flag] = {r=newVal.R, g=newVal.G, b=newVal.B, __type="Color3"}
        else
            library.Flags[flag] = newVal
        end
        if library._autoSaveEnabled and library._autoSavePath ~= "" then saveConfig(library._autoSavePath) end
    end
end

local iconMap = {["a-arrow-down"] = "rbxassetid://92867583610071", ["a-arrow-up"] = "rbxassetid://132318504999733", ["a-large-small"] = "rbxassetid://111491496660216", ["accessibility"] = "rbxassetid://114029945302017", ["activity"] = "rbxassetid://94212016861936", ["air-vent"] = "rbxassetid://81517226012329", ["airplay"] = "rbxassetid://115020759309179", ["alarm-clock"] = "rbxassetid://126259032907535", ["alarm-clock-check"] = "rbxassetid://76437352099157", ["alarm-clock-minus"] = "rbxassetid://77364179863205", ["alarm-clock-off"] = "rbxassetid://97904885874823", ["alarm-clock-plus"] = "rbxassetid://80468822979214", ["alarm-smoke"] = "rbxassetid://96965448419685", ["album"] = "rbxassetid://127358331163602", ["align-center-horizontal"] = "rbxassetid://81570549209434", ["align-center-vertical"] = "rbxassetid://118470463752466", ["align-end-horizontal"] = "rbxassetid://139502909745427", ["align-end-vertical"] = "rbxassetid://96528869059554", ["align-horizontal-distribute-center"] = "rbxassetid://97220086126656", ["align-horizontal-distribute-end"] = "rbxassetid://106128590702022", ["align-horizontal-distribute-start"] = "rbxassetid://76074660002997", ["align-horizontal-justify-center"] = "rbxassetid://75732302772427", ["align-horizontal-justify-end"] = "rbxassetid://129167626402283", ["align-horizontal-justify-start"] = "rbxassetid://130161830325281", ["align-horizontal-space-around"] = "rbxassetid://91646106782950", ["align-horizontal-space-between"] = "rbxassetid://103886093046990", ["align-start-horizontal"] = "rbxassetid://125674804697729", ["align-start-vertical"] = "rbxassetid://105020230154823", ["align-vertical-distribute-center"] = "rbxassetid://93791183635525", ["align-vertical-distribute-end"] = "rbxassetid://139354223511433", ["align-vertical-distribute-start"] = "rbxassetid://74961997822126", ["align-vertical-justify-center"] = "rbxassetid://134754696166569", ["align-vertical-justify-end"] = "rbxassetid://92569381441969", ["align-vertical-justify-start"] = "rbxassetid://99692844572718", ["align-vertical-space-around"] = "rbxassetid://96206012459190", ["align-vertical-space-between"] = "rbxassetid://124998077349706", ["ambulance"] = "rbxassetid://78599995190651", ["ampersand"] = "rbxassetid://75272915739209", ["ampersands"] = "rbxassetid://126947193455996", ["amphora"] = "rbxassetid://137370389604364", ["anchor"] = "rbxassetid://92181172123618", ["angry"] = "rbxassetid://74237056000103", ["annoyed"] = "rbxassetid://80064369052011", ["antenna"] = "rbxassetid://99628923540956", ["anvil"] = "rbxassetid://100203029845919", ["aperture"] = "rbxassetid://83396154449972", ["app-window"] = "rbxassetid://93142176757189", ["app-window-mac"] = "rbxassetid://79587216113811", ["apple"] = "rbxassetid://104349242902442", ["archive"] = "rbxassetid://122180020814574", ["archive-restore"] = "rbxassetid://78956681942188", ["archive-x"] = "rbxassetid://75830115088395", ["armchair"] = "rbxassetid://105384358373973", ["arrow-big-down"] = "rbxassetid://81081164158885", ["arrow-big-down-dash"] = "rbxassetid://137987229582002", ["arrow-big-left"] = "rbxassetid://85973092492641", ["arrow-big-left-dash"] = "rbxassetid://97827621354677", ["arrow-big-right"] = "rbxassetid://82960676755590", ["arrow-big-right-dash"] = "rbxassetid://117825834972403", ["arrow-big-up"] = "rbxassetid://93136954756149", ["arrow-big-up-dash"] = "rbxassetid://99260194327483", ["arrow-down"] = "rbxassetid://98764963621439", ["arrow-down-0-1"] = "rbxassetid://120961896217875", ["arrow-down-1-0"] = "rbxassetid://93474255891850", ["arrow-down-a-z"] = "rbxassetid://99554596207900", ["arrow-down-from-line"] = "rbxassetid://132045845807798", ["arrow-down-left"] = "rbxassetid://102899325237364", ["arrow-down-narrow-wide"] = "rbxassetid://129105261655061", ["arrow-down-right"] = "rbxassetid://123109928624974", ["arrow-down-to-dot"] = "rbxassetid://101675355931221", ["arrow-down-to-line"] = "rbxassetid://87050478931254", ["arrow-down-up"] = "rbxassetid://85780258549577", ["arrow-down-wide-narrow"] = "rbxassetid://88461733425991", ["arrow-down-z-a"] = "rbxassetid://76115279362232", ["arrow-left"] = "rbxassetid://102531941843733", ["arrow-left-from-line"] = "rbxassetid://87857914437603", ["arrow-left-right"] = "rbxassetid://131324733048447", ["arrow-left-to-line"] = "rbxassetid://118645136026970", ["arrow-right"] = "rbxassetid://113692007244654", ["arrow-right-from-line"] = "rbxassetid://74073639809355", ["arrow-right-left"] = "rbxassetid://77015754304300", ["arrow-right-to-line"] = "rbxassetid://78632510329852", ["arrow-up"] = "rbxassetid://89282378235317", ["arrow-up-0-1"] = "rbxassetid://105257823943016", ["arrow-up-1-0"] = "rbxassetid://134175521693798", ["arrow-up-a-z"] = "rbxassetid://77763416595160", ["arrow-up-down"] = "rbxassetid://81019887641527", ["arrow-up-from-dot"] = "rbxassetid://124408496673275", ["arrow-up-from-line"] = "rbxassetid://95777664626453", ["arrow-up-left"] = "rbxassetid://123490598231261", ["arrow-up-narrow-wide"] = "rbxassetid://73006024672636", ["arrow-up-right"] = "rbxassetid://129280608535523", ["arrow-up-to-line"] = "rbxassetid://108818207813537", ["arrow-up-wide-narrow"] = "rbxassetid://87437426951568", ["arrow-up-z-a"] = "rbxassetid://107546173611884", ["arrows-up-from-line"] = "rbxassetid://133710016938621", ["asterisk"] = "rbxassetid://88552752106723", ["at-sign"] = "rbxassetid://79059152889146", ["atom"] = "rbxassetid://73167696981648", ["audio-lines"] = "rbxassetid://70930641819242", ["audio-waveform"] = "rbxassetid://86462036665209", ["award"] = "rbxassetid://132740088158419", ["axe"] = "rbxassetid://132405197863294", ["axis-3d"] = "rbxassetid://122438676546804", ["baby"] = "rbxassetid://93472926933440", ["backpack"] = "rbxassetid://140420225386018", ["badge"] = "rbxassetid://116620312917084", ["badge-alert"] = "rbxassetid://101829200081951", ["badge-cent"] = "rbxassetid://133345018873154", ["badge-check"] = "rbxassetid://76078495178149", ["badge-dollar-sign"] = "rbxassetid://127139803581141", ["badge-euro"] = "rbxassetid://120016477674659", ["badge-indian-rupee"] = "rbxassetid://75659682309981", ["badge-info"] = "rbxassetid://131995373201472", ["badge-japanese-yen"] = "rbxassetid://99081574588615", ["badge-minus"] = "rbxassetid://140321561183881", ["badge-percent"] = "rbxassetid://121359224294885", ["badge-plus"] = "rbxassetid://100325578561866", ["badge-pound-sterling"] = "rbxassetid://119688217279444", ["badge-question-mark"] = "rbxassetid://121464963737502", ["badge-russian-ruble"] = "rbxassetid://108839463659864", ["badge-swiss-franc"] = "rbxassetid://91447608372740", ["badge-turkish-lira"] = "rbxassetid://137839965873529", ["badge-x"] = "rbxassetid://122931434733842", ["baggage-claim"] = "rbxassetid://86922213051957", ["ban"] = "rbxassetid://90767043015246", ["banana"] = "rbxassetid://140713420056179", ["bandage"] = "rbxassetid://129660129590770", ["banknote"] = "rbxassetid://104840231536668", ["banknote-arrow-down"] = "rbxassetid://139366449345199", ["banknote-arrow-up"] = "rbxassetid://133758343082529", ["banknote-x"] = "rbxassetid://95348701438065", ["barcode"] = "rbxassetid://118473018143689", ["barrel"] = "rbxassetid://130647115622774", ["baseline"] = "rbxassetid://124677132511270", ["bath"] = "rbxassetid://76031400297942", ["battery"] = "rbxassetid://70765800346189", ["battery-charging"] = "rbxassetid://80139357470047", ["battery-full"] = "rbxassetid://70906718268972", ["battery-low"] = "rbxassetid://139659256984314", ["battery-medium"] = "rbxassetid://105934079398915", ["battery-plus"] = "rbxassetid://91931341486966", ["battery-warning"] = "rbxassetid://115230083817257", ["beaker"] = "rbxassetid://80902539995520", ["bean"] = "rbxassetid://89491967076869", ["bean-off"] = "rbxassetid://98164436608714", ["bed"] = "rbxassetid://97726529032925", ["bed-double"] = "rbxassetid://73820193212911", ["bed-single"] = "rbxassetid://113423940880634", ["beef"] = "rbxassetid://105850162318915", ["beer"] = "rbxassetid://116404978807744", ["beer-off"] = "rbxassetid://120333134736361", ["bell"] = "rbxassetid://97392696311902", ["bell-dot"] = "rbxassetid://93161277118810", ["bell-electric"] = "rbxassetid://100277767266983", ["bell-minus"] = "rbxassetid://126334890449727", ["bell-off"] = "rbxassetid://78560046118930", ["bell-plus"] = "rbxassetid://77014333795836", ["bell-ring"] = "rbxassetid://94612128913941", ["between-horizontal-end"] = "rbxassetid://81602774794322", ["between-horizontal-start"] = "rbxassetid://76112384929846", ["between-vertical-end"] = "rbxassetid://72817612571631", ["between-vertical-start"] = "rbxassetid://85278312190301", ["biceps-flexed"] = "rbxassetid://82004462003936", ["bike"] = "rbxassetid://102930322246035", ["binary"] = "rbxassetid://91751953950088", ["binoculars"] = "rbxassetid://101460003267896", ["biohazard"] = "rbxassetid://95956532900432", ["bird"] = "rbxassetid://132284145117371", ["birdhouse"] = "rbxassetid://83999157401433", ["bitcoin"] = "rbxassetid://95459240442938", ["blend"] = "rbxassetid://111679612185257", ["blinds"] = "rbxassetid://71164165283925", ["blocks"] = "rbxassetid://72212693357737", ["bluetooth"] = "rbxassetid://90506573139443", ["bluetooth-connected"] = "rbxassetid://96315134002985", ["bluetooth-off"] = "rbxassetid://80600044218117", ["bluetooth-searching"] = "rbxassetid://100673019606426", ["bold"] = "rbxassetid://116141470019166", ["bolt"] = "rbxassetid://102881251417484", ["bomb"] = "rbxassetid://139223800924636", ["bone"] = "rbxassetid://111242153474115", ["book"] = "rbxassetid://125383279695672", ["book-a"] = "rbxassetid://104067275658465", ["book-alert"] = "rbxassetid://124159928044853", ["book-audio"] = "rbxassetid://109208148317037", ["book-check"] = "rbxassetid://115999656081696", ["book-copy"] = "rbxassetid://108543407492005", ["book-dashed"] = "rbxassetid://127430784795958", ["book-down"] = "rbxassetid://101011730128222", ["book-headphones"] = "rbxassetid://108670200799574", ["book-heart"] = "rbxassetid://112788845135284", ["book-image"] = "rbxassetid://80808285757226", ["book-key"] = "rbxassetid://116024426170705", ["book-lock"] = "rbxassetid://118765061220571", ["book-marked"] = "rbxassetid://73211024251780", ["book-minus"] = "rbxassetid://112724962046282", ["book-open"] = "rbxassetid://129845326810392", ["book-open-check"] = "rbxassetid://130848362492667", ["book-open-text"] = "rbxassetid://100629528672195", ["book-plus"] = "rbxassetid://140267785051233", ["book-text"] = "rbxassetid://94011772484232", ["book-type"] = "rbxassetid://97817304725443", ["book-up"] = "rbxassetid://98640174079190", ["book-up-2"] = "rbxassetid://130161620853665", ["book-user"] = "rbxassetid://128489189240523", ["book-x"] = "rbxassetid://118754548186537", ["bookmark"] = "rbxassetid://121093149326239", ["bookmark-check"] = "rbxassetid://93940443347986", ["bookmark-minus"] = "rbxassetid://96807096039910", ["bookmark-plus"] = "rbxassetid://121469724491615", ["bookmark-x"] = "rbxassetid://112272342584706", ["boom-box"] = "rbxassetid://99901322535868", ["bot"] = "rbxassetid://80451686744860", ["bot-message-square"] = "rbxassetid://96145330292478", ["bot-off"] = "rbxassetid://140417690560013", ["bottle-wine"] = "rbxassetid://131675403196921", ["bow-arrow"] = "rbxassetid://124089655150375", ["box"] = "rbxassetid://101768155599700", ["boxes"] = "rbxassetid://136372617578355", ["braces"] = "rbxassetid://117761094704041", ["brackets"] = "rbxassetid://74368995728099", ["brain"] = "rbxassetid://92424107303177", ["brain-circuit"] = "rbxassetid://70547962410202", ["brain-cog"] = "rbxassetid://132039205501538", ["brick-wall"] = "rbxassetid://112878522258821", ["brick-wall-fire"] = "rbxassetid://92980588705520", ["brick-wall-shield"] = "rbxassetid://75954432775071", ["briefcase"] = "rbxassetid://96754188164225", ["briefcase-business"] = "rbxassetid://129135125207283", ["briefcase-conveyor-belt"] = "rbxassetid://108665725653714", ["briefcase-medical"] = "rbxassetid://119917756334087", ["bring-to-front"] = "rbxassetid://132975903553748", ["brush"] = "rbxassetid://127035535799640", ["brush-cleaning"] = "rbxassetid://71728977448805", ["bubbles"] = "rbxassetid://106183424168227", ["bug"] = "rbxassetid://83626408925438", ["bug-off"] = "rbxassetid://88020025049245", ["bug-play"] = "rbxassetid://80107955888092", ["building"] = "rbxassetid://110616258983082", ["building-2"] = "rbxassetid://77873775611951", ["bus"] = "rbxassetid://133798469717463", ["bus-front"] = "rbxassetid://89863432456045", ["cable"] = "rbxassetid://128449944504901", ["cable-car"] = "rbxassetid://128643682205596", ["cake"] = "rbxassetid://103131590503275", ["cake-slice"] = "rbxassetid://136769828413242", ["calculator"] = "rbxassetid://74915716529646", ["calendar"] = "rbxassetid://114792700814035", ["calendar-1"] = "rbxassetid://98458364171044", ["calendar-arrow-down"] = "rbxassetid://108415736543437", ["calendar-arrow-up"] = "rbxassetid://70574654109118", ["calendar-check"] = "rbxassetid://71551019465748", ["calendar-check-2"] = "rbxassetid://120231170248276", ["calendar-clock"] = "rbxassetid://119132152594595", ["calendar-cog"] = "rbxassetid://122402172360287", ["calendar-days"] = "rbxassetid://99072017568595", ["calendar-fold"] = "rbxassetid://117368871270394", ["calendar-heart"] = "rbxassetid://88839008103676", ["calendar-minus"] = "rbxassetid://137354318924383", ["calendar-minus-2"] = "rbxassetid://98846170279891", ["calendar-off"] = "rbxassetid://109726151749217", ["calendar-plus"] = "rbxassetid://125266115249843", ["calendar-plus-2"] = "rbxassetid://112264562093883", ["calendar-range"] = "rbxassetid://103641849247576", ["calendar-search"] = "rbxassetid://92010083223634", ["calendar-sync"] = "rbxassetid://78082218499697", ["calendar-x"] = "rbxassetid://106703374806500", ["calendar-x-2"] = "rbxassetid://107518051061147", ["camera"] = "rbxassetid://79950339943067", ["camera-off"] = "rbxassetid://81057636835256", ["candy"] = "rbxassetid://107812129154678", ["candy-cane"] = "rbxassetid://71689468772492", ["candy-off"] = "rbxassetid://110232752314832", ["cannabis"] = "rbxassetid://98792006538601", ["captions"] = "rbxassetid://104960225031445", ["captions-off"] = "rbxassetid://105223545364193", ["car"] = "rbxassetid://121065933462582", ["car-front"] = "rbxassetid://87380942739063", ["car-taxi-front"] = "rbxassetid://122455403384057", ["caravan"] = "rbxassetid://120070979471783", ["card-sim"] = "rbxassetid://134490550095771", ["carrot"] = "rbxassetid://119118221444304", ["case-lower"] = "rbxassetid://129303130603241", ["case-sensitive"] = "rbxassetid://125410273293056", ["case-upper"] = "rbxassetid://111633433531325", ["cassette-tape"] = "rbxassetid://137065788934157", ["cast"] = "rbxassetid://98202245922071", ["castle"] = "rbxassetid://119275077187784", ["cat"] = "rbxassetid://124252153404931", ["cctv"] = "rbxassetid://99979894766624", ["chart-area"] = "rbxassetid://123446436762366", ["chart-bar"] = "rbxassetid://105389816384108", ["chart-bar-big"] = "rbxassetid://72336824986044", ["chart-bar-decreasing"] = "rbxassetid://107217459044963", ["chart-bar-increasing"] = "rbxassetid://88268905998571", ["chart-bar-stacked"] = "rbxassetid://98478751113024", ["chart-candlestick"] = "rbxassetid://125676898615697", ["chart-column"] = "rbxassetid://97915995538580", ["chart-column-big"] = "rbxassetid://98598733210787", ["chart-column-decreasing"] = "rbxassetid://73586137373563", ["chart-column-increasing"] = "rbxassetid://120421615068601", ["chart-column-stacked"] = "rbxassetid://86031449675105", ["chart-gantt"] = "rbxassetid://88811660555940", ["chart-line"] = "rbxassetid://101833156055618", ["chart-network"] = "rbxassetid://104027882693561", ["chart-no-axes-column"] = "rbxassetid://94078751170351", ["chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542", ["chart-no-axes-column-increasing"] = "rbxassetid://140383830943049", ["chart-no-axes-combined"] = "rbxassetid://121424233161912", ["chart-no-axes-gantt"] = "rbxassetid://131936541106368", ["chart-pie"] = "rbxassetid://113412261630136", ["chart-scatter"] = "rbxassetid://108217585014571", ["chart-spline"] = "rbxassetid://90307460742494", ["check"] = "rbxassetid://93898873302694", ["check-check"] = "rbxassetid://95183312173858", ["check-line"] = "rbxassetid://115122343485290", ["chef-hat"] = "rbxassetid://121744015002573", ["cherry"] = "rbxassetid://139519182403183", ["chess-bishop"] = "rbxassetid://121701705580238", ["chess-king"] = "rbxassetid://90885687223462", ["chess-knight"] = "rbxassetid://96467707042169", ["chess-pawn"] = "rbxassetid://111318574652751", ["chess-queen"] = "rbxassetid://98304702099749", ["chess-rook"] = "rbxassetid://76223925830262", ["chevron-down"] = "rbxassetid://134243273101015", ["chevron-first"] = "rbxassetid://105243363790238", ["chevron-last"] = "rbxassetid://89268452603731", ["chevron-left"] = "rbxassetid://73780377692148", ["chevron-right"] = "rbxassetid://92473583511724", ["chevron-up"] = "rbxassetid://122444883127455", ["chevrons-down"] = "rbxassetid://100524612205956", ["chevrons-down-up"] = "rbxassetid://139404716013205", ["chevrons-left"] = "rbxassetid://82617201744347", ["chevrons-left-right"] = "rbxassetid://87910685945204", ["chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526", ["chevrons-right"] = "rbxassetid://139121276490483", ["chevrons-right-left"] = "rbxassetid://87149546686569", ["chevrons-up"] = "rbxassetid://100467452364672", ["chevrons-up-down"] = "rbxassetid://131833120209646", ["chromium"] = "rbxassetid://128165143739006", ["church"] = "rbxassetid://113714744350666", ["cigarette-off"] = "rbxassetid://77797883078452", ["circle"] = "rbxassetid://130359823580534", ["circle-alert"] = "rbxassetid://83898160590116", ["circle-arrow-down"] = "rbxassetid://95901860261344", ["circle-arrow-left"] = "rbxassetid://102148876968988", ["circle-arrow-out-down-left"] = "rbxassetid://140598097856694", ["circle-arrow-out-down-right"] = "rbxassetid://119952801379305", ["circle-arrow-out-up-left"] = "rbxassetid://132858212688303", ["circle-arrow-out-up-right"] = "rbxassetid://81783743753173", ["circle-arrow-right"] = "rbxassetid://70786767999559", ["circle-arrow-up"] = "rbxassetid://84395128546494", ["circle-check"] = "rbxassetid://85262178816537", ["circle-check-big"] = "rbxassetid://93202927221730", ["circle-chevron-down"] = "rbxassetid://137069490345718", ["circle-chevron-left"] = "rbxassetid://130250009740827", ["circle-chevron-right"] = "rbxassetid://125943696958495", ["circle-chevron-up"] = "rbxassetid://111223574026321", ["circle-dashed"] = "rbxassetid://126799443883746", ["circle-divide"] = "rbxassetid://106398997754208", ["circle-dollar-sign"] = "rbxassetid://91106238890387", ["circle-dot"] = "rbxassetid://82947033619201", ["circle-dot-dashed"] = "rbxassetid://111451232827180", ["circle-ellipsis"] = "rbxassetid://91687150884779", ["circle-equal"] = "rbxassetid://95133963751438", ["circle-fading-arrow-up"] = "rbxassetid://104648212910336", ["circle-fading-plus"] = "rbxassetid://91847890443490", ["circle-gauge"] = "rbxassetid://108157549473765", ["circle-minus"] = "rbxassetid://133556159576809", ["circle-off"] = "rbxassetid://97923456918886", ["circle-parking"] = "rbxassetid://124034962915196", ["circle-parking-off"] = "rbxassetid://128369410981252", ["circle-pause"] = "rbxassetid://139337739700879", ["circle-percent"] = "rbxassetid://133311912860256", ["circle-play"] = "rbxassetid://120408917249739", ["circle-plus"] = "rbxassetid://113157136350384", ["circle-pound-sterling"] = "rbxassetid://105476153083828", ["circle-power"] = "rbxassetid://140676030155098", ["circle-question-mark"] = "rbxassetid://97516698664325", ["circle-slash"] = "rbxassetid://125206439913049", ["circle-slash-2"] = "rbxassetid://136766902186549", ["circle-small"] = "rbxassetid://73685402843600", ["circle-star"] = "rbxassetid://120318414957104", ["circle-stop"] = "rbxassetid://87400503942659", ["circle-user"] = "rbxassetid://136220511671311", ["circle-user-round"] = "rbxassetid://95489465399880", ["circle-x"] = "rbxassetid://76821953846248", ["circuit-board"] = "rbxassetid://107695264369312", ["citrus"] = "rbxassetid://139018222976433", ["clapperboard"] = "rbxassetid://132660667070200", ["clipboard"] = "rbxassetid://89601995828423", ["clipboard-check"] = "rbxassetid://92649798577170", ["clipboard-clock"] = "rbxassetid://123957515687745", ["clipboard-copy"] = "rbxassetid://125851897718493", ["clipboard-list"] = "rbxassetid://96460215958908", ["clipboard-minus"] = "rbxassetid://107968008485671", ["clipboard-paste"] = "rbxassetid://74382068849983", ["clipboard-pen"] = "rbxassetid://75290966822953", ["clipboard-pen-line"] = "rbxassetid://77711589791615", ["clipboard-plus"] = "rbxassetid://134285318675662", ["clipboard-type"] = "rbxassetid://89949374318028", ["clipboard-x"] = "rbxassetid://102222456890103", ["clock"] = "rbxassetid://121808839832144", ["clock-1"] = "rbxassetid://129363225422045", ["clock-10"] = "rbxassetid://104332695855541", ["clock-11"] = "rbxassetid://119023205186105", ["clock-12"] = "rbxassetid://117789618723068", ["clock-2"] = "rbxassetid://134710777209413", ["clock-3"] = "rbxassetid://136385631189327", ["clock-4"] = "rbxassetid://121808839832144", ["clock-5"] = "rbxassetid://85082019959457", ["clock-6"] = "rbxassetid://71009733505593", ["clock-7"] = "rbxassetid://103111188546225", ["clock-8"] = "rbxassetid://110059272125337", ["clock-9"] = "rbxassetid://77610027126437", ["clock-alert"] = "rbxassetid://97157344465162", ["clock-arrow-down"] = "rbxassetid://92349314416042", ["clock-arrow-up"] = "rbxassetid://111484286332629", ["clock-check"] = "rbxassetid://85231630218857", ["clock-fading"] = "rbxassetid://93205297285245", ["clock-plus"] = "rbxassetid://93367709263150", ["closed-caption"] = "rbxassetid://99832644030788", ["cloud"] = "rbxassetid://121226497050352", ["cloud-alert"] = "rbxassetid://91967273658626", ["cloud-check"] = "rbxassetid://97318598202432", ["cloud-cog"] = "rbxassetid://96497764065749", ["cloud-download"] = "rbxassetid://121435581993566", ["cloud-drizzle"] = "rbxassetid://139525315752605", ["cloud-fog"] = "rbxassetid://76650233148776", ["cloud-hail"] = "rbxassetid://72320462748242", ["cloud-lightning"] = "rbxassetid://133517088924849", ["cloud-moon"] = "rbxassetid://71938114737914", ["cloud-moon-rain"] = "rbxassetid://127667837827018", ["cloud-off"] = "rbxassetid://131907154501444", ["cloud-rain"] = "rbxassetid://105547081967408", ["cloud-rain-wind"] = "rbxassetid://107414583736721", ["cloud-snow"] = "rbxassetid://72307126270226", ["cloud-sun"] = "rbxassetid://86114208148727", ["cloud-sun-rain"] = "rbxassetid://99041604425705", ["cloud-upload"] = "rbxassetid://93307473217005", ["cloudy"] = "rbxassetid://105360479023346", ["clover"] = "rbxassetid://74925550436750", ["club"] = "rbxassetid://108490365816628", ["code"] = "rbxassetid://107380207681249", ["code-xml"] = "rbxassetid://130150477351734", ["codepen"] = "rbxassetid://135643965971885", ["codesandbox"] = "rbxassetid://106911852964823", ["coffee"] = "rbxassetid://106864403231093", ["cog"] = "rbxassetid://116544501716299", ["coins"] = "rbxassetid://116510979641930", ["columns-2"] = "rbxassetid://113004100221850", ["columns-3"] = "rbxassetid://115223357399375", ["columns-3-cog"] = "rbxassetid://121589691981064", ["columns-4"] = "rbxassetid://130807991968419", ["combine"] = "rbxassetid://79908476334048", ["command"] = "rbxassetid://93648221906330", ["compass"] = "rbxassetid://115123411028382", ["component"] = "rbxassetid://110027788875080", ["computer"] = "rbxassetid://77480056459407", ["concierge-bell"] = "rbxassetid://140384259310436", ["cone"] = "rbxassetid://97759550688437", ["construction"] = "rbxassetid://106539489968173", ["contact"] = "rbxassetid://75868297719012", ["contact-round"] = "rbxassetid://71907624112229", ["container"] = "rbxassetid://91507237573499", ["contrast"] = "rbxassetid://112796643981497", ["cookie"] = "rbxassetid://73159504540002", ["cooking-pot"] = "rbxassetid://94959783129799", ["copy"] = "rbxassetid://78979572434545", ["copy-check"] = "rbxassetid://91177247988892", ["copy-minus"] = "rbxassetid://109524509933035", ["copy-plus"] = "rbxassetid://113618379616952", ["copy-slash"] = "rbxassetid://93805787810390", ["copy-x"] = "rbxassetid://106557557978061", ["copyleft"] = "rbxassetid://78559055698593", ["copyright"] = "rbxassetid://129433635747111", ["corner-down-left"] = "rbxassetid://90473561177832", ["corner-down-right"] = "rbxassetid://86512767702085", ["corner-left-down"] = "rbxassetid://139876989150630", ["corner-left-up"] = "rbxassetid://126228268096099", ["corner-right-down"] = "rbxassetid://89237035551302", ["corner-right-up"] = "rbxassetid://112851237026705", ["corner-up-left"] = "rbxassetid://84669279763024", ["corner-up-right"] = "rbxassetid://115099889693145", ["cpu"] = "rbxassetid://77549309870247", ["creative-commons"] = "rbxassetid://90408210735312", ["credit-card"] = "rbxassetid://99163352872346", ["croissant"] = "rbxassetid://130710485559420", ["crop"] = "rbxassetid://116344601101413", ["cross"] = "rbxassetid://101833377863588", ["crosshair"] = "rbxassetid://134242818164054", ["crown"] = "rbxassetid://127843403295538", ["cuboid"] = "rbxassetid://75618807946111", ["cup-soda"] = "rbxassetid://121098640829562", ["currency"] = "rbxassetid://90551250119972", ["cylinder"] = "rbxassetid://90569677179169", ["dam"] = "rbxassetid://76874486231393", ["database"] = "rbxassetid://126791525623846", ["database-backup"] = "rbxassetid://103403210984699", ["database-zap"] = "rbxassetid://131199921258418", ["decimals-arrow-left"] = "rbxassetid://120198500638749", ["decimals-arrow-right"] = "rbxassetid://118263047146797", ["delete"] = "rbxassetid://126279426372342", ["dessert"] = "rbxassetid://71508133278830", ["diameter"] = "rbxassetid://97429051503783", ["diamond"] = "rbxassetid://105846996304890", ["diamond-minus"] = "rbxassetid://128989071438290", ["diamond-percent"] = "rbxassetid://107717860105959", ["diamond-plus"] = "rbxassetid://134701163723675", ["dice-1"] = "rbxassetid://112650149591038", ["dice-2"] = "rbxassetid://112278274566793", ["dice-3"] = "rbxassetid://118526270626312", ["dice-4"] = "rbxassetid://113365650364004", ["dice-5"] = "rbxassetid://72768312430593", ["dice-6"] = "rbxassetid://85376239182543", ["dices"] = "rbxassetid://81268120302865", ["diff"] = "rbxassetid://135052708609715", ["disc"] = "rbxassetid://101908120120777", ["disc-2"] = "rbxassetid://91419420404185", ["disc-3"] = "rbxassetid://135470554736048", ["disc-album"] = "rbxassetid://74693460404344", ["divide"] = "rbxassetid://136678191878278", ["dna"] = "rbxassetid://74007982981741", ["dna-off"] = "rbxassetid://89612426361540", ["dock"] = "rbxassetid://121997427160252", ["dog"] = "rbxassetid://71920105558570", ["dollar-sign"] = "rbxassetid://127320961224019", ["donut"] = "rbxassetid://72204922742657", ["door-closed"] = "rbxassetid://136249099949073", ["door-closed-locked"] = "rbxassetid://74027613267551", ["door-open"] = "rbxassetid://91306356501736", ["dot"] = "rbxassetid://137321056643916", ["download"] = "rbxassetid://134814648082393", ["drafting-compass"] = "rbxassetid://99701976182841", ["drama"] = "rbxassetid://110297795801577", ["dribbble"] = "rbxassetid://80231809663849", ["drill"] = "rbxassetid://108644821412796", ["drone"] = "rbxassetid://117299095794783", ["droplet"] = "rbxassetid://100597455015098", ["droplet-off"] = "rbxassetid://119365002225172", ["droplets"] = "rbxassetid://140111846025180", ["drum"] = "rbxassetid://136979060344890", ["drumstick"] = "rbxassetid://104662462521709", ["dumbbell"] = "rbxassetid://80277236776212", ["ear"] = "rbxassetid://121894949934209", ["ear-off"] = "rbxassetid://87421916192807", ["earth"] = "rbxassetid://76231597751076", ["earth-lock"] = "rbxassetid://88814147073745", ["eclipse"] = "rbxassetid://114829622118222", ["egg"] = "rbxassetid://117851493400222", ["egg-fried"] = "rbxassetid://90622538210545", ["egg-off"] = "rbxassetid://92288321309285", ["ellipsis"] = "rbxassetid://140019550645825", ["ellipsis-vertical"] = "rbxassetid://117978708573781", ["equal"] = "rbxassetid://123467780715624", ["equal-approximately"] = "rbxassetid://105382689698323", ["equal-not"] = "rbxassetid://76864449458032", ["eraser"] = "rbxassetid://133957773112410", ["ethernet-port"] = "rbxassetid://75391715149314", ["euro"] = "rbxassetid://72229646524456", ["ev-charger"] = "rbxassetid://97906158859623", ["expand"] = "rbxassetid://137492887754537", ["external-link"] = "rbxassetid://129331830773832", ["eye"] = "rbxassetid://100033680381365", ["eye-closed"] = "rbxassetid://111063268625789", ["eye-off"] = "rbxassetid://135928786788378", ["facebook"] = "rbxassetid://72098528632192", ["factory"] = "rbxassetid://102170024318039", ["fan"] = "rbxassetid://78391400440696", ["fast-forward"] = "rbxassetid://121615540167909", ["feather"] = "rbxassetid://91872927606406", ["fence"] = "rbxassetid://123451565578029", ["ferris-wheel"] = "rbxassetid://79729205796176", ["figma"] = "rbxassetid://134182122852301", ["file"] = "rbxassetid://74748492079329", ["file-archive"] = "rbxassetid://77018106869967", ["file-axis-3d"] = "rbxassetid://133912328009885", ["file-badge"] = "rbxassetid://74564895394477", ["file-box"] = "rbxassetid://119264004071690", ["file-braces"] = "rbxassetid://95314128621234", ["file-braces-corner"] = "rbxassetid://77253337986109", ["file-chart-column"] = "rbxassetid://82048481252560", ["file-chart-column-increasing"] = "rbxassetid://134449481172067", ["file-chart-line"] = "rbxassetid://71954360551345", ["file-chart-pie"] = "rbxassetid://81072193564497", ["file-check"] = "rbxassetid://82604001452455", ["file-check-corner"] = "rbxassetid://76295552859171", ["file-clock"] = "rbxassetid://102325208830990", ["file-code"] = "rbxassetid://130978036895504", ["file-code-corner"] = "rbxassetid://78293841184371", ["file-cog"] = "rbxassetid://101385347151368", ["file-diff"] = "rbxassetid://96147216772241", ["file-digit"] = "rbxassetid://89220220354580", ["file-down"] = "rbxassetid://120650154178290", ["file-exclamation-point"] = "rbxassetid://102821865889635", ["file-headphone"] = "rbxassetid://100533735901986", ["file-heart"] = "rbxassetid://132214916401696", ["file-image"] = "rbxassetid://123334057511782", ["file-input"] = "rbxassetid://124728604166044", ["file-key"] = "rbxassetid://118790255921100", ["file-lock"] = "rbxassetid://72170228691242", ["file-minus"] = "rbxassetid://111014798459222", ["file-minus-corner"] = "rbxassetid://119263271735124", ["file-music"] = "rbxassetid://134948051536671", ["file-output"] = "rbxassetid://92146832572911", ["file-pen"] = "rbxassetid://79556179730240", ["file-pen-line"] = "rbxassetid://104622936345006", ["file-play"] = "rbxassetid://89006821567838", ["file-plus"] = "rbxassetid://78881710800060", ["file-plus-corner"] = "rbxassetid://76544604043974", ["file-question-mark"] = "rbxassetid://127617422859576", ["file-scan"] = "rbxassetid://129480105228213", ["file-search"] = "rbxassetid://97780235974933", ["file-search-corner"] = "rbxassetid://90974165234008", ["file-signal"] = "rbxassetid://122070252538165", ["file-sliders"] = "rbxassetid://85787771732439", ["file-spreadsheet"] = "rbxassetid://134501869359270", ["file-stack"] = "rbxassetid://138929929862605", ["file-symlink"] = "rbxassetid://91865722036510", ["file-terminal"] = "rbxassetid://116757454755476", ["file-text"] = "rbxassetid://90496405707281", ["file-type"] = "rbxassetid://115272552799361", ["file-type-corner"] = "rbxassetid://124902230275209", ["file-up"] = "rbxassetid://131173039312748", ["file-user"] = "rbxassetid://99552018455009", ["file-video-camera"] = "rbxassetid://81719056173960", ["file-volume"] = "rbxassetid://111264764438958", ["file-x"] = "rbxassetid://107333775515154", ["file-x-corner"] = "rbxassetid://87554136773609", ["files"] = "rbxassetid://102806336233202", ["film"] = "rbxassetid://120978945609706", ["fingerprint"] = "rbxassetid://112173305232811", ["fire-extinguisher"] = "rbxassetid://111643493006960", ["fish"] = "rbxassetid://124360663785796", ["fish-off"] = "rbxassetid://89756724887508", ["fish-symbol"] = "rbxassetid://118475177681618", ["flag"] = "rbxassetid://78183383236196", ["flag-off"] = "rbxassetid://112944528856799", ["flag-triangle-left"] = "rbxassetid://88045221285272", ["flag-triangle-right"] = "rbxassetid://108292480304566", ["flame"] = "rbxassetid://98218034436456", ["flame-kindling"] = "rbxassetid://139728976917928", ["flashlight"] = "rbxassetid://100286985600444", ["flashlight-off"] = "rbxassetid://79780362871740", ["flask-conical"] = "rbxassetid://128406680901165", ["flask-conical-off"] = "rbxassetid://112597970025298", ["flask-round"] = "rbxassetid://127508287324940", ["flip-horizontal"] = "rbxassetid://122937530107837", ["flip-horizontal-2"] = "rbxassetid://103726993598186", ["flip-vertical"] = "rbxassetid://108003917346888", ["flip-vertical-2"] = "rbxassetid://103836358956328", ["flower"] = "rbxassetid://86129438272762", ["flower-2"] = "rbxassetid://72934574245145", ["focus"] = "rbxassetid://87493973153317", ["fold-horizontal"] = "rbxassetid://92835712442240", ["fold-vertical"] = "rbxassetid://108873727253656", ["folder"] = "rbxassetid://80846616596607", ["folder-archive"] = "rbxassetid://97312009460206", ["folder-check"] = "rbxassetid://128492920904557", ["folder-clock"] = "rbxassetid://111964836738545", ["folder-closed"] = "rbxassetid://118286209350843", ["folder-code"] = "rbxassetid://70624096349370", ["folder-cog"] = "rbxassetid://85299519462846", ["folder-dot"] = "rbxassetid://138687772725278", ["folder-down"] = "rbxassetid://118044108459225", ["folder-git"] = "rbxassetid://121885778095158", ["folder-git-2"] = "rbxassetid://101394054141166", ["folder-heart"] = "rbxassetid://79104747211105", ["folder-input"] = "rbxassetid://90699920697871", ["folder-kanban"] = "rbxassetid://78313285104072", ["folder-key"] = "rbxassetid://85270407596791", ["folder-lock"] = "rbxassetid://119201572260567", ["folder-minus"] = "rbxassetid://85648718999010", ["folder-open"] = "rbxassetid://76018996254888", ["folder-open-dot"] = "rbxassetid://74741494767354", ["folder-output"] = "rbxassetid://101532447937612", ["folder-pen"] = "rbxassetid://112770491173911", ["folder-plus"] = "rbxassetid://91865663406119", ["folder-root"] = "rbxassetid://103333751154693", ["folder-search"] = "rbxassetid://110568075123861", ["folder-search-2"] = "rbxassetid://71276453442655", ["folder-symlink"] = "rbxassetid://127485747227189", ["folder-sync"] = "rbxassetid://91544602659796", ["folder-tree"] = "rbxassetid://85577554337861", ["folder-up"] = "rbxassetid://72008269765857", ["folder-x"] = "rbxassetid://91699618247635", ["folders"] = "rbxassetid://110351216219061", ["footprints"] = "rbxassetid://139192589041315", ["forklift"] = "rbxassetid://72030930983101", ["forward"] = "rbxassetid://97545944739523", ["frame"] = "rbxassetid://109080612832751", ["framer"] = "rbxassetid://108384807262391", ["frown"] = "rbxassetid://124407301067982", ["fuel"] = "rbxassetid://106447647274511", ["fullscreen"] = "rbxassetid://77793665526178", ["funnel"] = "rbxassetid://108829540827529", ["funnel-plus"] = "rbxassetid://100780233821928", ["funnel-x"] = "rbxassetid://70984385812555", ["gallery-horizontal"] = "rbxassetid://80004001442122", ["gallery-horizontal-end"] = "rbxassetid://74672430161161", ["gallery-thumbnails"] = "rbxassetid://136219289862706", ["gallery-vertical"] = "rbxassetid://119299431466725", ["gallery-vertical-end"] = "rbxassetid://106461402088317", ["gamepad"] = "rbxassetid://121607283959010", ["gamepad-2"] = "rbxassetid://92483947987410", ["gamepad-directional"] = "rbxassetid://84342305212226", ["gauge"] = "rbxassetid://110273524101447", ["gavel"] = "rbxassetid://78952298198456", ["gem"] = "rbxassetid://112904952151156", ["georgian-lari"] = "rbxassetid://98084432591687", ["ghost"] = "rbxassetid://113822048130017", ["gift"] = "rbxassetid://109855212076373", ["git-branch"] = "rbxassetid://90490195516649", ["git-branch-minus"] = "rbxassetid://97385010649411", ["git-branch-plus"] = "rbxassetid://125944221134316", ["git-commit-horizontal"] = "rbxassetid://133646041800147", ["git-commit-vertical"] = "rbxassetid://122098032990350", ["git-compare"] = "rbxassetid://91945124438792", ["git-compare-arrows"] = "rbxassetid://84874426520216", ["git-fork"] = "rbxassetid://89954992404765", ["git-graph"] = "rbxassetid://86166832019304", ["git-merge"] = "rbxassetid://131833355158059", ["git-pull-request"] = "rbxassetid://138463010991471", ["git-pull-request-arrow"] = "rbxassetid://94507974577439", ["git-pull-request-closed"] = "rbxassetid://78070600389091", ["git-pull-request-create"] = "rbxassetid://105929577383926", ["git-pull-request-create-arrow"] = "rbxassetid://127422677061091", ["git-pull-request-draft"] = "rbxassetid://76173459869943", ["github"] = "rbxassetid://120349554354380", ["gitlab"] = "rbxassetid://114054627192933", ["glass-water"] = "rbxassetid://115526102400988", ["glasses"] = "rbxassetid://87936407455373", ["globe"] = "rbxassetid://114238209622913", ["globe-lock"] = "rbxassetid://134065526704402", ["goal"] = "rbxassetid://120517954878160", ["gpu"] = "rbxassetid://95577823614219", ["graduation-cap"] = "rbxassetid://93771896340220", ["grape"] = "rbxassetid://134760640415561", ["grid-2x2"] = "rbxassetid://99050491897640", ["grid-2x2-check"] = "rbxassetid://138468840220821", ["grid-2x2-plus"] = "rbxassetid://91811610580247", ["grid-2x2-x"] = "rbxassetid://72407303981388", ["grid-3x2"] = "rbxassetid://95528684210010", ["grid-3x3"] = "rbxassetid://70419024781206", ["grip"] = "rbxassetid://109058783556768", ["grip-horizontal"] = "rbxassetid://136255899715930", ["grip-vertical"] = "rbxassetid://137183678565296", ["group"] = "rbxassetid://107643418926671", ["guitar"] = "rbxassetid://75915531867926", ["ham"] = "rbxassetid://74465607934635", ["hamburger"] = "rbxassetid://93086916815495", ["hammer"] = "rbxassetid://83545120140895", ["hand"] = "rbxassetid://130703864968637", ["hand-coins"] = "rbxassetid://126990543175462", ["hand-fist"] = "rbxassetid://83341608917591", ["hand-grab"] = "rbxassetid://88867162163985", ["hand-heart"] = "rbxassetid://117507367668412", ["hand-helping"] = "rbxassetid://89897738419446", ["hand-metal"] = "rbxassetid://113619498548713", ["hand-platter"] = "rbxassetid://88594727743168", ["handbag"] = "rbxassetid://135675846264061", ["handshake"] = "rbxassetid://78442115255814", ["hard-drive"] = "rbxassetid://88183305858463", ["hard-drive-download"] = "rbxassetid://73913801230614", ["hard-drive-upload"] = "rbxassetid://85762133615118", ["hard-hat"] = "rbxassetid://128050846767382", ["hash"] = "rbxassetid://82890331678520", ["hat-glasses"] = "rbxassetid://101165538224815", ["haze"] = "rbxassetid://108857561768901", ["hdmi-port"] = "rbxassetid://103693661037020", ["heading"] = "rbxassetid://129254312067735", ["heading-1"] = "rbxassetid://118129315662110", ["heading-2"] = "rbxassetid://110209069670094", ["heading-3"] = "rbxassetid://90267885237062", ["heading-4"] = "rbxassetid://129625620307602", ["heading-5"] = "rbxassetid://120386663181267", ["heading-6"] = "rbxassetid://90959079775093", ["headphone-off"] = "rbxassetid://85038251615641", ["headphones"] = "rbxassetid://118833729589183", ["headset"] = "rbxassetid://129269236787694", ["heart"] = "rbxassetid://116559368303288", ["heart-crack"] = "rbxassetid://110987638564119", ["heart-handshake"] = "rbxassetid://111483078692002", ["heart-minus"] = "rbxassetid://96827380163326", ["heart-off"] = "rbxassetid://89748414415617", ["heart-plus"] = "rbxassetid://94877796283249", ["heart-pulse"] = "rbxassetid://129352925579546", ["heater"] = "rbxassetid://140478466880916", ["helicopter"] = "rbxassetid://111557171735930", ["hexagon"] = "rbxassetid://127592089339199", ["highlighter"] = "rbxassetid://77411555641113", ["history"] = "rbxassetid://123980022019922", ["hop"] = "rbxassetid://82778923997672", ["hop-off"] = "rbxassetid://103386036934034", ["hospital"] = "rbxassetid://105868763850707", ["hotel"] = "rbxassetid://132283390859718", ["hourglass"] = "rbxassetid://86160434939203", ["house"] = "rbxassetid://98755624629571", ["house-heart"] = "rbxassetid://136054771868597", ["house-plug"] = "rbxassetid://71438263712075", ["house-plus"] = "rbxassetid://118495165208309", ["house-wifi"] = "rbxassetid://126495519725698", ["ice-cream-bowl"] = "rbxassetid://124867218454386", ["ice-cream-cone"] = "rbxassetid://90751397288639", ["id-card"] = "rbxassetid://75354294622640", ["id-card-lanyard"] = "rbxassetid://90761480469224", ["image-down"] = "rbxassetid://78972295741235", ["image-minus"] = "rbxassetid://101066016918565", ["image-off"] = "rbxassetid://81934811700938", ["image-play"] = "rbxassetid://129501806784210", ["image-plus"] = "rbxassetid://70391970623917", ["image-up"] = "rbxassetid://126610009605241", ["image-upscale"] = "rbxassetid://106963545024679", ["images"] = "rbxassetid://79350649395557", ["import"] = "rbxassetid://116545008906029", ["inbox"] = "rbxassetid://112591360302868", ["indian-rupee"] = "rbxassetid://113038778381805", ["infinity"] = "rbxassetid://98083086936965", ["info"] = "rbxassetid://124560466474914", ["inspection-panel"] = "rbxassetid://70905313146088", ["instagram"] = "rbxassetid://119864798614855", ["italic"] = "rbxassetid://96220378864282", ["iteration-ccw"] = "rbxassetid://140221832794083", ["iteration-cw"] = "rbxassetid://95534489554662", ["japanese-yen"] = "rbxassetid://106362863465813", ["joystick"] = "rbxassetid://99416790224739", ["kanban"] = "rbxassetid://125934100055431", ["kayak"] = "rbxassetid://136107544609389", ["key"] = "rbxassetid://96510194465420", ["key-round"] = "rbxassetid://83619031955390", ["key-square"] = "rbxassetid://94621420033649", ["keyboard"] = "rbxassetid://121474456068237", ["keyboard-music"] = "rbxassetid://121058541758636", ["keyboard-off"] = "rbxassetid://92466375369772", ["lamp"] = "rbxassetid://110730830653382", ["lamp-ceiling"] = "rbxassetid://80032758469141", ["lamp-desk"] = "rbxassetid://85290686983238", ["lamp-floor"] = "rbxassetid://104585881375892", ["lamp-wall-down"] = "rbxassetid://91271394132073", ["lamp-wall-up"] = "rbxassetid://132141464337445", ["land-plot"] = "rbxassetid://96449039620294", ["landmark"] = "rbxassetid://76885079756393", ["languages"] = "rbxassetid://90816903776498", ["laptop"] = "rbxassetid://111387063244975", ["laptop-minimal"] = "rbxassetid://136705765566068", ["laptop-minimal-check"] = "rbxassetid://114352019833865", ["lasso"] = "rbxassetid://121072936884007", ["lasso-select"] = "rbxassetid://105609719912753", ["laugh"] = "rbxassetid://104491311361166", ["layers"] = "rbxassetid://81973586053257", ["layers-2"] = "rbxassetid://70536710516357", ["layout-dashboard"] = "rbxassetid://139929981863901", ["layout-grid"] = "rbxassetid://81344910161871", ["layout-list"] = "rbxassetid://87462136296578", ["layout-panel-left"] = "rbxassetid://125092469751491", ["layout-panel-top"] = "rbxassetid://91943941515944", ["layout-template"] = "rbxassetid://115564446417985", ["leaf"] = "rbxassetid://119951075637174", ["leafy-green"] = "rbxassetid://105146290493154", ["lectern"] = "rbxassetid://106166425183862", ["library"] = "rbxassetid://114334671982047", ["library-big"] = "rbxassetid://106794530191412", ["life-buoy"] = "rbxassetid://81168450671956", ["ligature"] = "rbxassetid://111397873269411", ["lightbulb"] = "rbxassetid://103871245626488", ["lightbulb-off"] = "rbxassetid://83795722296178", ["line-squiggle"] = "rbxassetid://109555164424447", ["link"] = "rbxassetid://131607023382430", ["link-2"] = "rbxassetid://86072351557466", ["link-2-off"] = "rbxassetid://76885956296867", ["linkedin"] = "rbxassetid://132842789255788", ["list"] = "rbxassetid://113179976918783", ["list-check"] = "rbxassetid://72374358471156", ["list-checks"] = "rbxassetid://99809353635593", ["list-chevrons-down-up"] = "rbxassetid://137409641500711", ["list-chevrons-up-down"] = "rbxassetid://81825351389084", ["list-collapse"] = "rbxassetid://124505247702401", ["list-end"] = "rbxassetid://77650610048119", ["list-filter"] = "rbxassetid://103321376129527", ["list-filter-plus"] = "rbxassetid://96385120752336", ["list-indent-decrease"] = "rbxassetid://137879979228193", ["list-indent-increase"] = "rbxassetid://79051053161201", ["list-minus"] = "rbxassetid://138507965142671", ["list-music"] = "rbxassetid://126380635781840", ["list-ordered"] = "rbxassetid://83212528113913", ["list-plus"] = "rbxassetid://112384738137814", ["list-restart"] = "rbxassetid://91703153577421", ["list-start"] = "rbxassetid://84828348299727", ["list-todo"] = "rbxassetid://132980603752108", ["list-tree"] = "rbxassetid://97685396239010", ["list-video"] = "rbxassetid://93648525452489", ["list-x"] = "rbxassetid://113025303988861", ["loader"] = "rbxassetid://78408734580845", ["loader-circle"] = "rbxassetid://116535712789945", ["loader-pinwheel"] = "rbxassetid://108513357940900", ["locate"] = "rbxassetid://84467676590391", ["locate-fixed"] = "rbxassetid://137367361548433", ["locate-off"] = "rbxassetid://73729216338137", ["lock"] = "rbxassetid://134724289526879", ["lock-keyhole"] = "rbxassetid://78672912777756", ["lock-keyhole-open"] = "rbxassetid://110863509313073", ["lock-open"] = "rbxassetid://93597915325122", ["log-in"] = "rbxassetid://103768533135201", ["log-out"] = "rbxassetid://84895399304975", ["logs"] = "rbxassetid://89772091251787", ["lollipop"] = "rbxassetid://84681611583044", ["luggage"] = "rbxassetid://76619236486400", ["magnet"] = "rbxassetid://135162361226972", ["mail"] = "rbxassetid://103945161245599", ["mail-check"] = "rbxassetid://86921536259917", ["mail-minus"] = "rbxassetid://81989813236553", ["mail-open"] = "rbxassetid://122785416858638", ["mail-plus"] = "rbxassetid://104886401588341", ["mail-question-mark"] = "rbxassetid://126540170949819", ["mail-search"] = "rbxassetid://135616173775287", ["mail-warning"] = "rbxassetid://81495303676089", ["mail-x"] = "rbxassetid://74607841705644", ["mailbox"] = "rbxassetid://82765503320335", ["mails"] = "rbxassetid://90673453450080", ["map"] = "rbxassetid://95107167260947", ["map-minus"] = "rbxassetid://129525760577747", ["map-pin"] = "rbxassetid://84279202219901", ["map-pin-check"] = "rbxassetid://118110914690154", ["map-pin-check-inside"] = "rbxassetid://107130529843809", ["map-pin-house"] = "rbxassetid://80546885029816", ["map-pin-minus"] = "rbxassetid://74518762643623", ["map-pin-minus-inside"] = "rbxassetid://79005529692964", ["map-pin-off"] = "rbxassetid://82474689391020", ["map-pin-pen"] = "rbxassetid://113515395277504", ["map-pin-plus"] = "rbxassetid://91875228967029", ["map-pin-plus-inside"] = "rbxassetid://134639656514430", ["map-pin-x"] = "rbxassetid://101085273547316", ["map-pin-x-inside"] = "rbxassetid://126235934252379", ["map-pinned"] = "rbxassetid://103963788475034", ["map-plus"] = "rbxassetid://129388826743495", ["mars"] = "rbxassetid://111287112372511", ["mars-stroke"] = "rbxassetid://131973193186828", ["martini"] = "rbxassetid://82977695401058", ["maximize"] = "rbxassetid://76045941763188", ["maximize-2"] = "rbxassetid://73085922906397", ["medal"] = "rbxassetid://79016002264450", ["megaphone"] = "rbxassetid://118759541854879", ["megaphone-off"] = "rbxassetid://124280774193935", ["meh"] = "rbxassetid://132197867028557", ["memory-stick"] = "rbxassetid://93212591343119", ["menu"] = "rbxassetid://77021539815611", ["merge"] = "rbxassetid://126201866476775", ["message-circle"] = "rbxassetid://127255077587058", ["message-circle-code"] = "rbxassetid://112865244991651", ["message-circle-dashed"] = "rbxassetid://81525157881897", ["message-circle-heart"] = "rbxassetid://101990756073677", ["message-circle-more"] = "rbxassetid://92856823884663", ["message-circle-off"] = "rbxassetid://134955643890328", ["message-circle-plus"] = "rbxassetid://106562979649273", ["message-circle-question-mark"] = "rbxassetid://107700302759934", ["message-circle-reply"] = "rbxassetid://137071749508334", ["message-circle-warning"] = "rbxassetid://119020096067894", ["message-circle-x"] = "rbxassetid://126843387725536", ["message-square"] = "rbxassetid://83881670383280", ["message-square-code"] = "rbxassetid://110968863152123", ["message-square-dashed"] = "rbxassetid://107653455516238", ["message-square-diff"] = "rbxassetid://75472190472625", ["message-square-dot"] = "rbxassetid://127806382463916", ["message-square-heart"] = "rbxassetid://75612811742074", ["message-square-lock"] = "rbxassetid://81268215619563", ["message-square-more"] = "rbxassetid://120139782405970", ["message-square-off"] = "rbxassetid://99961019005789", ["message-square-plus"] = "rbxassetid://76934450256199", ["message-square-quote"] = "rbxassetid://116670768629340", ["message-square-reply"] = "rbxassetid://130985622754637", ["message-square-share"] = "rbxassetid://131017005324026", ["message-square-text"] = "rbxassetid://94899503194205", ["message-square-warning"] = "rbxassetid://138432903962261", ["message-square-x"] = "rbxassetid://137285463279462", ["messages-square"] = "rbxassetid://97532166733358", ["mic"] = "rbxassetid://89640799126523", ["mic-off"] = "rbxassetid://82123034444822", ["mic-vocal"] = "rbxassetid://99082286164362", ["microchip"] = "rbxassetid://73937907669903", ["microscope"] = "rbxassetid://116875530102782", ["microwave"] = "rbxassetid://108411735353008", ["milestone"] = "rbxassetid://101618292325920", ["milk"] = "rbxassetid://96221903896918", ["milk-off"] = "rbxassetid://72388480962742", ["minimize"] = "rbxassetid://121304296213645", ["minimize-2"] = "rbxassetid://116269596042539", ["minus"] = "rbxassetid://118026365011536", ["monitor"] = "rbxassetid://72664649203050", ["monitor-check"] = "rbxassetid://86651948439229", ["monitor-cloud"] = "rbxassetid://85931096038318", ["monitor-cog"] = "rbxassetid://94345128715799", ["monitor-dot"] = "rbxassetid://130394010063680", ["monitor-down"] = "rbxassetid://97466933743423", ["monitor-off"] = "rbxassetid://74395526657953", ["monitor-pause"] = "rbxassetid://76002184067562", ["monitor-play"] = "rbxassetid://133018824306217", ["monitor-smartphone"] = "rbxassetid://84335680433378", ["monitor-speaker"] = "rbxassetid://81744810060380", ["monitor-stop"] = "rbxassetid://98708958984757", ["monitor-up"] = "rbxassetid://96035360858377", ["monitor-x"] = "rbxassetid://126265210441423", ["moon"] = "rbxassetid://83380517901735", ["moon-star"] = "rbxassetid://82782200506348", ["motorbike"] = "rbxassetid://94580787368233", ["mountain"] = "rbxassetid://73269957566415", ["mountain-snow"] = "rbxassetid://105315495740588", ["mouse"] = "rbxassetid://73096068864710", ["mouse-off"] = "rbxassetid://75267871697595", ["mouse-pointer"] = "rbxassetid://72322454962935", ["mouse-pointer-2"] = "rbxassetid://117093892862228", ["mouse-pointer-2-off"] = "rbxassetid://104701076865632", ["mouse-pointer-ban"] = "rbxassetid://106849413057133", ["mouse-pointer-click"] = "rbxassetid://107150227368485", ["move"] = "rbxassetid://116138709011735", ["move-3d"] = "rbxassetid://103365982054003", ["move-diagonal"] = "rbxassetid://101433481954184", ["move-diagonal-2"] = "rbxassetid://117298577948096", ["move-down"] = "rbxassetid://70510115135583", ["move-down-left"] = "rbxassetid://102819433534567", ["move-down-right"] = "rbxassetid://101479760041877", ["move-horizontal"] = "rbxassetid://88513523439149", ["move-left"] = "rbxassetid://137614740247980", ["move-right"] = "rbxassetid://132455779472989", ["move-up"] = "rbxassetid://84505444262658", ["move-up-left"] = "rbxassetid://139079815540148", ["move-up-right"] = "rbxassetid://105885140592646", ["move-vertical"] = "rbxassetid://86234730730899", ["music"] = "rbxassetid://113343203848535", ["music-2"] = "rbxassetid://134397426600888", ["music-3"] = "rbxassetid://94466120066498", ["music-4"] = "rbxassetid://132459323665838", ["navigation"] = "rbxassetid://79308213542922", ["navigation-2"] = "rbxassetid://81889066747907", ["navigation-2-off"] = "rbxassetid://116569611780763", ["navigation-off"] = "rbxassetid://87003270290777", ["network"] = "rbxassetid://127410729922644", ["newspaper"] = "rbxassetid://123479530460544", ["nfc"] = "rbxassetid://76822396542242", ["non-binary"] = "rbxassetid://78442360386235", ["notebook"] = "rbxassetid://136132108664987", ["notebook-pen"] = "rbxassetid://140380614761023", ["notebook-tabs"] = "rbxassetid://127371085570083", ["notebook-text"] = "rbxassetid://93061585217270", ["notepad-text"] = "rbxassetid://93404682958966", ["notepad-text-dashed"] = "rbxassetid://135793446376219", ["nut"] = "rbxassetid://127146410705656", ["nut-off"] = "rbxassetid://78795397311573", ["octagon"] = "rbxassetid://120803515514852", ["octagon-alert"] = "rbxassetid://140438367956051", ["octagon-minus"] = "rbxassetid://74720436795421", ["octagon-pause"] = "rbxassetid://103161463909039", ["octagon-x"] = "rbxassetid://90498161006311", ["omega"] = "rbxassetid://70414080018786", ["option"] = "rbxassetid://100776883894054", ["orbit"] = "rbxassetid://108926136860562", ["origami"] = "rbxassetid://136020626667101", ["package"] = "rbxassetid://97261141732706", ["package-2"] = "rbxassetid://70394974762575", ["package-check"] = "rbxassetid://102374216055130", ["package-minus"] = "rbxassetid://114492858789692", ["package-open"] = "rbxassetid://132890233237818", ["package-plus"] = "rbxassetid://129261988138366", ["package-search"] = "rbxassetid://95465120894145", ["package-x"] = "rbxassetid://70818501607442", ["paint-bucket"] = "rbxassetid://124275586663284", ["paint-roller"] = "rbxassetid://115248074358348", ["paintbrush"] = "rbxassetid://125572663700289", ["paintbrush-vertical"] = "rbxassetid://105151296591292", ["palette"] = "rbxassetid://86350350950064", ["panda"] = "rbxassetid://132509022802512", ["panel-bottom"] = "rbxassetid://132127145048511", ["panel-bottom-close"] = "rbxassetid://74287004071159", ["panel-bottom-dashed"] = "rbxassetid://131084651621603", ["panel-bottom-open"] = "rbxassetid://107768659586540", ["panel-left"] = "rbxassetid://97419752870313", ["panel-left-close"] = "rbxassetid://126579818823552", ["panel-left-dashed"] = "rbxassetid://75536606374585", ["panel-left-open"] = "rbxassetid://111075816195767", ["panel-left-right-dashed"] = "rbxassetid://110100707973959", ["panel-right"] = "rbxassetid://116365035443156", ["panel-right-close"] = "rbxassetid://139528655524132", ["panel-right-dashed"] = "rbxassetid://94959793877311", ["panel-right-open"] = "rbxassetid://118114419142794", ["panel-top"] = "rbxassetid://75838479462875", ["panel-top-bottom-dashed"] = "rbxassetid://134737235653344", ["panel-top-close"] = "rbxassetid://83578325777808", ["panel-top-dashed"] = "rbxassetid://70522913169237", ["panel-top-open"] = "rbxassetid://137959875507454", ["panels-left-bottom"] = "rbxassetid://72996856149149", ["panels-right-bottom"] = "rbxassetid://90659068960726", ["panels-top-left"] = "rbxassetid://79858853850600", ["paperclip"] = "rbxassetid://92088291163453", ["parentheses"] = "rbxassetid://78950955173096", ["parking-meter"] = "rbxassetid://84652733960568", ["party-popper"] = "rbxassetid://111626795712193", ["pause"] = "rbxassetid://74873705394436", ["paw-print"] = "rbxassetid://112218825427601", ["pc-case"] = "rbxassetid://122978648019101", ["pen"] = "rbxassetid://72037878096321", ["pen-line"] = "rbxassetid://109108135755303", ["pen-off"] = "rbxassetid://84807123119438", ["pen-tool"] = "rbxassetid://106145404953445", ["pencil"] = "rbxassetid://137986121120732", ["pencil-line"] = "rbxassetid://88392917053533", ["pencil-off"] = "rbxassetid://103330927652832", ["pencil-ruler"] = "rbxassetid://110120288284597", ["pentagon"] = "rbxassetid://79184802179890", ["percent"] = "rbxassetid://130155041032013", ["person-standing"] = "rbxassetid://125020872044147", ["philippine-peso"] = "rbxassetid://91173798254675", ["phone"] = "rbxassetid://128804946640049", ["phone-call"] = "rbxassetid://70555587592860", ["phone-forwarded"] = "rbxassetid://113269614319737", ["phone-incoming"] = "rbxassetid://82863576359288", ["phone-missed"] = "rbxassetid://130156165198376", ["phone-off"] = "rbxassetid://133318623553383", ["phone-outgoing"] = "rbxassetid://104576478735825", ["pi"] = "rbxassetid://74936036243146", ["piano"] = "rbxassetid://85008880789520", ["pickaxe"] = "rbxassetid://105888023317688", ["picture-in-picture"] = "rbxassetid://80579597835123", ["picture-in-picture-2"] = "rbxassetid://112803319544468", ["piggy-bank"] = "rbxassetid://79498575790721", ["pilcrow"] = "rbxassetid://139512780392871", ["pilcrow-left"] = "rbxassetid://103803000849583", ["pilcrow-right"] = "rbxassetid://104881733911870", ["pill"] = "rbxassetid://73280534813448", ["pill-bottle"] = "rbxassetid://118394692404597", ["pin"] = "rbxassetid://120978111007514", ["pin-off"] = "rbxassetid://127696372451750", ["pipette"] = "rbxassetid://133167932934404", ["pizza"] = "rbxassetid://126964453193501", ["plane"] = "rbxassetid://126985561580989", ["plane-landing"] = "rbxassetid://122555692211889", ["plane-takeoff"] = "rbxassetid://117179478829575", ["play"] = "rbxassetid://135609604299893", ["plug"] = "rbxassetid://99782373064495", ["plug-2"] = "rbxassetid://97912386476366", ["plug-zap"] = "rbxassetid://74506269884055", ["plus"] = "rbxassetid://111774323017047", ["pocket"] = "rbxassetid://136686762542964", ["pocket-knife"] = "rbxassetid://134075428063965", ["podcast"] = "rbxassetid://109577075549215", ["pointer"] = "rbxassetid://92615117311099", ["pointer-off"] = "rbxassetid://95488389312794", ["popcorn"] = "rbxassetid://139446511232750", ["popsicle"] = "rbxassetid://112696318077073", ["pound-sterling"] = "rbxassetid://127482649469130", ["power"] = "rbxassetid://96479131758775", ["power-off"] = "rbxassetid://118768311012214", ["presentation"] = "rbxassetid://106134583757890", ["printer"] = "rbxassetid://76080649734247", ["printer-check"] = "rbxassetid://130273549443689", ["projector"] = "rbxassetid://103281856385283", ["proportions"] = "rbxassetid://130046855997237", ["puzzle"] = "rbxassetid://136837798892463", ["pyramid"] = "rbxassetid://107811442374127", ["qr-code"] = "rbxassetid://105329945723350", ["quote"] = "rbxassetid://103271711590001", ["rabbit"] = "rbxassetid://98580518804206", ["radar"] = "rbxassetid://138528222906635", ["radiation"] = "rbxassetid://104499586848433", ["radical"] = "rbxassetid://132758286926047", ["radio"] = "rbxassetid://85611589536956", ["radio-receiver"] = "rbxassetid://129598303378835", ["radio-tower"] = "rbxassetid://93958663130054", ["radius"] = "rbxassetid://89814505307129", ["rail-symbol"] = "rbxassetid://134295386306962", ["rainbow"] = "rbxassetid://132488862841895", ["rat"] = "rbxassetid://127400975953159", ["ratio"] = "rbxassetid://126369423897295", ["receipt"] = "rbxassetid://77877895901792", ["receipt-cent"] = "rbxassetid://91557573925201", ["receipt-euro"] = "rbxassetid://94015722210295", ["receipt-indian-rupee"] = "rbxassetid://89718170439990", ["receipt-japanese-yen"] = "rbxassetid://132472560758851", ["receipt-pound-sterling"] = "rbxassetid://73934967569625", ["receipt-russian-ruble"] = "rbxassetid://105164576936853", ["receipt-swiss-franc"] = "rbxassetid://72503668620116", ["receipt-text"] = "rbxassetid://138483536013737", ["receipt-turkish-lira"] = "rbxassetid://91950765836342", ["rectangle-circle"] = "rbxassetid://100642423153903", ["rectangle-ellipsis"] = "rbxassetid://112919953980965", ["rectangle-goggles"] = "rbxassetid://98605436666727", ["rectangle-horizontal"] = "rbxassetid://90224199814966", ["rectangle-vertical"] = "rbxassetid://117277050590967", ["recycle"] = "rbxassetid://140417023381961", ["redo"] = "rbxassetid://116150342119054", ["redo-2"] = "rbxassetid://70451039017914", ["redo-dot"] = "rbxassetid://94252981719732", ["refresh-ccw"] = "rbxassetid://117913330389477", ["refresh-ccw-dot"] = "rbxassetid://106702246753270", ["refresh-cw"] = "rbxassetid://138133190015277", ["refresh-cw-off"] = "rbxassetid://140179498843054", ["refrigerator"] = "rbxassetid://102614042652753", ["regex"] = "rbxassetid://100727200791841", ["remove-formatting"] = "rbxassetid://112833162022628", ["repeat"] = "rbxassetid://121886242955173", ["repeat-1"] = "rbxassetid://130144534857095", ["repeat-2"] = "rbxassetid://85927537182704", ["replace"] = "rbxassetid://128404082279430", ["replace-all"] = "rbxassetid://127862728198635", ["reply"] = "rbxassetid://109788633497028", ["reply-all"] = "rbxassetid://71723137343562", ["rewind"] = "rbxassetid://95205297521988", ["ribbon"] = "rbxassetid://94265331526851", ["rocket"] = "rbxassetid://87412317685854", ["rocking-chair"] = "rbxassetid://110420269495360", ["roller-coaster"] = "rbxassetid://112426178972099", ["rose"] = "rbxassetid://126336840238769", ["rotate-3d"] = "rbxassetid://76300551576392", ["rotate-ccw"] = "rbxassetid://110116685948665", ["rotate-ccw-key"] = "rbxassetid://74976035240976", ["rotate-ccw-square"] = "rbxassetid://90515853170424", ["rotate-cw"] = "rbxassetid://84183336178654", ["rotate-cw-square"] = "rbxassetid://77095448159303", ["route"] = "rbxassetid://89968303228953", ["route-off"] = "rbxassetid://106350402024079", ["router"] = "rbxassetid://102130331994471", ["rows-2"] = "rbxassetid://112556185960101", ["rows-3"] = "rbxassetid://117215586961375", ["rows-4"] = "rbxassetid://125646021959055", ["rss"] = "rbxassetid://131789058984793", ["ruler"] = "rbxassetid://81432445547423", ["ruler-dimension-line"] = "rbxassetid://70673861371412", ["russian-ruble"] = "rbxassetid://126357936542156", ["sailboat"] = "rbxassetid://87110567187540", ["salad"] = "rbxassetid://128864507821603", ["sandwich"] = "rbxassetid://104573187458917", ["satellite"] = "rbxassetid://134967053164645", ["satellite-dish"] = "rbxassetid://136742443888305", ["saudi-riyal"] = "rbxassetid://102282769104635", ["save"] = "rbxassetid://126116963775616", ["save-all"] = "rbxassetid://116946975799440", ["save-off"] = "rbxassetid://87085435778560", ["scale"] = "rbxassetid://108203682317477", ["scale-3d"] = "rbxassetid://72414199620352", ["scaling"] = "rbxassetid://122360365318466", ["scan"] = "rbxassetid://123104789658180", ["scan-barcode"] = "rbxassetid://96889457154761", ["scan-eye"] = "rbxassetid://99244790601968", ["scan-face"] = "rbxassetid://109959345069668", ["scan-heart"] = "rbxassetid://106280819776142", ["scan-line"] = "rbxassetid://126544908146540", ["scan-qr-code"] = "rbxassetid://105409149549927", ["scan-search"] = "rbxassetid://80009010551347", ["scan-text"] = "rbxassetid://73702396787766", ["school"] = "rbxassetid://76351530290068", ["scissors"] = "rbxassetid://118665510911274", ["scissors-line-dashed"] = "rbxassetid://122237447974173", ["screen-share"] = "rbxassetid://85137895705653", ["screen-share-off"] = "rbxassetid://107677572669805", ["scroll"] = "rbxassetid://74072101474951", ["scroll-text"] = "rbxassetid://97321022666868", ["search"] = "rbxassetid://121018724060431", ["search-check"] = "rbxassetid://75442076191356", ["search-code"] = "rbxassetid://117114794592802", ["search-slash"] = "rbxassetid://96483932261041", ["search-x"] = "rbxassetid://137319957522951", ["section"] = "rbxassetid://91732188298948", ["send"] = "rbxassetid://127751956873796", ["send-horizontal"] = "rbxassetid://111734392411664", ["send-to-back"] = "rbxassetid://75340312862253", ["separator-horizontal"] = "rbxassetid://84864453699927", ["separator-vertical"] = "rbxassetid://84031801478581", ["server"] = "rbxassetid://92188766517878", ["server-cog"] = "rbxassetid://138470287250966", ["server-crash"] = "rbxassetid://132810618000212", ["server-off"] = "rbxassetid://114048751507723", ["settings"] = "rbxassetid://80758916183665", ["settings-2"] = "rbxassetid://135684703553372", ["shapes"] = "rbxassetid://129989433311409", ["share"] = "rbxassetid://87340985053299", ["share-2"] = "rbxassetid://71210767962065", ["sheet"] = "rbxassetid://134902122480171", ["shell"] = "rbxassetid://140212943563599", ["shield"] = "rbxassetid://110987169760162", ["shield-alert"] = "rbxassetid://114995877719925", ["shield-ban"] = "rbxassetid://108765041044649", ["shield-check"] = "rbxassetid://87354736164608", ["shield-ellipsis"] = "rbxassetid://114794739892123", ["shield-half"] = "rbxassetid://117842634172647", ["shield-minus"] = "rbxassetid://89965059528921", ["shield-off"] = "rbxassetid://133426959132690", ["shield-plus"] = "rbxassetid://100664857995498", ["shield-question-mark"] = "rbxassetid://135722075265150", ["shield-user"] = "rbxassetid://124832775645347", ["shield-x"] = "rbxassetid://73370117343811", ["ship"] = "rbxassetid://83995100553930", ["ship-wheel"] = "rbxassetid://130797795829448", ["shirt"] = "rbxassetid://106579555405966", ["shopping-bag"] = "rbxassetid://71885477293226", ["shopping-basket"] = "rbxassetid://138646411956433", ["shopping-cart"] = "rbxassetid://128420521375441", ["shovel"] = "rbxassetid://102465000512056", ["shower-head"] = "rbxassetid://75884944024117", ["shredder"] = "rbxassetid://122125164414463", ["shrimp"] = "rbxassetid://102625900815307", ["shrink"] = "rbxassetid://90953687918880", ["shrub"] = "rbxassetid://127326280714343", ["shuffle"] = "rbxassetid://132382786975101", ["sigma"] = "rbxassetid://126884244870899", ["signal"] = "rbxassetid://78424889355261", ["signal-high"] = "rbxassetid://130436670012270", ["signal-low"] = "rbxassetid://73674683500458", ["signal-medium"] = "rbxassetid://125003021367019", ["signal-zero"] = "rbxassetid://130045332414754", ["signature"] = "rbxassetid://114402748013000", ["signpost"] = "rbxassetid://106584743791433", ["signpost-big"] = "rbxassetid://115780185675001", ["siren"] = "rbxassetid://134210267818039", ["skip-back"] = "rbxassetid://70466132711334", ["skip-forward"] = "rbxassetid://124844823753990", ["skull"] = "rbxassetid://137726256442333", ["slack"] = "rbxassetid://96089719516736", ["slash"] = "rbxassetid://117792185664263", ["slice"] = "rbxassetid://95810504278179", ["sliders-horizontal"] = "rbxassetid://85538382643347", ["sliders-vertical"] = "rbxassetid://101190569086853", ["smartphone"] = "rbxassetid://96623008834511", ["smartphone-charging"] = "rbxassetid://102837532613995", ["smartphone-nfc"] = "rbxassetid://82326425754446", ["smile"] = "rbxassetid://105880397565283", ["smile-plus"] = "rbxassetid://131981881472144", ["snail"] = "rbxassetid://70904536548363", ["snowflake"] = "rbxassetid://101235206534566", ["soap-dispenser-droplet"] = "rbxassetid://77258480479465", ["sofa"] = "rbxassetid://114427687218324", ["solar-panel"] = "rbxassetid://132448188047921", ["soup"] = "rbxassetid://115092551871618", ["space"] = "rbxassetid://87072088914178", ["spade"] = "rbxassetid://131444449466462", ["sparkle"] = "rbxassetid://111044800239623", ["sparkles"] = "rbxassetid://138635884129147", ["speaker"] = "rbxassetid://96227183003618", ["speech"] = "rbxassetid://87013139446349", ["spell-check"] = "rbxassetid://91913483031334", ["spell-check-2"] = "rbxassetid://81556731785534", ["spline"] = "rbxassetid://129406685807412", ["spline-pointer"] = "rbxassetid://84842840956804", ["split"] = "rbxassetid://105112438805988", ["spool"] = "rbxassetid://124541981347743", ["spotlight"] = "rbxassetid://77571742539344", ["spray-can"] = "rbxassetid://128372039366326", ["sprout"] = "rbxassetid://100091687832508", ["square"] = "rbxassetid://86304921356806", ["square-activity"] = "rbxassetid://89496630185293", ["square-arrow-down"] = "rbxassetid://135962519626588", ["square-arrow-down-left"] = "rbxassetid://108194680296901", ["square-arrow-down-right"] = "rbxassetid://99403846801050", ["square-arrow-left"] = "rbxassetid://111671474549238", ["square-arrow-out-down-left"] = "rbxassetid://125714881756353", ["square-arrow-out-down-right"] = "rbxassetid://89971003001390", ["square-arrow-out-up-left"] = "rbxassetid://103759986579087", ["square-arrow-out-up-right"] = "rbxassetid://91221896066807", ["square-arrow-right"] = "rbxassetid://113920471701361", ["square-arrow-up"] = "rbxassetid://106998604646718", ["square-arrow-up-left"] = "rbxassetid://112424670290693", ["square-arrow-up-right"] = "rbxassetid://76602291406940", ["square-asterisk"] = "rbxassetid://89186832353625", ["square-bottom-dashed-scissors"] = "rbxassetid://79076980104803", ["square-chart-gantt"] = "rbxassetid://104034017316411", ["square-check"] = "rbxassetid://134682053539509", ["square-check-big"] = "rbxassetid://115320390907184", ["square-chevron-down"] = "rbxassetid://91032307924592", ["square-chevron-left"] = "rbxassetid://73143404829510", ["square-chevron-right"] = "rbxassetid://90612077729930", ["square-chevron-up"] = "rbxassetid://85565910197337", ["square-code"] = "rbxassetid://81604576616881", ["square-dashed"] = "rbxassetid://136905537847606", ["square-dashed-bottom"] = "rbxassetid://101102319625624", ["square-dashed-bottom-code"] = "rbxassetid://100354801563230", ["square-dashed-kanban"] = "rbxassetid://90388067649847", ["square-dashed-mouse-pointer"] = "rbxassetid://121016142178467", ["square-dashed-top-solid"] = "rbxassetid://117157577548540", ["square-divide"] = "rbxassetid://99894657101970", ["square-dot"] = "rbxassetid://116613421354866", ["square-equal"] = "rbxassetid://110283363706707", ["square-function"] = "rbxassetid://86075219551088", ["square-kanban"] = "rbxassetid://114537101260131", ["square-library"] = "rbxassetid://73810931222081", ["square-m"] = "rbxassetid://117662700410577", ["square-menu"] = "rbxassetid://104067089444415", ["square-minus"] = "rbxassetid://116764432015770", ["square-mouse-pointer"] = "rbxassetid://76141850603920", ["square-parking"] = "rbxassetid://133116656122387", ["square-parking-off"] = "rbxassetid://100857293535141", ["square-pause"] = "rbxassetid://86608552787615", ["square-pen"] = "rbxassetid://120239476110475", ["square-percent"] = "rbxassetid://87111930314567", ["square-pi"] = "rbxassetid://75383328781618", ["square-pilcrow"] = "rbxassetid://131854284699367", ["square-play"] = "rbxassetid://108186325238481", ["square-plus"] = "rbxassetid://114713264461873", ["square-power"] = "rbxassetid://129240437805187", ["square-radical"] = "rbxassetid://132645931868292", ["square-round-corner"] = "rbxassetid://104592745113567", ["square-scissors"] = "rbxassetid://110601255612411", ["square-sigma"] = "rbxassetid://113231244246816", ["square-slash"] = "rbxassetid://105477013908757", ["square-split-horizontal"] = "rbxassetid://76095370148660", ["square-split-vertical"] = "rbxassetid://88589192032058", ["square-square"] = "rbxassetid://136555087357875", ["square-stack"] = "rbxassetid://100463396619394", ["square-star"] = "rbxassetid://94506958703720", ["square-stop"] = "rbxassetid://80018708472943", ["square-terminal"] = "rbxassetid://83969264476798", ["square-user"] = "rbxassetid://70771214183445", ["square-user-round"] = "rbxassetid://86484997229302", ["square-x"] = "rbxassetid://125136183850190", ["squares-exclude"] = "rbxassetid://102345385822324", ["squares-intersect"] = "rbxassetid://120869602570119", ["squares-subtract"] = "rbxassetid://131484650948795", ["squares-unite"] = "rbxassetid://96673080107843", ["squircle"] = "rbxassetid://82426632573807", ["squircle-dashed"] = "rbxassetid://129936702532522", ["squirrel"] = "rbxassetid://112864252085343", ["stamp"] = "rbxassetid://92370779813368", ["star"] = "rbxassetid://136141469398409", ["star-half"] = "rbxassetid://117449275562979", ["star-off"] = "rbxassetid://75742832732503", ["step-back"] = "rbxassetid://108672750005121", ["step-forward"] = "rbxassetid://126131872136145", ["stethoscope"] = "rbxassetid://122331031702148", ["sticker"] = "rbxassetid://79938203791608", ["sticky-note"] = "rbxassetid://111894074643919", ["store"] = "rbxassetid://90338129673705", ["stretch-horizontal"] = "rbxassetid://87665042192343", ["stretch-vertical"] = "rbxassetid://95265463417122", ["strikethrough"] = "rbxassetid://103417324549613", ["subscript"] = "rbxassetid://74553514785183", ["sun"] = "rbxassetid://110150589884127", ["sun-dim"] = "rbxassetid://129141645592715", ["sun-medium"] = "rbxassetid://130278807964710", ["sun-moon"] = "rbxassetid://75752898854559", ["sun-snow"] = "rbxassetid://112791898014579", ["sunrise"] = "rbxassetid://134705665494098", ["sunset"] = "rbxassetid://75904872203588", ["superscript"] = "rbxassetid://96887696590118", ["swatch-book"] = "rbxassetid://126786244872453", ["swiss-franc"] = "rbxassetid://113497920041625", ["switch-camera"] = "rbxassetid://76841154349737", ["sword"] = "rbxassetid://124448418211665", ["swords"] = "rbxassetid://81872698913435", ["syringe"] = "rbxassetid://123891270479254", ["table"] = "rbxassetid://109109148250737", ["table-2"] = "rbxassetid://95751552281545", ["table-cells-merge"] = "rbxassetid://95363715175258", ["table-cells-split"] = "rbxassetid://114799086088649", ["table-columns-split"] = "rbxassetid://111011625447949", ["table-of-contents"] = "rbxassetid://135044763275414", ["table-properties"] = "rbxassetid://125062886015372", ["table-rows-split"] = "rbxassetid://96443733673997", ["tablet"] = "rbxassetid://128403991264386", ["tablet-smartphone"] = "rbxassetid://133680859813404", ["tablets"] = "rbxassetid://80835787970735", ["tag"] = "rbxassetid://129104970103940", ["tags"] = "rbxassetid://107179263080798", ["tally-1"] = "rbxassetid://115301298241643", ["tally-2"] = "rbxassetid://110363186864027", ["tally-3"] = "rbxassetid://97655344572540", ["tally-4"] = "rbxassetid://102633494371890", ["tally-5"] = "rbxassetid://88031817475886", ["tangent"] = "rbxassetid://123263132981724", ["target"] = "rbxassetid://87563802520297", ["telescope"] = "rbxassetid://91755049143647", ["tent"] = "rbxassetid://109779587826330", ["tent-tree"] = "rbxassetid://76698322463977", ["terminal"] = "rbxassetid://106783148545356", ["test-tube"] = "rbxassetid://98801015650164", ["test-tube-diagonal"] = "rbxassetid://75662704378840", ["test-tubes"] = "rbxassetid://92555361447433", ["text-align-center"] = "rbxassetid://84051028246390", ["text-align-end"] = "rbxassetid://130041738343555", ["text-align-justify"] = "rbxassetid://80279880143030", ["text-align-start"] = "rbxassetid://134489585487649", ["text-cursor"] = "rbxassetid://115984654447300", ["text-cursor-input"] = "rbxassetid://107551944047171", ["text-initial"] = "rbxassetid://129458097472087", ["text-quote"] = "rbxassetid://139278366448736", ["text-search"] = "rbxassetid://92345384671606", ["text-select"] = "rbxassetid://117087320884956", ["text-wrap"] = "rbxassetid://114804318314018", ["theater"] = "rbxassetid://108558145549163", ["thermometer"] = "rbxassetid://106546011492311", ["thermometer-snowflake"] = "rbxassetid://121876188028425", ["thermometer-sun"] = "rbxassetid://106693240074310", ["thumbs-down"] = "rbxassetid://87794009914015", ["thumbs-up"] = "rbxassetid://111137070767020", ["ticket"] = "rbxassetid://126527071492145", ["ticket-check"] = "rbxassetid://105428777212507", ["ticket-minus"] = "rbxassetid://78966299769328", ["ticket-percent"] = "rbxassetid://80834774406405", ["ticket-plus"] = "rbxassetid://110086734392189", ["ticket-slash"] = "rbxassetid://89045681172265", ["ticket-x"] = "rbxassetid://88674114109926", ["tickets"] = "rbxassetid://135268612687833", ["tickets-plane"] = "rbxassetid://100367018248695", ["timer"] = "rbxassetid://85473888890506", ["timer-off"] = "rbxassetid://110916370767271", ["timer-reset"] = "rbxassetid://110052125369932", ["toggle-left"] = "rbxassetid://85887872573050", ["toggle-right"] = "rbxassetid://90411952142550", ["toilet"] = "rbxassetid://80930782432931", ["tool-case"] = "rbxassetid://87533537832522", ["tornado"] = "rbxassetid://88358291515768", ["torus"] = "rbxassetid://70855707283051", ["touchpad"] = "rbxassetid://74882354908014", ["touchpad-off"] = "rbxassetid://78784008075456", ["tower-control"] = "rbxassetid://95937619060532", ["toy-brick"] = "rbxassetid://86293483924633", ["tractor"] = "rbxassetid://103376704722051", ["traffic-cone"] = "rbxassetid://74110220470369", ["train-front"] = "rbxassetid://125237934215370", ["train-front-tunnel"] = "rbxassetid://105194827005114", ["train-track"] = "rbxassetid://77451032453723", ["tram-front"] = "rbxassetid://93315182364998", ["transgender"] = "rbxassetid://135530817673639", ["trash"] = "rbxassetid://106723740584310", ["trash-2"] = "rbxassetid://109843431391323", ["tree-deciduous"] = "rbxassetid://123124389219004", ["tree-palm"] = "rbxassetid://103846705893963", ["tree-pine"] = "rbxassetid://124662547202594", ["trees"] = "rbxassetid://121203841375919", ["trello"] = "rbxassetid://130987241149527", ["trending-down"] = "rbxassetid://139309232226438", ["trending-up"] = "rbxassetid://81819858538839", ["trending-up-down"] = "rbxassetid://85083293981691", ["triangle"] = "rbxassetid://126330486745540", ["triangle-alert"] = "rbxassetid://125920361880643", ["triangle-dashed"] = "rbxassetid://124324079103935", ["triangle-right"] = "rbxassetid://116930791412791", ["trophy"] = "rbxassetid://131545003268773", ["truck"] = "rbxassetid://86662707764771", ["truck-electric"] = "rbxassetid://111873446387359", ["turkish-lira"] = "rbxassetid://114589876174070", ["turntable"] = "rbxassetid://129870346487856", ["turtle"] = "rbxassetid://118295081560334", ["tv"] = "rbxassetid://135687724791776", ["tv-minimal"] = "rbxassetid://100382201729427", ["tv-minimal-play"] = "rbxassetid://99201833426972", ["twitch"] = "rbxassetid://71383308134888", ["twitter"] = "rbxassetid://88791703276842", ["type"] = "rbxassetid://133543553793564", ["type-outline"] = "rbxassetid://80108627791690", ["umbrella"] = "rbxassetid://127502210274589", ["umbrella-off"] = "rbxassetid://72395143739955", ["underline"] = "rbxassetid://123709229216544", ["undo"] = "rbxassetid://111258459077271", ["undo-2"] = "rbxassetid://113885292059932", ["undo-dot"] = "rbxassetid://132055277744844", ["unfold-horizontal"] = "rbxassetid://117128358526398", ["unfold-vertical"] = "rbxassetid://116593025265499", ["ungroup"] = "rbxassetid://106674800451003", ["university"] = "rbxassetid://84652528263642", ["unlink"] = "rbxassetid://139835795227752", ["unlink-2"] = "rbxassetid://128131898892572", ["unplug"] = "rbxassetid://90171381619874", ["upload"] = "rbxassetid://138212042425501", ["usb"] = "rbxassetid://117230058949613", ["user"] = "rbxassetid://81589895647169", ["user-check"] = "rbxassetid://81775205032725", ["user-cog"] = "rbxassetid://92795491530865", ["user-lock"] = "rbxassetid://78892639693821", ["user-minus"] = "rbxassetid://126976941957511", ["user-pen"] = "rbxassetid://87445472574836", ["user-plus"] = "rbxassetid://118514469915884", ["user-round"] = "rbxassetid://136485052187963", ["user-round-check"] = "rbxassetid://118794737621941", ["user-round-cog"] = "rbxassetid://78239503290053", ["user-round-minus"] = "rbxassetid://98944176636447", ["user-round-pen"] = "rbxassetid://108155244324878", ["user-round-plus"] = "rbxassetid://113301899567470", ["user-round-search"] = "rbxassetid://71565774381870", ["user-round-x"] = "rbxassetid://122367980560930", ["user-search"] = "rbxassetid://101335649828115", ["user-star"] = "rbxassetid://98777846316000", ["user-x"] = "rbxassetid://139748155894754", ["users"] = "rbxassetid://115398113982385", ["users-round"] = "rbxassetid://103005444008339", ["utensils"] = "rbxassetid://139952569804235", ["utensils-crossed"] = "rbxassetid://109520762270383", ["utility-pole"] = "rbxassetid://101965541238242", ["variable"] = "rbxassetid://104743088438151", ["vault"] = "rbxassetid://108049164599845", ["vector-square"] = "rbxassetid://86713728565344", ["vegan"] = "rbxassetid://119489190688082", ["venetian-mask"] = "rbxassetid://102636443033920", ["venus"] = "rbxassetid://82891342220859", ["venus-and-mars"] = "rbxassetid://120227752103771", ["vibrate"] = "rbxassetid://108330910738733", ["vibrate-off"] = "rbxassetid://113446447326246", ["video"] = "rbxassetid://107587444636945", ["video-off"] = "rbxassetid://132239189859305", ["videotape"] = "rbxassetid://114816894323398", ["view"] = "rbxassetid://118717253976805", ["voicemail"] = "rbxassetid://134313454010227", ["volleyball"] = "rbxassetid://83889351124153", ["volume"] = "rbxassetid://103236289817396", ["volume-1"] = "rbxassetid://98514588731639", ["volume-2"] = "rbxassetid://89344380902620", ["volume-off"] = "rbxassetid://103047478058767", ["volume-x"] = "rbxassetid://139252359189540", ["vote"] = "rbxassetid://89409762851246", ["wallet"] = "rbxassetid://132331555762628", ["wallet-cards"] = "rbxassetid://129728715308337", ["wallet-minimal"] = "rbxassetid://137800448816116", ["wallpaper"] = "rbxassetid://74682121235494", ["wand"] = "rbxassetid://114580617777835", ["wand-sparkles"] = "rbxassetid://82546429942392", ["warehouse"] = "rbxassetid://78388887451080", ["washing-machine"] = "rbxassetid://104194127573858", ["watch"] = "rbxassetid://130544621618405", ["waves"] = "rbxassetid://96340135183647", ["waves-ladder"] = "rbxassetid://101808619355514", ["waypoints"] = "rbxassetid://102450133666017", ["webcam"] = "rbxassetid://104148487911129", ["webhook"] = "rbxassetid://112812457747322", ["webhook-off"] = "rbxassetid://96370548093471", ["weight"] = "rbxassetid://103860559844854", ["wheat"] = "rbxassetid://85261952080359", ["wheat-off"] = "rbxassetid://133294844612307", ["whole-word"] = "rbxassetid://90111083954485", ["wifi"] = "rbxassetid://104669375183960", ["wifi-cog"] = "rbxassetid://110500263326209", ["wifi-high"] = "rbxassetid://81954601342139", ["wifi-low"] = "rbxassetid://138217335635913", ["wifi-off"] = "rbxassetid://74113634330106", ["wifi-pen"] = "rbxassetid://91290205064712", ["wifi-sync"] = "rbxassetid://84043971055177", ["wifi-zero"] = "rbxassetid://124286465246123", ["wind"] = "rbxassetid://114551690399915", ["wind-arrow-down"] = "rbxassetid://127753987414870", ["wine"] = "rbxassetid://115743721332829", ["wine-off"] = "rbxassetid://108294164302317", ["workflow"] = "rbxassetid://99186544029189", ["worm"] = "rbxassetid://115752311548091", ["wrench"] = "rbxassetid://112148279212860", ["x"] = "rbxassetid://110786993356448", ["youtube"] = "rbxassetid://123663668456341", ["zap"] = "rbxassetid://130551565616516", ["zap-off"] = "rbxassetid://81385483183652", ["zoom-in"] = "rbxassetid://127956924984803", ["zoom-out"] = "rbxassetid://108334162607319"}

local function resolveIcon(iconValue, fallbackKey)
    if type(iconValue) ~= "string" or iconValue == "" then
        return iconMap[fallbackKey] or iconMap["code"]
    end
    if iconValue:match("^rbxassetid://") or iconValue:match("^rbxasset://") or iconValue:match("^http") then
        return iconValue
    end
    return iconMap[iconValue] or iconMap[fallbackKey] or iconMap["code"]
end

local themes = {
    dark = {
        MainBG = Color3.fromRGB(24, 24, 26),
        HeaderBG = Color3.fromRGB(15, 15, 15),
        Stroke = Color3.fromRGB(55, 55, 60),
        ButtonBG = Color3.fromRGB(36, 36, 40),
        SectionBG = Color3.fromRGB(30, 30, 33),
        Accent = Color3.fromRGB(140, 140, 140),
        IconCl = Color3.fromRGB(200, 200, 200)
    },
    neon = {
        MainBG = Color3.fromRGB(15, 12, 22),
        HeaderBG = Color3.fromRGB(8, 6, 12),
        Stroke = Color3.fromRGB(0, 255, 204),
        ButtonBG = Color3.fromRGB(28, 22, 40),
        SectionBG = Color3.fromRGB(22, 17, 32),
        Accent = Color3.fromRGB(255, 0, 127),
        IconCl = Color3.fromRGB(0, 255, 204)
    },
    ocean = {
        MainBG = Color3.fromRGB(12, 22, 32),
        HeaderBG = Color3.fromRGB(6, 12, 18),
        Stroke = Color3.fromRGB(0, 150, 255),
        ButtonBG = Color3.fromRGB(20, 36, 52),
        SectionBG = Color3.fromRGB(16, 28, 42),
        Accent = Color3.fromRGB(0, 200, 255),
        IconCl = Color3.fromRGB(0, 200, 255)
    },
    crimson = {
        MainBG = Color3.fromRGB(24, 14, 14),
        HeaderBG = Color3.fromRGB(14, 6, 6),
        Stroke = Color3.fromRGB(180, 30, 30),
        ButtonBG = Color3.fromRGB(40, 20, 20),
        SectionBG = Color3.fromRGB(32, 16, 16),
        Accent = Color3.fromRGB(255, 50, 50),
        IconCl = Color3.fromRGB(255, 50, 50)
    },
    golden = {
        MainBG = Color3.fromRGB(24, 22, 18),
        HeaderBG = Color3.fromRGB(16, 14, 12),
        Stroke = Color3.fromRGB(40, 35, 30),
        ButtonBG = Color3.fromRGB(36, 30, 25),
        SectionBG = Color3.fromRGB(33, 28, 24),
        Accent = Color3.fromRGB(255, 215, 0),
        IconCl = Color3.fromRGB(255, 215, 0)
    },
    light = {
        MainBG = Color3.fromRGB(125, 125, 130),
        HeaderBG = Color3.fromRGB(95, 95, 100),
        Stroke = Color3.fromRGB(180, 180, 185),
        ButtonBG = Color3.fromRGB(145, 145, 150),
        SectionBG = Color3.fromRGB(110, 110, 115),
        Accent = Color3.fromRGB(245, 245, 245),
        IconCl = Color3.fromRGB(95, 95, 100)
    },
    fire = {
        MainBG = Color3.fromRGB(25, 10, 5),
        HeaderBG = Color3.fromRGB(15, 5, 2),
        Stroke = Color3.fromRGB(255, 69, 0),
        ButtonBG = Color3.fromRGB(45, 18, 10),
        SectionBG = Color3.fromRGB(35, 14, 8),
        Accent = Color3.fromRGB(255, 140, 0),
        IconCl = Color3.fromRGB(255, 140, 0)
    }
}

function library:CreateTheme(cfg)
    cfg = cfg or {}
    local name = cfg.name or cfg.Name or "custom"
    local themeData = {
        MainBG = cfg.MainBG or Color3.fromRGB(24, 24, 26),
        HeaderBG = cfg.HeaderBG or cfg.MainBG or Color3.fromRGB(15, 15, 15),
        Stroke = cfg.Stroke or Color3.fromRGB(55, 55, 60),
        ButtonBG = cfg.ButtonBG or Color3.fromRGB(36, 36, 40),
        SectionBG = cfg.SectionBG or Color3.fromRGB(30, 30, 33),
        Accent = cfg.Accent or Color3.fromRGB(140, 140, 140),
        IconCl = cfg.IconCl or Color3.fromRGB(200, 200, 200)
    }
    themes[name:lower()] = themeData
    themes[name] = themeData
    return themeData
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Fireui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 250, 1, -20)
NotifContainer.Position = UDim2.new(1, -260, 0, 10)
NotifContainer.BackgroundTransparency = 1

local notifLayout = Instance.new("UIListLayout", NotifContainer)
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.Padding = UDim.new(0, 8)

function library:Notification(notifOptions)
    notifOptions = notifOptions or {}
    local title = notifOptions.title or "Notification"
    local desc = notifOptions.desc or ""
    local duration = notifOptions.duration or 5
    local currentTheme = library.CurrentTheme or themes.dark

    local notifFrame = Instance.new("Frame", NotifContainer)
    notifFrame.Name = "Notif"
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.BackgroundColor3 = currentTheme.MainBG
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.AutomaticSize = Enum.AutomaticSize.Y

    local nCorner = Instance.new("UICorner", notifFrame)
    nCorner.CornerRadius = UDim.new(0, 8)

    local nStroke = Instance.new("UIStroke", notifFrame)
    nStroke.Color = currentTheme.Stroke
    nStroke.Thickness = 1.5
    nStroke.Transparency = 1

    local nPad = Instance.new("UIPadding", notifFrame)
    nPad.PaddingLeft = UDim.new(0, 10)
    nPad.PaddingRight = UDim.new(0, 10)
    nPad.PaddingTop = UDim.new(0, 8)
    nPad.PaddingBottom = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", notifFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1

    local descLabel = Instance.new("TextLabel", notifFrame)
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.TextTransparency = 1

    local function tween(obj, info, prop)
        return TweenService:Create(obj, info, prop)
    end

    local infoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tween(notifFrame, infoIn, {BackgroundTransparency = 0.1}):Play()
    tween(nStroke, infoIn, {Transparency = 0}):Play()
    tween(titleLabel, infoIn, {TextTransparency = 0}):Play()
    tween(descLabel, infoIn, {TextTransparency = 0}):Play()

    task.delay(duration, function()
        local infoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local t1 = tween(notifFrame, infoOut, {BackgroundTransparency = 1})
        tween(nStroke, infoOut, {Transparency = 1}):Play()
        tween(titleLabel, infoOut, {TextTransparency = 1}):Play()
        tween(descLabel, infoOut, {TextTransparency = 1}):Play()
        t1:Play()
        t1.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end)
end

function library:window(options)
    options = options or {}
    local windowTitle = options.title or "library ui"
    local windowDesc = options.desc or "Fireui v1.0"
    local windowIcon = resolveIcon(options.icon, "code")
    local bgTrans = options.transparent or 0
    local selectedTheme = options.theme or "dark"
    local currentTheme = themes[selectedTheme:lower()] or themes.dark
    library.CurrentTheme = currentTheme

    local CanAutoSave = options.CanAutoSave
    if CanAutoSave == nil then CanAutoSave = options.canAutoSave end
    if CanAutoSave == nil then CanAutoSave = false end
    local rawFileName = options.fileName or options.FileName or options.file or options.File or ""
    if CanAutoSave then
        if rawFileName == "" then rawFileName = (options.title or "Fireui") .. "_Config" end
        local fullPath = getFullPath(rawFileName)
        library._autoSavePath = fullPath
        library._autoSaveEnabled = true
        loadConfig(fullPath)
    else
        library._autoSaveEnabled = false
    end

    local autoshow = options.autoshow
    if autoshow == nil then autoshow = true end

    local addbacksound = options.addbacksound
    if addbacksound == nil then addbacksound = false end

    local soundPlayed = false
    local function playInitSound()
        if addbacksound and not soundPlayed then
            soundPlayed = true
            local s = Instance.new("Sound", game.SoundService)
            s.SoundId = "rbxassetid://126047015098640"
            s.Volume = 2
            s:Play()
        end
    end

    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.ToggleKey = Enum.KeyCode.G
    local totalTags = 0
    window._autoSavePath = library._autoSavePath
    window._canAutoSave = CanAutoSave

    function window:SetFileName(newName)
        local fixed = getFullPath(newName)
        self._autoSavePath = fixed
        library._autoSavePath = fixed
        if self._canAutoSave or library._autoSaveEnabled then loadConfig(fixed) end
        return fixed
    end
    function window:SaveConfig() return saveConfig(self._autoSavePath or library._autoSavePath) end
    function window:LoadConfig() return loadConfig(self._autoSavePath or library._autoSavePath) end
    function window:SetAutoSave(state)
        self._canAutoSave = state and true or false
        library._autoSaveEnabled = self._canAutoSave
        if state and (self._autoSavePath == "" or not self._autoSavePath) then
            local f = getFullPath((options.title or "Fireui").."_Config")
            self._autoSavePath = f
            library._autoSavePath = f
        end
    end
    function window:GetFlags() return library.Flags end
    function window:GetFlag(flag) return library.Flags[flag] end
    function window:SetFlag(flag, val) library.Flags[flag]=val if library._autoSaveEnabled then saveConfig(library._autoSavePath) end end
    function window:SetTransparency(val) MainUI.BackgroundTransparency = math.clamp(val,0,0.9) MainShadow.ImageTransparency = 0.35 + (val*0.3) end

    function window:SetToggleKey(key)
        window.ToggleKey = key
    end

    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "MainShadow"
    MainShadow.BackgroundTransparency = 1
    MainShadow.Image = "rbxassetid://6015897843"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.35
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    MainShadow.ZIndex = 0
    MainShadow.Parent = ScreenGui

    local MainUI = Instance.new("CanvasGroup")
    MainUI.Name = "MainUI"
    MainUI.Size = UDim2.new(0, 560, 0, 360)
    MainUI.AnchorPoint = Vector2.new(0.5, 0.5)
    MainUI.BackgroundColor3 = currentTheme.MainBG
    MainUI.BackgroundTransparency = bgTrans
    MainUI.BorderSizePixel = 0
    MainUI.ZIndex = 1
    MainUI.Parent = ScreenGui

    local function syncShadow()
        MainShadow.AnchorPoint = MainUI.AnchorPoint
        MainShadow.Position = MainUI.Position
        MainShadow.Size = UDim2.new(MainUI.Size.X.Scale, MainUI.Size.X.Offset + 60, MainUI.Size.Y.Scale, MainUI.Size.Y.Offset + 60)
        MainShadow.Visible = MainUI.Visible
    end

    syncShadow()
    MainUI:GetPropertyChangedSignal("Position"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("Size"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("Visible"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("AnchorPoint"):Connect(syncShadow)

    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.80
    UIScale.Parent = MainUI

    local ShadowScale = Instance.new("UIScale")
    ShadowScale.Scale = UIScale.Scale
    ShadowScale.Parent = MainShadow

    UIScale:GetPropertyChangedSignal("Scale"):Connect(function()
        ShadowScale.Scale = UIScale.Scale
    end)

    Instance.new("UICorner", MainUI).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainUI)
    MainStroke.Color = currentTheme.Stroke
    MainStroke.Thickness = 2.5

    local savedTogglePos = UDim2.new(0.05, 0, 0.1, 30)

    local ToggleUI = Instance.new("CanvasGroup")
    ToggleUI.Name = "ToggleUI"
    ToggleUI.Size = UDim2.new(0, 135, 0, 36)
    ToggleUI.BackgroundColor3 = currentTheme.MainBG
    ToggleUI.BackgroundTransparency = bgTrans
    ToggleUI.BorderSizePixel = 0
    ToggleUI.Parent = ScreenGui

    Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 8)
    local ToggleStroke = Instance.new("UIStroke", ToggleUI)
    ToggleStroke.Color = currentTheme.Stroke
    ToggleStroke.Thickness = 2

    local function showMainUI()
        MainUI.Visible = true
        ToggleUI.Visible = true
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.6, 0), GroupTransparency = 0}):Play()
        local t = TweenService:Create(ToggleUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset), GroupTransparency = 1})
        t:Play()
        t.Completed:Connect(function()
            if MainUI.GroupTransparency == 0 then
                ToggleUI.Visible = false
            end
        end)
        playInitSound()
    end

    local function hideMainUI()
        MainUI.Visible = true
        ToggleUI.Visible = true
        ToggleUI.Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset)
        TweenService:Create(ToggleUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = savedTogglePos, GroupTransparency = 0}):Play()
        local t = TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 1.5, 0), GroupTransparency = 1})
        t:Play()
        t.Completed:Connect(function()
            if ToggleUI.GroupTransparency == 0 then
                MainUI.Visible = false
            end
        end)
    end

    if autoshow then
        MainUI.Visible = true
        MainUI.Position = UDim2.new(0.5, 0, 0.6, 0)
        MainUI.GroupTransparency = 0
        ToggleUI.Visible = false
        ToggleUI.Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset)
        ToggleUI.GroupTransparency = 1
        playInitSound()
    else
        MainUI.Visible = false
        MainUI.Position = UDim2.new(0.5, 0, 1.5, 0)
        MainUI.GroupTransparency = 1
        ToggleUI.Visible = true
        ToggleUI.Position = savedTogglePos
        ToggleUI.GroupTransparency = 0
    end

    local Header = Instance.new("Frame", MainUI)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = currentTheme.HeaderBG
    Header.BackgroundTransparency = bgTrans
    Header.BorderSizePixel = 0
    Header.ClipsDescendants = true

    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Fix = Instance.new("Frame", Header)
    Fix.Size = UDim2.new(1, 0, 0, 12)
    Fix.Position = UDim2.new(0, 0, 1, -12)
    Fix.BackgroundColor3 = currentTheme.HeaderBG
    Fix.BackgroundTransparency = bgTrans
    Fix.BorderSizePixel = 0

    local headerIcon = Instance.new("ImageLabel", Header)
    headerIcon.Name = "HeaderIcon"
    headerIcon.Size = UDim2.new(0, 30, 0, 30)
    headerIcon.Position = UDim2.new(0, 10, 0.5, -15)
    headerIcon.BackgroundColor3 = currentTheme.SectionBG
    headerIcon.BackgroundTransparency = bgTrans
    headerIcon.Image = windowIcon
    headerIcon.ImageColor3 = currentTheme.IconCl
    headerIcon.BorderSizePixel = 0
    Instance.new("UICorner", headerIcon).CornerRadius = UDim.new(0, 8)

    local headerTitle = Instance.new("TextLabel", Header)
    headerTitle.Name = "HeaderTitle"
    headerTitle.Size = UDim2.new(0, 106, 0, 18)
    headerTitle.Position = UDim2.new(0, 48, 0, 8)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = windowTitle
    headerTitle.TextColor3 = Color3.new(1, 1, 1)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 13
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ClipsDescendants = false
    headerTitle.TextScaled = true

    local headerTitleConstraint = Instance.new("UITextSizeConstraint", headerTitle)
    headerTitleConstraint.MaxTextSize = 13

    local headerDesc = Instance.new("TextLabel", Header)
    headerDesc.Name = "HeaderDesc"
    headerDesc.Size = UDim2.new(0, 106, 0, 14)
    headerDesc.Position = UDim2.new(0, 48, 0, 27)
    headerDesc.BackgroundTransparency = 1
    headerDesc.Text = windowDesc
    headerDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    headerDesc.Font = Enum.Font.Gotham
    headerDesc.TextSize = 11
    headerDesc.TextXAlignment = Enum.TextXAlignment.Left
    headerDesc.ClipsDescendants = false
    headerDesc.TextScaled = true

    local headerDescConstraint = Instance.new("UITextSizeConstraint", headerDesc)
    headerDescConstraint.MaxTextSize = 11

    local tabLabel = Instance.new("TextLabel", Header)
    tabLabel.Name = "ActiveTabLabel"
    tabLabel.Size = UDim2.new(0, 100, 0, 32)
    tabLabel.Position = UDim2.new(0, 170, 0.5, -16)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = ""
    tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 15
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ClipsDescendants = false
    tabLabel.TextScaled = true

    local tabLabelConstraint = Instance.new("UITextSizeConstraint", tabLabel)
    tabLabelConstraint.MaxTextSize = 15

    local VLine = Instance.new("Frame", Header)
    VLine.Name = "ProfileLine"
    VLine.Size = UDim2.new(0, 1, 0, 32)
    VLine.Position = UDim2.new(0, 160, 0.5, -16)
    VLine.BackgroundColor3 = currentTheme.Stroke
    VLine.BorderSizePixel = 0
    VLine.ZIndex = 5

    local headerStroke = Instance.new("Frame", Header)
    headerStroke.Name = "HeaderStroke"
    headerStroke.Size = UDim2.new(1, 0, 0, 1)
    headerStroke.Position = UDim2.new(0, 0, 1, -1)
    headerStroke.BackgroundColor3 = currentTheme.Stroke
    headerStroke.BorderSizePixel = 0
    headerStroke.ZIndex = 5

    local TagContainer = Instance.new("ScrollingFrame", Header)
    TagContainer.Name = "TagContainer"
    TagContainer.Size = UDim2.new(0, 155, 0, 24)
    TagContainer.Position = UDim2.new(0, 275, 0.5, -12)
    TagContainer.BackgroundTransparency = 1
    TagContainer.BorderSizePixel = 0
    TagContainer.ScrollBarThickness = 0
    TagContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TagContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    TagContainer.ScrollingDirection = Enum.ScrollingDirection.X
    TagContainer.ClipsDescendants = true

    local tagLayout = Instance.new("UIListLayout", TagContainer)
    tagLayout.FillDirection = Enum.FillDirection.Horizontal
    tagLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tagLayout.Padding = UDim.new(0, 6)
    tagLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local LeftTabBar = Instance.new("Frame", MainUI)
    LeftTabBar.Name = "LeftTabBar"
    LeftTabBar.Size = UDim2.new(0, 1, 1, -52)
    LeftTabBar.Position = UDim2.new(0, 84, 0, 52)
    LeftTabBar.BackgroundColor3 = currentTheme.Stroke
    LeftTabBar.BorderSizePixel = 0
    LeftTabBar.ZIndex = 5

    local Sidebar = Instance.new("Frame", MainUI)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 84, 1, -52)
    Sidebar.Position = UDim2.new(0, 0, 0, 52)
    Sidebar.BackgroundTransparency = 1

    local SidebarScroll = Instance.new("ScrollingFrame", Sidebar)
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.Position = UDim2.new(0, 0, 0, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local sidebarLayout = Instance.new("UIListLayout", SidebarScroll)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sidebarTopPad = Instance.new("UIPadding", SidebarScroll)
    sidebarTopPad.PaddingTop = UDim.new(0, 6)

    local function buatFadeLine(parent, sizeX)
        local line = Instance.new("Frame", parent)
        line.Size = UDim2.new(0, sizeX, 0, 3)
        line.BackgroundColor3 = currentTheme.Stroke
        line.BorderSizePixel = 0
        local corner = Instance.new("UICorner", line)
        corner.CornerRadius = UDim.new(1, 0)
        local gradient = Instance.new("UIGradient", line)
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.55)
        })
        return line
    end

    function window:AddDivider(title)
        local holder = Instance.new("Frame", SidebarScroll)
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, -12, 0, 14)

        if not title then
            local line = buatFadeLine(holder, 0)
            line.Size = UDim2.new(1, 0, 0, 3)
            line.Position = UDim2.new(0, 0, 0.5, -1)
            return
        end

        local layout = Instance.new("UIListLayout", holder)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 4)

        local leftLine = Instance.new("Frame", holder)
        leftLine.Size = UDim2.new(0.5, -4, 0, 3)
        leftLine.BackgroundColor3 = currentTheme.Stroke
        leftLine.BorderSizePixel = 0
        leftLine.LayoutOrder = 1
        Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
        local leftGradient = Instance.new("UIGradient", leftLine)
        leftGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 0)
        })

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(0, 0, 0, 12)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 8
        label.LayoutOrder = 2

        local rightLine = Instance.new("Frame", holder)
        rightLine.Size = UDim2.new(0.5, -4, 0, 3)
        rightLine.BackgroundColor3 = currentTheme.Stroke
        rightLine.BorderSizePixel = 0
        rightLine.LayoutOrder = 3
        Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
        local rightGradient = Instance.new("UIGradient", rightLine)
        rightGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.55)
        })
    end

    function window:AddTitle(tOptions)
        tOptions = tOptions or {}
        local text = type(tOptions) == "string" and tOptions or tOptions.Title or tOptions.title or tOptions.Text or tOptions.text or "Title"
        local titleSize = tOptions.Size or tOptions.size or 9
        local holder = Instance.new("Frame", SidebarScroll)
        holder.Name = "Title"
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.BackgroundTransparency = 1
        local pad = Instance.new("UIPadding", holder)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 4)
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1, 0, 0, 0)
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = titleSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        return holder
    end

    local ContentHolder = Instance.new("Frame", MainUI)
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -85, 1, -52)
    ContentHolder.Position = UDim2.new(0, 85, 0, 52)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true

    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local resizeBtn = Instance.new("TextButton", MainUI)
    resizeBtn.Name = "ResizeButton"
    resizeBtn.Size = UDim2.new(0, 25, 0, 25)
    resizeBtn.Position = UDim2.new(1, 0, 1, 0)
    resizeBtn.AnchorPoint = Vector2.new(1, 1)
    resizeBtn.BackgroundTransparency = 1
    resizeBtn.Text = ""
    resizeBtn.ZIndex = 15

    local resizing, resizeStart, startScale
    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startScale = UIScale.Scale
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newScale = math.clamp(startScale + (delta.X / 350), 0.50, 2.50)
            UIScale.Scale = newScale
        end
    end)

    local dragIcon = Instance.new("ImageButton", ToggleUI)
    dragIcon.Name = "DragIcon"
    dragIcon.Size = UDim2.new(0, 18, 0, 18)
    dragIcon.Position = UDim2.new(0, 8, 0.5, -9)
    dragIcon.BackgroundTransparency = 1
    dragIcon.BorderSizePixel = 0
    dragIcon.Image = resolveIcon("move", "move")
    dragIcon.ImageColor3 = currentTheme.IconCl

    local toggleLine = Instance.new("Frame", ToggleUI)
    toggleLine.Name = "ToggleLine"
    toggleLine.Size = UDim2.new(0, 1, 0, 18)
    toggleLine.Position = UDim2.new(0, 30, 0.5, -9)
    toggleLine.BackgroundColor3 = currentTheme.Stroke
    toggleLine.BorderSizePixel = 0
    toggleLine.Visible = true

    local toggleLabel = Instance.new("TextLabel", ToggleUI)
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(1, -38, 1, 0)
    toggleLabel.Position = UDim2.new(0, 38, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Open UI"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 13
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Visible = true

    ToggleUI.Size = UDim2.new(0, 135, 0, 36)
    Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 8)

    local toggleClick = Instance.new("TextButton", ToggleUI)
    toggleClick.Name = "ToggleClick"
    toggleClick.Size = UDim2.new(1, -38, 1, 0)
    toggleClick.Position = UDim2.new(0, 38, 0, 0)
    toggleClick.BackgroundTransparency = 1
    toggleClick.Text = ""

    toggleClick.MouseButton1Click:Connect(showMainUI)

    local tDragging, tDragInput, tDragStart, tStartPos
    dragIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tDragging = true
            tDragStart = input.Position
            tStartPos = ToggleUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    tDragging = false
                end
            end)
        end
    end)

    dragIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            tDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == tDragInput and tDragging then
            local delta = input.Position - tDragStart
            local newPos = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
            ToggleUI.Position = newPos
            savedTogglePos = newPos
        end
    end)

    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == window.ToggleKey then
            if MainUI.Visible and MainUI.GroupTransparency < 0.5 then
                hideMainUI()
            else
                showMainUI()
            end
        end
    end)

    local DestroyDialog = Instance.new("Frame")
    DestroyDialog.Name = "DestroyDialog"
    DestroyDialog.Size = UDim2.new(0, 260, 0, 120)
    DestroyDialog.AnchorPoint = Vector2.new(0.5, 0.5)
    DestroyDialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    DestroyDialog.BackgroundColor3 = currentTheme.SectionBG
    DestroyDialog.BackgroundTransparency = bgTrans
    DestroyDialog.BorderSizePixel = 0
    DestroyDialog.Visible = false
    DestroyDialog.ZIndex = 20
    DestroyDialog.Parent = MainUI

    Instance.new("UICorner", DestroyDialog).CornerRadius = UDim.new(0, 10)
    local dialogStroke = Instance.new("UIStroke", DestroyDialog)
    dialogStroke.Color = currentTheme.Stroke
    dialogStroke.Thickness = 2

    local dialogText = Instance.new("TextLabel", DestroyDialog)
    dialogText.Size = UDim2.new(1, -20, 0, 40)
    dialogText.Position = UDim2.new(0, 10, 0, 15)
    dialogText.BackgroundTransparency = 1
    dialogText.Text = "Destroy UI Library?"
    dialogText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogText.Font = Enum.Font.GothamBold
    dialogText.TextSize = 14
    dialogText.ZIndex = 21

    local yesBtn = Instance.new("TextButton", DestroyDialog)
    yesBtn.Size = UDim2.new(0.4, 0, 0, 32)
    yesBtn.Position = UDim2.new(0.08, 0, 1, -45)
    yesBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.Font = Enum.Font.GothamMedium
    yesBtn.TextSize = 13
    yesBtn.ZIndex = 21
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)

    local noBtn = Instance.new("TextButton", DestroyDialog)
    noBtn.Size = UDim2.new(0.4, 0, 0, 32)
    noBtn.Position = UDim2.new(0.52, 0, 1, -45)
    noBtn.BackgroundColor3 = currentTheme.ButtonBG
    noBtn.BackgroundTransparency = bgTrans
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    noBtn.Font = Enum.Font.GothamMedium
    noBtn.TextSize = 13
    noBtn.ZIndex = 21
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)
    local noStroke = Instance.new("UIStroke", noBtn)
    noStroke.Color = currentTheme.Stroke
    noStroke.Thickness = 1

    function window:destroy()
        if addbacksound then
            local s = Instance.new("Sound", game.SoundService)
            s.SoundId = "rbxassetid://111617177185247"
            s.Volume = 2
            s:Play()
        end
        local t1 = TweenService:Create(MainUI, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
        t1:Play()
        t1.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end

    yesBtn.MouseButton1Click:Connect(function()
        window:destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        DestroyDialog.Visible = false
    end)

    local redBtn = Instance.new("TextButton", Header)
    redBtn.Name = "DestroyButton"
    redBtn.Size = UDim2.new(0, 16, 0, 16)
    redBtn.Position = UDim2.new(1, -24, 0.5, -8)
    redBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    redBtn.Text = ""
    redBtn.ZIndex = 7
    Instance.new("UICorner", redBtn).CornerRadius = UDim.new(1, 0)

    local yellowBtn = Instance.new("TextButton", Header)
    yellowBtn.Name = "ToggleButton"
    yellowBtn.Size = UDim2.new(0, 16, 0, 16)
    yellowBtn.Position = UDim2.new(1, -46, 0.5, -8)
    yellowBtn.BackgroundColor3 = Color3.fromRGB(220, 180, 20)
    yellowBtn.Text = ""
    yellowBtn.ZIndex = 7
    Instance.new("UICorner", yellowBtn).CornerRadius = UDim.new(1, 0)

    yellowBtn.MouseButton1Click:Connect(hideMainUI)

    redBtn.MouseButton1Click:Connect(function()
        DestroyDialog.Visible = true
    end)

    local function buatButton(nama, iconValue)
        local btn = Instance.new("ImageButton")
        btn.Name = nama
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.BackgroundColor3 = currentTheme.ButtonBG
        btn.BackgroundTransparency = bgTrans
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        btn.Parent = SidebarScroll

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = currentTheme.Stroke
        stroke.Thickness = 1

        local iconImg = Instance.new("ImageLabel", btn)
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 26, 0, 26)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = resolveIcon(iconValue, "code")
        iconImg.ImageColor3 = currentTheme.IconCl
        iconImg.ZIndex = 6

        return btn, iconImg
    end

    function window:AddTag(tagOptions)
        tagOptions = tagOptions or {}
        local tagTitle = tagOptions.title or "Tag"
        local tagColor = tagOptions.color or Color3.fromRGB(40, 40, 40)
        local canClick = tagOptions.getclick or false
        local callback = tagOptions.callback or function() end
        local tagIcon = tagOptions.icon

        totalTags = totalTags + 1

        local tagBtn = Instance.new("TextButton", TagContainer)
        tagBtn.Name = tagTitle .. "Tag"
        tagBtn.Size = UDim2.new(0, 0, 0, 22)
        tagBtn.AutomaticSize = Enum.AutomaticSize.X
        tagBtn.BackgroundColor3 = tagColor
        tagBtn.BackgroundTransparency = bgTrans
        tagBtn.Text = ""

        local tagLayoutItem = Instance.new("UIListLayout", tagBtn)
        tagLayoutItem.FillDirection = Enum.FillDirection.Horizontal
        tagLayoutItem.SortOrder = Enum.SortOrder.LayoutOrder
        tagLayoutItem.Padding = UDim.new(0, 4)
        tagLayoutItem.VerticalAlignment = Enum.VerticalAlignment.Center

        local tagPadding = Instance.new("UIPadding", tagBtn)
        tagPadding.PaddingLeft = UDim.new(0, 8)
        tagPadding.PaddingRight = UDim.new(0, 8)

        local tagCorner = Instance.new("UICorner", tagBtn)
        tagCorner.CornerRadius = UDim.new(0, 6)

        local tagStroke = Instance.new("UIStroke", tagBtn)
        tagStroke.Color = currentTheme.Stroke
        tagStroke.Thickness = 1

        if tagIcon then
            local iconImg = Instance.new("ImageLabel", tagBtn)
            iconImg.Name = "TagIcon"
            iconImg.Size = UDim2.new(0, 12, 0, 12)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = resolveIcon(tagIcon, "code")
            iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            iconImg.LayoutOrder = 1
        end

        local textLabel = Instance.new("TextLabel", tagBtn)
        textLabel.Name = "TagText"
        textLabel.Size = UDim2.new(0, 0, 1, 0)
        textLabel.AutomaticSize = Enum.AutomaticSize.X
        textLabel.BackgroundTransparency = 1
        textLabel.Text = tagTitle
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.LayoutOrder = 2

        if canClick then
            tagBtn.MouseButton1Click:Connect(callback)
            tagBtn.AutoButtonColor = true
        else
            tagBtn.Active = false
            tagBtn.AutoButtonColor = false
        end

        return tagBtn
    end

    function window:togglegui(tglOptions)
        tglOptions = tglOptions or {}
        local tglTitle = tglOptions.title or windowTitle
        local tglIcon = resolveIcon(tglOptions.icon, "code")
        toggleLabel.Text = tglTitle
        dragIcon.Image = tglIcon
    end

    function window:SetToggleUi(cfg)
        cfg = cfg or {}
        local title = cfg.title or cfg.Title or windowTitle or "Open UI"
        local iconName = cfg.icon or cfg.Icon or "code"
        local iconResolved = resolveIcon(iconName, "code")
        local moveIcon = resolveIcon("move", "move")

        dragIcon.Image = moveIcon
        dragIcon.Size = UDim2.new(0, 18, 0, 18)
        dragIcon.Position = UDim2.new(0, 8, 0.5, -9)
        dragIcon.BackgroundTransparency = 1
        dragIcon.BorderSizePixel = 0
        for _, c in ipairs(dragIcon:GetChildren()) do
            if c:IsA("UIStroke") or c:IsA("UICorner") then
                c:Destroy()
            end
        end
        dragIcon.ImageColor3 = currentTheme.IconCl

        local apiIcon = ToggleUI:FindFirstChild("ApiIcon")
        if not apiIcon then
            apiIcon = Instance.new("ImageLabel", ToggleUI)
            apiIcon.Name = "ApiIcon"
            apiIcon.BackgroundTransparency = 1
            apiIcon.BorderSizePixel = 0
        end
        apiIcon.Size = UDim2.new(0, 18, 0, 18)
        apiIcon.Position = UDim2.new(0, 38, 0.5, -9)
        apiIcon.Image = iconResolved
        apiIcon.ImageColor3 = currentTheme.IconCl
        apiIcon.Visible = true
        for _, c in ipairs(apiIcon:GetChildren()) do
            if c:IsA("UIStroke") then c:Destroy() end
        end

        toggleLabel.Text = title
        toggleLabel.Position = UDim2.new(0, 62, 0, 0)
        toggleLabel.Size = UDim2.new(1, -68, 1, 0)
        toggleLabel.Visible = true

        ToggleUI.Size = UDim2.new(0, 135, 0, 36)
        for _, child in ipairs(ToggleUI:GetChildren()) do
            if child:IsA("UICorner") then
                child.CornerRadius = UDim.new(0, 8)
            end
        end

        toggleLine.Visible = true
        toggleLine.Position = UDim2.new(0, 30, 0.5, -9)
        toggleLine.Size = UDim2.new(0, 1, 0, 18)
    end

    local function buatElementMethods(containerFrame)
        local function addTitleFunc(tOptions)
            tOptions = tOptions or {}
            local text = type(tOptions) == "string" and tOptions or tOptions.Title or tOptions.title or tOptions.Text or tOptions.text or "Title"
            local titleSize = tOptions.Size or tOptions.size or 14
            local titleFrame = Instance.new("Frame", containerFrame)
            titleFrame.Name = "Title"
            titleFrame.Size = UDim2.new(1, 0, 0, 0)
            titleFrame.AutomaticSize = Enum.AutomaticSize.Y
            titleFrame.BackgroundTransparency = 1
            local pad = Instance.new("UIPadding", titleFrame)
            pad.PaddingLeft = UDim.new(0, 2)
            pad.PaddingTop = UDim.new(0, 4)
            pad.PaddingBottom = UDim.new(0, 2)
            local label = Instance.new("TextLabel", titleFrame)
            label.Size = UDim2.new(1, 0, 0, 0)
            label.AutomaticSize = Enum.AutomaticSize.Y
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = titleSize
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            return titleFrame
        end

        local methods = {}

        function methods:AddTitle(tOptions)
            return addTitleFunc(tOptions)
        end

        function methods:section(cfg)
            cfg = cfg or {}
            local title = cfg.title or ""
            local iconValue = cfg.icon or ""
            local opened = cfg.opened
            if opened == nil then opened = true end
            local sectionBox = Instance.new("Frame", containerFrame)
            sectionBox.Name = (title ~= "" and title or "Section").."Section"
            sectionBox.BackgroundColor3 = currentTheme.SectionBG
            sectionBox.BackgroundTransparency = bgTrans
            sectionBox.BorderSizePixel = 0
            sectionBox.ClipsDescendants = true
            sectionBox.Size = UDim2.new(1, 0, 0, 0)
            sectionBox.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", sectionBox).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", sectionBox)
            stroke.Color = currentTheme.Stroke
            stroke.Thickness = 1
            local boxList = Instance.new("UIListLayout", sectionBox)
            boxList.SortOrder = Enum.SortOrder.LayoutOrder
            boxList.Padding = UDim.new(0, 0)
            local headerBtn = Instance.new("TextButton", sectionBox)
            headerBtn.Name = "Header"
            headerBtn.Size = UDim2.new(1, 0, 0, 38)
            headerBtn.BackgroundTransparency = 1
            headerBtn.Text = ""
            headerBtn.LayoutOrder = 1
            headerBtn.AutoButtonColor = false
            headerBtn.ClipsDescendants = true
            local hPad = Instance.new("UIPadding", headerBtn)
            hPad.PaddingLeft = UDim.new(0, 10)
            hPad.PaddingRight = UDim.new(0, 10)
            local leftIcon = Instance.new("ImageLabel", headerBtn)
            leftIcon.Name = "LeftIcon"
            leftIcon.Size = UDim2.new(0, 18, 0, 18)
            leftIcon.Position = UDim2.new(0, 0, 0.5, -9)
            leftIcon.BackgroundTransparency = 1
            leftIcon.Image = resolveIcon(iconValue, "section")
            leftIcon.ImageColor3 = currentTheme.IconCl
            leftIcon.Visible = iconValue ~= ""
            local titleLabel = Instance.new("TextLabel", headerBtn)
            titleLabel.Name = "Title"
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.new(0, iconValue ~= "" and 26 or 0, 0, 0)
            titleLabel.Size = UDim2.new(1, -40, 1, 0)
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 13
            titleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Text = title ~= "" and title or "Section"
            local chevron = Instance.new("ImageLabel", headerBtn)
            chevron.Name = "Chevron"
            chevron.Size = UDim2.new(0, 16, 0, 16)
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position = UDim2.new(1, 0, 0.5, 0)
            chevron.BackgroundTransparency = 1
            chevron.Image = opened and resolveIcon("chevron-up", "chevron-up") or resolveIcon("chevron-down", "chevron-down")
            chevron.ImageColor3 = Color3.fromRGB(180, 180, 180)
            local content = Instance.new("Frame", sectionBox)
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 0, 0)
            content.AutomaticSize = opened and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
            content.BackgroundTransparency = 1
            content.LayoutOrder = 2
            content.ClipsDescendants = true
            content.Visible = opened
            local cPad = Instance.new("UIPadding", content)
            cPad.PaddingLeft = UDim.new(0, 6)
            cPad.PaddingRight = UDim.new(0, 6)
            cPad.PaddingTop = UDim.new(0, 2)
            cPad.PaddingBottom = UDim.new(0, 6)
            local cLayout = Instance.new("UIListLayout", content)
            cLayout.SortOrder = Enum.SortOrder.LayoutOrder
            cLayout.Padding = UDim.new(0, 6)
            local isOpen = opened
            local tweening = false
            local function toggleSection()
                if tweening then return end
                tweening = true
                isOpen = not isOpen
                chevron.Image = isOpen and resolveIcon("chevron-up", "chevron-up") or resolveIcon("chevron-down", "chevron-down")
                if isOpen then
                    content.Visible = true
                    content.AutomaticSize = Enum.AutomaticSize.None
                    content.Size = UDim2.new(1, 0, 0, 0)
                    local target = cLayout.AbsoluteContentSize.Y + cPad.PaddingTop.Offset + cPad.PaddingBottom.Offset
                    local tw = TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, target)})
                    tw:Play()
                    tw.Completed:Wait()
                    content.AutomaticSize = Enum.AutomaticSize.Y
                    content.Size = UDim2.new(1, 0, 0, 0)
                    tweening = false
                else
                    local cur = cLayout.AbsoluteContentSize.Y + cPad.PaddingTop.Offset + cPad.PaddingBottom.Offset
                    content.AutomaticSize = Enum.AutomaticSize.None
                    content.Size = UDim2.new(1, 0, 0, cur)
                    task.wait()
                    local tw = TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
                    tw:Play()
                    tw.Completed:Wait()
                    content.Visible = false
                    tweening = false
                end
            end
            headerBtn.MouseButton1Click:Connect(toggleSection)
            local contentMethods = buatElementMethods(content)
            contentMethods._SectionBox = sectionBox
            return contentMethods
        end

        function methods:AddTabbox()
            local tabboxBox = Instance.new("Frame", containerFrame)
            tabboxBox.Name = "Tabbox"
            tabboxBox.BackgroundColor3 = currentTheme.SectionBG
            tabboxBox.BackgroundTransparency = bgTrans
            tabboxBox.BorderSizePixel = 0
            tabboxBox.ClipsDescendants = true
            tabboxBox.Size = UDim2.new(1, 0, 0, 0)
            tabboxBox.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", tabboxBox).CornerRadius = UDim.new(0, 6)
            local tabboxStroke = Instance.new("UIStroke", tabboxBox)
            tabboxStroke.Color = currentTheme.Stroke
            tabboxStroke.Thickness = 1
            local boxLayout = Instance.new("UIListLayout", tabboxBox)
            boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local subTabBar = Instance.new("Frame", tabboxBox)
            subTabBar.Name = "SubTabBar"
            subTabBar.Size = UDim2.new(1, 0, 0, 0)
            subTabBar.AutomaticSize = Enum.AutomaticSize.Y
            subTabBar.BackgroundTransparency = 1
            subTabBar.LayoutOrder = 1
            local subTabPad = Instance.new("UIPadding", subTabBar)
            subTabPad.PaddingLeft = UDim.new(0, 6)
            subTabPad.PaddingRight = UDim.new(0, 6)
            subTabPad.PaddingTop = UDim.new(0, 6)
            subTabPad.PaddingBottom = UDim.new(0, 6)
            local subTabLayout = Instance.new("UIListLayout", subTabBar)
            subTabLayout.FillDirection = Enum.FillDirection.Horizontal
            subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subTabLayout.Padding = UDim.new(0, 4)
            local subTabPages = Instance.new("Frame", tabboxBox)
            subTabPages.Name = "SubTabPages"
            subTabPages.Size = UDim2.new(1, 0, 0, 0)
            subTabPages.AutomaticSize = Enum.AutomaticSize.Y
            subTabPages.BackgroundTransparency = 1
            subTabPages.LayoutOrder = 2
            local subTabMethods = {}
            subTabMethods.SubTabs = {}
            subTabMethods.CurrentSubTab = nil
            function subTabMethods:AddTab(subTabName)
                local subTabBtn = Instance.new("TextButton", subTabBar)
                subTabBtn.Name = subTabName .. "Btn"
                subTabBtn.Size = UDim2.new(0, 0, 0, 24)
                subTabBtn.AutomaticSize = Enum.AutomaticSize.X
                subTabBtn.BackgroundColor3 = currentTheme.ButtonBG
                subTabBtn.BackgroundTransparency = bgTrans
                subTabBtn.Text = subTabName
                subTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                subTabBtn.Font = Enum.Font.GothamMedium
                subTabBtn.TextSize = 11
                Instance.new("UICorner", subTabBtn).CornerRadius = UDim.new(0, 4)
                local btnPadding = Instance.new("UIPadding", subTabBtn)
                btnPadding.PaddingLeft = UDim.new(0, 8)
                btnPadding.PaddingRight = UDim.new(0, 8)
                local btnStroke = Instance.new("UIStroke", subTabBtn)
                btnStroke.Color = currentTheme.Stroke
                btnStroke.Thickness = 1
                local subPage = Instance.new("Frame", subTabPages)
                subPage.Name = subTabName .. "Page"
                subPage.Size = UDim2.new(1, 0, 0, 0)
                subPage.AutomaticSize = Enum.AutomaticSize.Y
                subPage.BackgroundTransparency = 1
                subPage.Visible = false
                local subPagePad = Instance.new("UIPadding", subPage)
                subPagePad.PaddingLeft = UDim.new(0, 6)
                subPagePad.PaddingRight = UDim.new(0, 6)
                subPagePad.PaddingBottom = UDim.new(0, 6)
                local subPageLayout = Instance.new("UIListLayout", subPage)
                subPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                subPageLayout.Padding = UDim.new(0, 6)
                subTabBtn.MouseButton1Click:Connect(function()
                    for _, tabData in ipairs(subTabMethods.SubTabs) do
                        tabData.Button.BackgroundColor3 = currentTheme.ButtonBG
                        tabData.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                        tabData.Page.Visible = false
                    end
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end)
                if #subTabMethods.SubTabs == 0 then
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end
                local tabData = {Button = subTabBtn, Page = subPage}
                table.insert(subTabMethods.SubTabs, tabData)
                return buatElementMethods(subPage)
            end
            return subTabMethods
        end

        function methods:AddDivider(title)
            local holder = Instance.new("Frame", containerFrame)
            holder.BackgroundTransparency = 1
            holder.Size = UDim2.new(1, 0, 0, 16)

            if not title then
                local line = Instance.new("Frame", holder)
                line.Size = UDim2.new(1, 0, 0, 3)
                line.Position = UDim2.new(0, 0, 0.5, -1)
                line.BackgroundColor3 = currentTheme.Stroke
                line.BorderSizePixel = 0
                Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
                local gradient = Instance.new("UIGradient", line)
                gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.55),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 0.55)
                })
                return
            end

            local layout = Instance.new("UIListLayout", holder)
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.Padding = UDim.new(0, 6)

            local leftLine = Instance.new("Frame", holder)
            leftLine.Size = UDim2.new(0.5, -6, 0, 3)
            leftLine.BackgroundColor3 = currentTheme.Stroke
            leftLine.BorderSizePixel = 0
            leftLine.LayoutOrder = 1
            Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
            local leftGradient = Instance.new("UIGradient", leftLine)
            leftGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(1, 0)
            })

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(0, 0, 0, 14)
            label.AutomaticSize = Enum.AutomaticSize.X
            label.BackgroundTransparency = 1
            label.Text = title
            label.TextColor3 = Color3.fromRGB(160, 160, 160)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.LayoutOrder = 2

            local rightLine = Instance.new("Frame", holder)
            rightLine.Size = UDim2.new(0.5, -6, 0, 3)
            rightLine.BackgroundColor3 = currentTheme.Stroke
            rightLine.BorderSizePixel = 0
            rightLine.LayoutOrder = 3
            Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
            local rightGradient = Instance.new("UIGradient", rightLine)
        rightGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.55)
        })
    end

    function window:AddTitle(tOptions)
        tOptions = tOptions or {}
        local text = type(tOptions) == "string" and tOptions or tOptions.Title or tOptions.title or tOptions.Text or tOptions.text or "Title"
        local titleSize = tOptions.Size or tOptions.size or 9
        local holder = Instance.new("Frame", SidebarScroll)
        holder.Name = "Title"
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.BackgroundTransparency = 1
        local pad = Instance.new("UIPadding", holder)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 4)
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1, 0, 0, 0)
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = titleSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        return holder
    end

        function methods:Addbutton(btnOptions)
            btnOptions = btnOptions or {}
            local title = btnOptions.title or "Button"
            local desc = btnOptions.desc or ""
            local callback = btnOptions.callback or function() end

            local btnFrame = Instance.new("Frame", containerFrame)
            btnFrame.Size = UDim2.new(1, 0, 0, 36)
            btnFrame.BackgroundColor3 = currentTheme.ButtonBG
            btnFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)
            local bStroke = Instance.new("UIStroke", btnFrame)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", btnFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local icon = Instance.new("ImageLabel", btnFrame)
            icon.Name = "ButtonIcon"
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Position = UDim2.new(1, -24, 0.5, -8)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://10734898355"
            icon.ImageColor3 = currentTheme.IconCl

            local clickBtn = Instance.new("TextButton", btnFrame)
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""

            clickBtn.MouseButton1Click:Connect(function()
                local oldColor = btnFrame.BackgroundColor3
                btnFrame.BackgroundColor3 = currentTheme.Accent
                task.delay(0.1, function() btnFrame.BackgroundColor3 = oldColor end)
                callback()
            end)
        end

        function methods:Addtoggle(tglOptions)
            tglOptions = tglOptions or {}
            local title = tglOptions.title or "Toggle"
            local desc = tglOptions.desc or ""
            local flag = tglOptions.flag or tglOptions.Flag or title
            local defaultState = tglOptions.value
            if defaultState == nil then defaultState = tglOptions.default end
            if defaultState == nil then defaultState = false end
            if library.Flags[flag] ~= nil then defaultState = library.Flags[flag] end
            if flag then library.Flags[flag] = defaultState end
            local state = defaultState
            local callback = tglOptions.callback or function() end

            local tglFrame = Instance.new("Frame", containerFrame)
            tglFrame.Size = UDim2.new(1, 0, 0, 36)
            tglFrame.BackgroundColor3 = currentTheme.ButtonBG
            tglFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", tglFrame).CornerRadius = UDim.new(0, 6)
            local tStroke = Instance.new("UIStroke", tglFrame)
            tStroke.Color = currentTheme.Stroke
            tStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", tglFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local switch = Instance.new("Frame", tglFrame)
            switch.Size = UDim2.new(0, 34, 0, 18)
            switch.Position = UDim2.new(1, -42, 0.5, -9)
            switch.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

            local dot = Instance.new("Frame", switch)
            dot.Size = UDim2.new(0, 14, 0, 14)
            dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

            local clickBtn = Instance.new("TextButton", tglFrame)
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""

            local function updateToggle()
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 55)}):Play()
                TweenService:Create(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                onFlagChanged(flag, state)
                callback(state)
            end

            clickBtn.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
            end)
        end

        function methods:AddDropdown(ddOptions)
            ddOptions = ddOptions or {}
            local title = ddOptions.Title or "Dropdown"
            local desc = ddOptions.Desc or ""
            local list = ddOptions.Values or ddOptions.values or {}
            local flag = ddOptions.flag or ddOptions.Flag or title
            local selected = ddOptions.Value or ddOptions.value or {}
            if library.Flags[flag] ~= nil then
                if type(library.Flags[flag]) == "table" then selected = library.Flags[flag] else selected = {library.Flags[flag]} end
            else
                if flag and #selected>0 then library.Flags[flag] = selected end
            end
            local isMulti = ddOptions.Multi or false
            local search = ddOptions.Search or false
            local callback = ddOptions.Callback or function() end

            local ddFrame = Instance.new("Frame", containerFrame)
            ddFrame.Size = UDim2.new(1, 0, 0, 36)
            ddFrame.BackgroundColor3 = currentTheme.ButtonBG
            ddFrame.BackgroundTransparency = bgTrans
            ddFrame.ClipsDescendants = true
            Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 6)
            local dStroke = Instance.new("UIStroke", ddFrame)
            dStroke.Color = currentTheme.Stroke
            dStroke.Thickness = 1

            local top = Instance.new("TextButton", ddFrame)
            top.Size = UDim2.new(1, 0, 0, 36)
            top.BackgroundTransparency = 1
            top.Text = ""

            local textLabel = Instance.new("TextLabel", top)
            textLabel.Size = UDim2.new(0.6, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local choiceText = Instance.new("TextLabel", top)
            choiceText.Size = UDim2.new(0.35, 0, 1, 0)
            choiceText.Position = UDim2.new(0.65, -20, 0, 0)
            choiceText.BackgroundTransparency = 1
            choiceText.Text = table.concat(selected, ", ")
            choiceText.TextColor3 = currentTheme.Accent
            choiceText.Font = Enum.Font.Gotham
            choiceText.TextSize = 11
            choiceText.TextXAlignment = Enum.TextXAlignment.Right

            local arrow = Instance.new("TextLabel", top)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "v"
            arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 12

            local dropList = Instance.new("Frame", ddFrame)
            local initialListHeight = #list * 28
            if search then initialListHeight = initialListHeight + 30 end
            dropList.Size = UDim2.new(1, 0, 0, initialListHeight)
            dropList.Position = UDim2.new(0, 0, 0, 36)
            dropList.BackgroundTransparency = 1

            local dlLayout = Instance.new("UIListLayout", dropList)
            dlLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local searchContainer
            local searchBox
            if search then
                searchContainer = Instance.new("Frame", dropList)
                searchContainer.Size = UDim2.new(1, 0, 0, 30)
                searchContainer.BackgroundTransparency = 1
                searchContainer.LayoutOrder = 0

                searchBox = Instance.new("TextBox", searchContainer)
                searchBox.Size = UDim2.new(1, -16, 0, 24)
                searchBox.Position = UDim2.new(0, 8, 0.5, -12)
                searchBox.BackgroundColor3 = currentTheme.SectionBG
                searchBox.BackgroundTransparency = bgTrans
                searchBox.Text = ""
                searchBox.PlaceholderText = "search.."
                searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 12
                Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)
                local sBStroke = Instance.new("UIStroke", searchBox)
                sBStroke.Color = currentTheme.Stroke
                sBStroke.Thickness = 1
            end

            local expanded = false
            local optionButtons = {}

            local function refreshSelected()
                choiceText.Text = table.concat(selected, ", ")
                if flag then
                    if isMulti then onFlagChanged(flag, selected) else onFlagChanged(flag, selected[1] or "") end
                end
                if isMulti then callback(selected) else callback(selected[1] or "") end
            end

            local function refreshOptionVisuals()
                for _, item in ipairs(optionButtons) do
                    local isSelected = table.find(selected, item.Value) ~= nil
                    item.Button.BackgroundColor3 = isSelected and currentTheme.SectionBG or currentTheme.ButtonBG
                    item.Button.TextColor3 = isSelected and currentTheme.Accent or Color3.fromRGB(200, 200, 200)
                end
            end

            for i, val in ipairs(list) do
                local opt = Instance.new("TextButton", dropList)
                opt.Size = UDim2.new(1, 0, 0, 28)
                opt.BackgroundColor3 = table.find(selected, val) and currentTheme.SectionBG or currentTheme.ButtonBG
                opt.BackgroundTransparency = bgTrans
                opt.Text = "  " .. val
                opt.TextColor3 = table.find(selected, val) and currentTheme.Accent or Color3.fromRGB(200, 200, 200)
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 12
                opt.TextXAlignment = Enum.TextXAlignment.Left
                opt.BorderSizePixel = 0
                opt.LayoutOrder = i

                table.insert(optionButtons, {Button = opt, Value = val})

                opt.MouseButton1Click:Connect(function()
                    if isMulti then
                        local found = table.find(selected, val)
                        if found then
                            table.remove(selected, found)
                        else
                            table.insert(selected, val)
                        end
                    else
                        selected = {val}
                        expanded = false
                        TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        arrow.Text = "v"
                    end
                    refreshOptionVisuals()
                    refreshSelected()
                end)
            end

            if search and searchBox then
                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local searchText = searchBox.Text:lower()
                    local visibleCount = 0
                    for _, item in ipairs(optionButtons) do
                        if searchText == "" or item.Value:lower():find(searchText) then
                            item.Button.Visible = true
                            visibleCount = visibleCount + 1
                        else
                            item.Button.Visible = false
                        end
                    end
                    local newHeight = (visibleCount * 28) + 30
                    dropList.Size = UDim2.new(1, 0, 0, newHeight)
                    if expanded then
                        ddFrame.Size = UDim2.new(1, 0, 0, 36 + newHeight)
                    end
                end)
            end

            top.MouseButton1Click:Connect(function()
                expanded = not expanded
                local currentHeight = 0
                if expanded then
                    local visibleCount = 0
                    for _, item in ipairs(optionButtons) do
                        if item.Button.Visible then visibleCount = visibleCount + 1 end
                    end
                    currentHeight = (visibleCount * 28) + (search and 30 or 0)
                end
                local targetSize = expanded and UDim2.new(1, 0, 0, 36 + currentHeight) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                arrow.Text = expanded and "^" or "v"
            end)
        end

        function methods:AddSlider(sldOptions)
            sldOptions = sldOptions or {}
            local title = sldOptions.Title or "Slider"
            local desc = sldOptions.Desc or ""
            local step = sldOptions.Step or 1
            local min = sldOptions.Value and sldOptions.Value.Min or sldOptions.Min or 0
            local max = sldOptions.Value and sldOptions.Value.Max or sldOptions.Max or 100
            local default = sldOptions.Value and sldOptions.Value.Default or sldOptions.Default or sldOptions.default or min
            local flag = sldOptions.flag or sldOptions.Flag or title
            if library.Flags[flag] ~= nil then default = library.Flags[flag] end
            if flag then library.Flags[flag] = default end
            local callback = sldOptions.Callback or function() end

            local currentVal = default

            local sldFrame = Instance.new("Frame", containerFrame)
            sldFrame.Size = UDim2.new(1, 0, 0, 44)
            sldFrame.BackgroundColor3 = currentTheme.ButtonBG
            sldFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", sldFrame).CornerRadius = UDim.new(0, 6)
            local sStroke = Instance.new("UIStroke", sldFrame)
            sStroke.Color = currentTheme.Stroke
            sStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", sldFrame)
            textLabel.Size = UDim2.new(0.6, 0, 0, 24)
            textLabel.Position = UDim2.new(0, 8, 0, 2)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " <font color='rgb(150,150,150)'>- "..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valLabel = Instance.new("TextBox", sldFrame)
            valLabel.Size = UDim2.new(0.35, 0, 0, 24)
            valLabel.Position = UDim2.new(0.65, -8, 0, 2)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = currentTheme.Accent
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.ClearTextOnFocus = false

            local lane = Instance.new("Frame", sldFrame)
            lane.Size = UDim2.new(1, -16, 0, 4)
            lane.Position = UDim2.new(0, 8, 1, -12)
            lane.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", lane)

            local fill = Instance.new("Frame", lane)
            fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = currentTheme.Accent
            Instance.new("UICorner", fill)

            local sliderBtn = Instance.new("TextButton", lane)
            sliderBtn.Size = UDim2.new(1, 0, 3, 0)
            sliderBtn.Position = UDim2.new(0, 0, -1, 0)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""

            local sliding = false

            local function applyValue(newVal)
                currentVal = math.clamp(math.round(newVal / step) * step, min, max)
                fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(currentVal)
                onFlagChanged(flag, currentVal)
                callback(currentVal)
            end

            local function updateSlider(input)
                local currentX = input.Position.X
                local startX = lane.AbsolutePosition.X
                local width = lane.AbsoluteSize.X
                local ratio = math.clamp((currentX - startX) / width, 0, 1)
                local exactVal = min + (ratio * (max - min))
                applyValue(exactVal)
            end

            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            valLabel.FocusLost:Connect(function()
                local inputNum = tonumber(valLabel.Text)
                if inputNum then
                    applyValue(inputNum)
                else
                    valLabel.Text = tostring(currentVal)
                end
            end)

            callback(default)
        end

        function methods:AddParagraph(pOptions)
            pOptions = pOptions or {}
            local title = pOptions.Title or pOptions.title or "Paragraph"
            local desc = pOptions.Desc or pOptions.desc or ""
            local colorStr = pOptions.Color or pOptions.color or "White"
            local buttonData = pOptions.Button or pOptions.button or nil
            local buttonsData = pOptions.Buttons or pOptions.buttons or nil

            local colorMap = {
                white = Color3.fromRGB(255, 255, 255),
                gray = Color3.fromRGB(160, 160, 160),
                grey = Color3.fromRGB(160, 160, 160),
                red = Color3.fromRGB(255, 80, 80),
                blue = Color3.fromRGB(80, 140, 255),
                green = Color3.fromRGB(80, 200, 120),
                purple = Color3.fromRGB(160, 80, 255),
                pink = Color3.fromRGB(255, 105, 180)
            }

            local pFrame = Instance.new("Frame", containerFrame)
            pFrame.Name = "Paragraph"
            pFrame.Size = UDim2.new(1, 0, 0, 0)
            pFrame.AutomaticSize = Enum.AutomaticSize.Y
            pFrame.BackgroundColor3 = currentTheme.ButtonBG
            pFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 6)
            local pStroke = Instance.new("UIStroke", pFrame)
            pStroke.Color = currentTheme.Stroke
            pStroke.Thickness = 1

            local pPad = Instance.new("UIPadding", pFrame)
            pPad.PaddingLeft = UDim.new(0, 8)
            pPad.PaddingRight = UDim.new(0, 8)
            pPad.PaddingTop = UDim.new(0, 6)
            pPad.PaddingBottom = UDim.new(0, 6)

            local pLayout = Instance.new("UIListLayout", pFrame)
            pLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pLayout.Padding = UDim.new(0, 4)

            local titleLabel = Instance.new("TextLabel", pFrame)
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(1, 0, 0, 16)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            local lowerColor = string.lower(tostring(colorStr))
            titleLabel.TextColor3 = colorMap[lowerColor] or Color3.fromRGB(255, 255, 255)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 12
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local descLabel = Instance.new("TextLabel", pFrame)
            descLabel.Name = "Desc"
            descLabel.Size = UDim2.new(1, 0, 0, 0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.BackgroundTransparency = 1
            descLabel.Text = desc
            descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 11
            descLabel.TextWrapped = true
            descLabel.TextXAlignment = Enum.TextXAlignment.Left

            local function createParaButton(bCfg, isInContainer)
                bCfg = bCfg or {}
                local bTitle = bCfg.title or bCfg.Title or "Button"
                local bCallback = bCfg.callback or bCfg.Callback or bCfg.fallback or function() end
                local parent = isInContainer or pFrame
                local bFrame = Instance.new("TextButton", parent)
                bFrame.Name = "ParaButton"
                if isInContainer then
                    bFrame.Size = UDim2.new(1/#isInContainer.Count, -6*(isInContainer.Count-1)/isInContainer.Count, 0, 28)
                else
                    bFrame.Size = UDim2.new(1, 0, 0, 28)
                end
                bFrame.BackgroundColor3 = currentTheme.ButtonBG
                bFrame.BackgroundTransparency = bgTrans
                bFrame.Text = ""
                bFrame.AutoButtonColor = false
                bFrame.ClipsDescendants = false
                Instance.new("UICorner", bFrame).CornerRadius = UDim.new(0, 6)
                local bStroke = Instance.new("UIStroke", bFrame)
                bStroke.Color = currentTheme.Stroke
                bStroke.Thickness = 2.5
                bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                local bLabel = Instance.new("TextLabel", bFrame)
                bLabel.Size = UDim2.new(1, -12, 1, 0)
                bLabel.Position = UDim2.new(0, 6, 0, 0)
                bLabel.BackgroundTransparency = 1
                bLabel.Text = bTitle
                bLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                bLabel.Font = Enum.Font.GothamMedium
                bLabel.TextSize = 11
                bLabel.TextXAlignment = Enum.TextXAlignment.Center
                bFrame.MouseButton1Click:Connect(function()
                    bFrame.BackgroundColor3 = currentTheme.Accent
                    task.delay(0.1, function()
                        bFrame.BackgroundColor3 = currentTheme.ButtonBG
                    end)
                    bCallback()
                end)
                return bFrame
            end

            local function createDoubleTripleButtons(btnList)
                if #btnList == 0 then return end
                if #btnList > 3 then
                    local limited = {}
                    for i=1,3 do
                        table.insert(limited, btnList[i])
                    end
                    btnList = limited
                end
                local container = Instance.new("Frame", pFrame)
                container.Name = "ParaButtonsContainer"
                container.Size = UDim2.new(1, 0, 0, 28)
                container.BackgroundTransparency = 1
                container.ClipsDescendants = false
                local layout = Instance.new("UIListLayout", container)
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 6)
                local count = #btnList
                for _, bCfg in ipairs(btnList) do
                    bCfg = bCfg or {}
                    local bTitle = bCfg.title or bCfg.Title or "Button"
                    local bCallback = bCfg.callback or bCfg.Callback or bCfg.fallback or function() end
                    local bFrame = Instance.new("TextButton", container)
                    bFrame.Name = "ParaButton"
                    bFrame.Size = UDim2.new(1/count, -6*(count-1)/count, 0, 28)
                    bFrame.BackgroundColor3 = currentTheme.ButtonBG
                    bFrame.BackgroundTransparency = bgTrans
                    bFrame.Text = ""
                    bFrame.AutoButtonColor = false
                    bFrame.ClipsDescendants = false
                    Instance.new("UICorner", bFrame).CornerRadius = UDim.new(0, 6)
                    local bStroke = Instance.new("UIStroke", bFrame)
                    bStroke.Color = currentTheme.Stroke
                    bStroke.Thickness = 2.5
                    bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    local bLabel = Instance.new("TextLabel", bFrame)
                    bLabel.Size = UDim2.new(1, -6, 1, 0)
                    bLabel.Position = UDim2.new(0, 3, 0, 0)
                    bLabel.BackgroundTransparency = 1
                    bLabel.Text = bTitle
                    bLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    bLabel.Font = Enum.Font.GothamMedium
                    bLabel.TextSize = 11
                    bLabel.TextXAlignment = Enum.TextXAlignment.Center
                    bFrame.MouseButton1Click:Connect(function()
                        bFrame.BackgroundColor3 = currentTheme.Accent
                        task.delay(0.1, function()
                            bFrame.BackgroundColor3 = currentTheme.ButtonBG
                        end)
                        bCallback()
                    end)
                end
            end

            if buttonsData and type(buttonsData) == "table" and buttonsData[1] then
                createDoubleTripleButtons(buttonsData)
            elseif buttonData then
                createParaButton(buttonData, nil)
            end

            local paraObj = {}
            paraObj.Frame = pFrame
            function paraObj:SetDesc(newDesc)
                descLabel.Text = newDesc
            end
            function paraObj:SetTitle(newTitle)
                titleLabel.Text = newTitle
            end
            function paraObj:SetColor(newColor)
                local lc = string.lower(tostring(newColor))
                titleLabel.TextColor3 = colorMap[lc] or Color3.fromRGB(255,255,255)
            end
            function paraObj:AddButton(bCfg)
                return createParaButton(bCfg, nil)
            end
            function paraObj:button(bCfg)
                return createParaButton(bCfg, nil)
            end
            function paraObj:AddButtons(btnList)
                return createDoubleTripleButtons(btnList)
            end
            return paraObj
        end

        function methods:AddKeybind(kbOptions)
            kbOptions = kbOptions or {}
            local title = kbOptions.title or kbOptions.Title or "Keybind"
            local desc = kbOptions.desc or kbOptions.Desc or ""
            local flag = kbOptions.flag or kbOptions.Flag or title
            local currentKey = kbOptions.Value or kbOptions.value or "G"
            if library.Flags[flag] ~= nil then currentKey = library.Flags[flag] end
            if flag then library.Flags[flag] = currentKey end
            local callback = kbOptions.Callback or kbOptions.callback or function() end

            local kbFrame = Instance.new("Frame", containerFrame)
            kbFrame.Size = UDim2.new(1, 0, 0, 36)
            kbFrame.BackgroundColor3 = currentTheme.ButtonBG
            kbFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)
            local kStroke = Instance.new("UIStroke", kbFrame)
            kStroke.Color = currentTheme.Stroke
            kStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", kbFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local bindBox = Instance.new("TextButton", kbFrame)
            bindBox.Size = UDim2.new(0, 45, 0, 20)
            bindBox.Position = UDim2.new(1, -53, 0.5, -10)
            bindBox.BackgroundColor3 = currentTheme.SectionBG
            bindBox.BackgroundTransparency = bgTrans
            bindBox.Text = currentKey
            bindBox.TextColor3 = currentTheme.Accent
            bindBox.Font = Enum.Font.GothamBold
            bindBox.TextSize = 11
            Instance.new("UICorner", bindBox).CornerRadius = UDim.new(0, 4)
            local bStroke = Instance.new("UIStroke", bindBox)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local listen = false

            bindBox.MouseButton1Click:Connect(function()
                listen = true
                bindBox.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input, processed)
                if listen and not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        listen = false
                        currentKey = input.KeyCode.Name
                        bindBox.Text = currentKey
                        onFlagChanged(flag, currentKey)
                        callback(currentKey)
                    end
                end
            end)
        end

        function methods:AddInput(inpOptions)
            inpOptions = inpOptions or {}
            local title = inpOptions.Title or "Input"
            local desc = inpOptions.Desc or ""
            local flag = inpOptions.flag or inpOptions.Flag or title
            local default = inpOptions.Value or inpOptions.value or inpOptions.default or ""
            if library.Flags[flag] ~= nil then default = library.Flags[flag] end
            if flag then library.Flags[flag] = default end
            local callback = inpOptions.Callback or function() end

            local inpFrame = Instance.new("Frame", containerFrame)
            inpFrame.Size = UDim2.new(1, 0, 0, 36)
            inpFrame.BackgroundColor3 = currentTheme.ButtonBG
            inpFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", inpFrame).CornerRadius = UDim.new(0, 6)
            local iStroke = Instance.new("UIStroke", inpFrame)
            iStroke.Color = currentTheme.Stroke
            iStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", inpFrame)
            textLabel.Size = UDim2.new(0.5, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local textBox = Instance.new("TextBox", inpFrame)
            textBox.Size = UDim2.new(0.45, 0, 0, 24)
            textBox.Position = UDim2.new(1, -8, 0.5, -12)
            textBox.AnchorPoint = Vector2.new(1, 0)
            textBox.BackgroundColor3 = currentTheme.SectionBG
            textBox.BackgroundTransparency = bgTrans
            textBox.Text = default
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 12
            textBox.PlaceholderText = "Ketik..."
            textBox.ClipsDescendants = true
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
            local tStroke = Instance.new("UIStroke", textBox)
            tStroke.Color = currentTheme.Stroke
            tStroke.Thickness = 1

            textBox.FocusLost:Connect(function()
                onFlagChanged(flag, textBox.Text)
                callback(textBox.Text)
            end)

            return textBox
        end

        function methods:AddColorpicker(cpOptions)
            cpOptions = cpOptions or {}
            local title = cpOptions.Title or "Colorpicker"
            local desc = cpOptions.Desc or ""
            local flag = cpOptions.flag or cpOptions.Flag or title
            local default = cpOptions.Default or cpOptions.default or Color3.fromRGB(255, 255, 255)
            if library.Flags[flag] ~= nil then
                local sv = library.Flags[flag]
                if type(sv) == "table" and sv.r then default = Color3.new(sv.r, sv.g, sv.b) elseif typeof(sv) == "Color3" then default = sv end
            else
                if flag then library.Flags[flag] = {r=default.R,g=default.G,b=default.B,__type="Color3"} end
            end
            local callback = cpOptions.Callback or function() end

            local currentR = math.round(default.R * 255)
            local currentG = math.round(default.G * 255)
            local currentB = math.round(default.B * 255)

            local cpFrame = Instance.new("Frame", containerFrame)
            cpFrame.Size = UDim2.new(1, 0, 0, 36)
            cpFrame.BackgroundColor3 = currentTheme.ButtonBG
            cpFrame.BackgroundTransparency = bgTrans
            cpFrame.ClipsDescendants = true
            Instance.new("UICorner", cpFrame).CornerRadius = UDim.new(0, 6)
            local cStroke = Instance.new("UIStroke", cpFrame)
            cStroke.Color = currentTheme.Stroke
            cStroke.Thickness = 1

            local top = Instance.new("TextButton", cpFrame)
            top.Size = UDim2.new(1, 0, 0, 36)
            top.BackgroundTransparency = 1
            top.Text = ""

            local textLabel = Instance.new("TextLabel", top)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("Frame", top)
            box.Size = UDim2.new(0, 34, 0, 18)
            box.Position = UDim2.new(1, -42, 0.5, -9)
            box.BackgroundColor3 = default
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
            local bStroke = Instance.new("UIStroke", box)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local slidersFrame = Instance.new("Frame", cpFrame)
            slidersFrame.Size = UDim2.new(1, 0, 0, 110)
            slidersFrame.Position = UDim2.new(0, 0, 0, 36)
            slidersFrame.BackgroundTransparency = 1

            local sfLayout = Instance.new("UIListLayout", slidersFrame)
            sfLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sfLayout.Padding = UDim.new(0, 4)

            local sfPad = Instance.new("UIPadding", slidersFrame)
            sfPad.PaddingLeft = UDim.new(0, 8)
            sfPad.PaddingRight = UDim.new(0, 8)
            sfPad.PaddingTop = UDim.new(0, 4)

            local expanded = false

            local function updateColor()
                local newColor = Color3.fromRGB(currentR, currentG, currentB)
                box.BackgroundColor3 = newColor
                onFlagChanged(flag, newColor)
                callback(newColor)
            end

            local function buatRGBSlider(warnaName, defaultVal, callbackRGB)
                local sFrame = Instance.new("Frame", slidersFrame)
                sFrame.Size = UDim2.new(1, 0, 0, 30)
                sFrame.BackgroundTransparency = 1

                local label = Instance.new("TextLabel", sFrame)
                label.Size = UDim2.new(0, 20, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = warnaName
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 11

                local valLabel = Instance.new("TextLabel", sFrame)
                valLabel.Size = UDim2.new(0, 25, 1, 0)
                valLabel.Position = UDim2.new(1, -25, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = tostring(defaultVal)
                valLabel.TextColor3 = currentTheme.Accent
                valLabel.Font = Enum.Font.GothamMedium
                valLabel.TextSize = 11

                local lane = Instance.new("Frame", sFrame)
                lane.Size = UDim2.new(1, -55, 0, 4)
                lane.Position = UDim2.new(0, 25, 0.5, -2)
                lane.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                Instance.new("UICorner", lane)

                local fill = Instance.new("Frame", lane)
                fill.Size = UDim2.new(defaultVal / 255, 0, 1, 0)
                fill.BackgroundColor3 = currentTheme.Accent
                Instance.new("UICorner", fill)

                local sliderBtn = Instance.new("TextButton", lane)
                sliderBtn.Size = UDim2.new(1, 0, 3, 0)
                sliderBtn.Position = UDim2.new(0, 0, -1, 0)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""

                local sliding = false

                local function updateSlider(input)
                    local ratio = math.clamp((input.Position.X - lane.AbsolutePosition.X) / lane.AbsoluteSize.X, 0, 1)
                    local finalVal = math.round(ratio * 255)
                    fill.Size = UDim2.new(finalVal / 255, 0, 1, 0)
                    valLabel.Text = tostring(finalVal)
                    callbackRGB(finalVal)
                end

                sliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
            end

            buatRGBSlider("R", currentR, function(v) currentR = v updateColor() end)
            buatRGBSlider("G", currentG, function(v) currentG = v updateColor() end)
            buatRGBSlider("B", currentB, function(v) currentB = v updateColor() end)

            top.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetSize = expanded and UDim2.new(1, 0, 0, 146) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(cpFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
            end)
        end

        function methods:AddTabbox()
            local tabboxBox = Instance.new("Frame", containerFrame)
            tabboxBox.Name = "Tabbox"
            tabboxBox.BackgroundColor3 = currentTheme.SectionBG
            tabboxBox.BackgroundTransparency = bgTrans
            tabboxBox.BorderSizePixel = 0
            tabboxBox.ClipsDescendants = true
            tabboxBox.Size = UDim2.new(1, 0, 0, 0)
            tabboxBox.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", tabboxBox).CornerRadius = UDim.new(0, 6)
            local tabboxStroke = Instance.new("UIStroke", tabboxBox)
            tabboxStroke.Color = currentTheme.Stroke
            tabboxStroke.Thickness = 1
            local boxLayout = Instance.new("UIListLayout", tabboxBox)
            boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local subTabBar = Instance.new("Frame", tabboxBox)
            subTabBar.Name = "SubTabBar"
            subTabBar.Size = UDim2.new(1, 0, 0, 0)
            subTabBar.AutomaticSize = Enum.AutomaticSize.Y
            subTabBar.BackgroundTransparency = 1
            subTabBar.LayoutOrder = 1
            local subTabPad = Instance.new("UIPadding", subTabBar)
            subTabPad.PaddingLeft = UDim.new(0, 6)
            subTabPad.PaddingRight = UDim.new(0, 6)
            subTabPad.PaddingTop = UDim.new(0, 6)
            subTabPad.PaddingBottom = UDim.new(0, 6)
            local subTabLayout = Instance.new("UIListLayout", subTabBar)
            subTabLayout.FillDirection = Enum.FillDirection.Horizontal
            subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subTabLayout.Padding = UDim.new(0, 4)
            local subTabPages = Instance.new("Frame", tabboxBox)
            subTabPages.Name = "SubTabPages"
            subTabPages.Size = UDim2.new(1, 0, 0, 0)
            subTabPages.AutomaticSize = Enum.AutomaticSize.Y
            subTabPages.BackgroundTransparency = 1
            subTabPages.LayoutOrder = 2
            local subTabMethods = {}
            subTabMethods.SubTabs = {}
            subTabMethods.CurrentSubTab = nil
            function subTabMethods:AddTab(subTabName)
                local subTabBtn = Instance.new("TextButton", subTabBar)
                subTabBtn.Name = subTabName .. "Btn"
                subTabBtn.Size = UDim2.new(0, 0, 0, 24)
                subTabBtn.AutomaticSize = Enum.AutomaticSize.X
                subTabBtn.BackgroundColor3 = currentTheme.ButtonBG
                subTabBtn.BackgroundTransparency = bgTrans
                subTabBtn.Text = subTabName
                subTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                subTabBtn.Font = Enum.Font.GothamMedium
                subTabBtn.TextSize = 11
                Instance.new("UICorner", subTabBtn).CornerRadius = UDim.new(0, 4)
                local btnPadding = Instance.new("UIPadding", subTabBtn)
                btnPadding.PaddingLeft = UDim.new(0, 8)
                btnPadding.PaddingRight = UDim.new(0, 8)
                local btnStroke = Instance.new("UIStroke", subTabBtn)
                btnStroke.Color = currentTheme.Stroke
                btnStroke.Thickness = 1
                local subPage = Instance.new("Frame", subTabPages)
                subPage.Name = subTabName .. "Page"
                subPage.Size = UDim2.new(1, 0, 0, 0)
                subPage.AutomaticSize = Enum.AutomaticSize.Y
                subPage.BackgroundTransparency = 1
                subPage.Visible = false
                local subPagePad = Instance.new("UIPadding", subPage)
                subPagePad.PaddingLeft = UDim.new(0, 6)
                subPagePad.PaddingRight = UDim.new(0, 6)
                subPagePad.PaddingBottom = UDim.new(0, 6)
                local subPageLayout = Instance.new("UIListLayout", subPage)
                subPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                subPageLayout.Padding = UDim.new(0, 6)
                subTabBtn.MouseButton1Click:Connect(function()
                    for _, tabData in ipairs(subTabMethods.SubTabs) do
                        tabData.Button.BackgroundColor3 = currentTheme.ButtonBG
                        tabData.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                        tabData.Page.Visible = false
                    end
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end)
                if #subTabMethods.SubTabs == 0 then
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end
                local tabData = {Button = subTabBtn, Page = subPage}
                table.insert(subTabMethods.SubTabs, tabData)
                return buatElementMethods(subPage)
            end
            return subTabMethods
        end

        return methods
    end

    function window:AddTab(tabName, iconName)
        local tabIndex = #self.Tabs + 1
        local button, iconImg = buatButton(tabName.."Btn", iconName or "code")

        local page = Instance.new("Frame", ContentHolder)
        page.Name = tabName
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ClipsDescendants = true

        local pad = Instance.new("UIPadding", page)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)

        local frame = Instance.new("Frame", page)
        frame.Name = "Card"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = currentTheme.MainBG
        frame.BackgroundTransparency = bgTrans
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        local fstroke = Instance.new("UIStroke", frame)
        fstroke.Color = currentTheme.Stroke
        fstroke.Thickness = 2.5

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Name = "Scroll"
        scroll.Size = UDim2.new(1, -24, 1, -24)
        scroll.Position = UDim2.new(0, 12, 0, 12)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local sPad = Instance.new("UIPadding", scroll)
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 6)
        sPad.PaddingTop = UDim.new(0, 6)
        sPad.PaddingBottom = UDim.new(0, 16 / UIScale.Scale)

        UIScale:GetPropertyChangedSignal("Scale"):Connect(function()
            sPad.PaddingBottom = UDim.new(0, 16 / UIScale.Scale)
        end)

        local hlayout = Instance.new("UIListLayout", scroll)
        hlayout.FillDirection = Enum.FillDirection.Vertical
        hlayout.Padding = UDim.new(0, 6)
        hlayout.SortOrder = Enum.SortOrder.LayoutOrder

        button.MouseButton1Click:Connect(function()
            if window.CurrentTab and window.CurrentTab.Index ~= tabIndex then
                local oldTab = window.CurrentTab

                oldTab.Button.BackgroundColor3 = currentTheme.ButtonBG
                oldTab.Icon.ImageColor3 = currentTheme.IconCl
                oldTab.Page.Visible = false

                button.BackgroundColor3 = currentTheme.Accent
                iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)

                page.Position = UDim2.new(0, 0, 0, 0)
                page.Visible = true

                tabLabel.Text = tabName
                tabLabel.TextTransparency = 0

                window.CurrentTab = {Page = page, Button = button, Icon = iconImg, Index = tabIndex}
            end
        end)

        local tabObj = buatElementMethods(scroll)

        function tabObj:section(cfg)
            cfg = cfg or {}
            local title = cfg.title or ""
            local iconValue = cfg.icon or ""
            local opened = cfg.opened
            if opened == nil then opened = true end

            local sectionBox = Instance.new("Frame", scroll)
            sectionBox.Name = (title ~= "" and title or "Section").."Section"
            sectionBox.BackgroundColor3 = currentTheme.SectionBG
            sectionBox.BackgroundTransparency = bgTrans
            sectionBox.BorderSizePixel = 0
            sectionBox.ClipsDescendants = true
            sectionBox.Size = UDim2.new(1, 0, 0, 0)
            sectionBox.AutomaticSize = Enum.AutomaticSize.Y

            Instance.new("UICorner", sectionBox).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", sectionBox)
            stroke.Color = currentTheme.Stroke
            stroke.Thickness = 1

            local boxList = Instance.new("UIListLayout", sectionBox)
            boxList.SortOrder = Enum.SortOrder.LayoutOrder
            boxList.Padding = UDim.new(0, 0)

            local headerBtn = Instance.new("TextButton", sectionBox)
            headerBtn.Name = "Header"
            headerBtn.Size = UDim2.new(1, 0, 0, 38)
            headerBtn.BackgroundTransparency = 1
            headerBtn.Text = ""
            headerBtn.LayoutOrder = 1
            headerBtn.AutoButtonColor = false
            headerBtn.ClipsDescendants = true

            local hPad = Instance.new("UIPadding", headerBtn)
            hPad.PaddingLeft = UDim.new(0, 10)
            hPad.PaddingRight = UDim.new(0, 10)

            local leftIcon = Instance.new("ImageLabel", headerBtn)
            leftIcon.Name = "LeftIcon"
            leftIcon.Size = UDim2.new(0, 18, 0, 18)
            leftIcon.Position = UDim2.new(0, 0, 0.5, -9)
            leftIcon.BackgroundTransparency = 1
            leftIcon.Image = resolveIcon(iconValue, "section")
            leftIcon.ImageColor3 = currentTheme.IconCl
            leftIcon.Visible = iconValue ~= ""

            local titleLabel = Instance.new("TextLabel", headerBtn)
            titleLabel.Name = "Title"
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.new(0, iconValue ~= "" and 26 or 0, 0, 0)
            titleLabel.Size = UDim2.new(1, -40, 1, 0)
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 13
            titleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Text = title ~= "" and title or "Section"

            local chevron = Instance.new("ImageLabel", headerBtn)
            chevron.Name = "Chevron"
            chevron.Size = UDim2.new(0, 16, 0, 16)
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position = UDim2.new(1, 0, 0.5, 0)
            chevron.BackgroundTransparency = 1
            chevron.Image = opened and resolveIcon("chevron-up", "chevron-up") or resolveIcon("chevron-down", "chevron-down")
            chevron.ImageColor3 = Color3.fromRGB(180, 180, 180)

            local content = Instance.new("Frame", sectionBox)
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 0, 0)
            content.AutomaticSize = opened and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
            content.BackgroundTransparency = 1
            content.LayoutOrder = 2
            content.ClipsDescendants = true
            content.Visible = opened

            local cPad = Instance.new("UIPadding", content)
            cPad.PaddingLeft = UDim.new(0, 6)
            cPad.PaddingRight = UDim.new(0, 6)
            cPad.PaddingTop = UDim.new(0, 2)
            cPad.PaddingBottom = UDim.new(0, 6)

            local cLayout = Instance.new("UIListLayout", content)
            cLayout.SortOrder = Enum.SortOrder.LayoutOrder
            cLayout.Padding = UDim.new(0, 6)

            local isOpen = opened
            local tweening = false

            local function toggleSection()
                if tweening then return end
                tweening = true
                isOpen = not isOpen
                chevron.Image = isOpen and resolveIcon("chevron-up", "chevron-up") or resolveIcon("chevron-down", "chevron-down")
                if isOpen then
                    content.Visible = true
                    content.AutomaticSize = Enum.AutomaticSize.None
                    content.Size = UDim2.new(1, 0, 0, 0)
                    local target = cLayout.AbsoluteContentSize.Y + cPad.PaddingTop.Offset + cPad.PaddingBottom.Offset
                    local tw = TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, target)})
                    tw:Play()
                    tw.Completed:Wait()
                    content.AutomaticSize = Enum.AutomaticSize.Y
                    content.Size = UDim2.new(1, 0, 0, 0)
                    tweening = false
                else
                    local cur = cLayout.AbsoluteContentSize.Y + cPad.PaddingTop.Offset + cPad.PaddingBottom.Offset
                    content.AutomaticSize = Enum.AutomaticSize.None
                    content.Size = UDim2.new(1, 0, 0, cur)
                    task.wait()
                    local tw = TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
                    tw:Play()
                    tw.Completed:Wait()
                    content.Visible = false
                    tweening = false
                end
            end

            headerBtn.MouseButton1Click:Connect(toggleSection)

            local contentMethods = buatElementMethods(content)
            contentMethods._SectionBox = sectionBox
            return contentMethods
        end

        function tabObj:AddTabbox()
            local tabboxBox = Instance.new("Frame", scroll)
            tabboxBox.Name = "Tabbox"
            tabboxBox.BackgroundColor3 = currentTheme.SectionBG
            tabboxBox.BackgroundTransparency = bgTrans
            tabboxBox.BorderSizePixel = 0
            tabboxBox.ClipsDescendants = true
            tabboxBox.Size = UDim2.new(1, 0, 0, 0)
            tabboxBox.AutomaticSize = Enum.AutomaticSize.Y

            Instance.new("UICorner", tabboxBox).CornerRadius = UDim.new(0, 6)
            local tabboxStroke = Instance.new("UIStroke", tabboxBox)
            tabboxStroke.Color = currentTheme.Stroke
            tabboxStroke.Thickness = 1

            local boxLayout = Instance.new("UIListLayout", tabboxBox)
            boxLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local subTabBar = Instance.new("Frame", tabboxBox)
            subTabBar.Name = "SubTabBar"
            subTabBar.Size = UDim2.new(1, 0, 0, 0)
            subTabBar.AutomaticSize = Enum.AutomaticSize.Y
            subTabBar.BackgroundTransparency = 1
            subTabBar.LayoutOrder = 1

            local subTabPad = Instance.new("UIPadding", subTabBar)
            subTabPad.PaddingLeft = UDim.new(0, 6)
            subTabPad.PaddingRight = UDim.new(0, 6)
            subTabPad.PaddingTop = UDim.new(0, 6)
            subTabPad.PaddingBottom = UDim.new(0, 6)

            local subTabLayout = Instance.new("UIListLayout", subTabBar)
            subTabLayout.FillDirection = Enum.FillDirection.Horizontal
            subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subTabLayout.Padding = UDim.new(0, 4)

            local subTabPages = Instance.new("Frame", tabboxBox)
            subTabPages.Name = "SubTabPages"
            subTabPages.Size = UDim2.new(1, 0, 0, 0)
            subTabPages.AutomaticSize = Enum.AutomaticSize.Y
            subTabPages.BackgroundTransparency = 1
            subTabPages.LayoutOrder = 2

            local subTabMethods = {}
            subTabMethods.SubTabs = {}
            subTabMethods.CurrentSubTab = nil

            function subTabMethods:AddTab(subTabName)
                local subTabBtn = Instance.new("TextButton", subTabBar)
                subTabBtn.Name = subTabName .. "Btn"
                subTabBtn.Size = UDim2.new(0, 0, 0, 24)
                subTabBtn.AutomaticSize = Enum.AutomaticSize.X
                subTabBtn.BackgroundColor3 = currentTheme.ButtonBG
                subTabBtn.BackgroundTransparency = bgTrans
                subTabBtn.Text = subTabName
                subTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                subTabBtn.Font = Enum.Font.GothamMedium
                subTabBtn.TextSize = 11

                local btnCorner = Instance.new("UICorner", subTabBtn)
                btnCorner.CornerRadius = UDim.new(0, 4)

                local btnPadding = Instance.new("UIPadding", subTabBtn)
                btnPadding.PaddingLeft = UDim.new(0, 8)
                btnPadding.PaddingRight = UDim.new(0, 8)

                local btnStroke = Instance.new("UIStroke", subTabBtn)
                btnStroke.Color = currentTheme.Stroke
                btnStroke.Thickness = 1

                local subPage = Instance.new("Frame", subTabPages)
                subPage.Name = subTabName .. "Page"
                subPage.Size = UDim2.new(1, 0, 0, 0)
                subPage.AutomaticSize = Enum.AutomaticSize.Y
                subPage.BackgroundTransparency = 1
                subPage.Visible = false

                local subPagePad = Instance.new("UIPadding", subPage)
                subPagePad.PaddingLeft = UDim.new(0, 6)
                subPagePad.PaddingRight = UDim.new(0, 6)
                subPagePad.PaddingBottom = UDim.new(0, 6)

                local subPageLayout = Instance.new("UIListLayout", subPage)
                subPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                subPageLayout.Padding = UDim.new(0, 6)

                subTabBtn.MouseButton1Click:Connect(function()
                    for _, tabData in ipairs(subTabMethods.SubTabs) do
                        tabData.Button.BackgroundColor3 = currentTheme.ButtonBG
                        tabData.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                        tabData.Page.Visible = false
                    end
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end)

                if #subTabMethods.SubTabs == 0 then
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    subTabMethods.CurrentSubTab = subPage
                end

                local tabData = {Button = subTabBtn, Page = subPage}
                table.insert(subTabMethods.SubTabs, tabData)

                return buatElementMethods(subPage)
            end

            return subTabMethods
        end

        if tabIndex == 1 then
            button.BackgroundColor3 = currentTheme.Accent
            iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true
            tabLabel.Text = tabName
            window.CurrentTab = {Page = page, Button = button, Icon = iconImg, Index = tabIndex}
        end

        table.insert(window.Tabs, tabObj)
        return tabObj
    end

    return window
end

return library
