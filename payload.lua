-- PrismHub - script principal

gg.setRanges(gg.REGION_ANONYMOUS)
gg.setVisible(false)

local search_value = "3222016387"

function apply_modifications(base_address)
    local mb_offsets = { 0x150C, 0x1514, 0x151C }
    local mb_value = 18

    local esp_data = {
        { offset = 0x60, value = 1.0, type = gg.TYPE_FLOAT },
        { offset = 0x64, value = 16777215, type = gg.TYPE_QWORD },
        { offset = 0x68, value = 1, type = gg.TYPE_QWORD },
    }

    local new_values = {}
    local index = 1

    for _, offset in ipairs(mb_offsets) do
        new_values[index] = {
            address = base_address + offset,
            flags = 64,
            value = mb_value
        }
        index = index + 1
    end

    for _, data in ipairs(esp_data) do
        new_values[index] = {
            address = base_address + data.offset,
            flags = data.type,
            value = data.value
        }
        index = index + 1
    end

    gg.setValues(new_values)
    gg.addListItems(new_values)
end

function run_magic_bullets()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)

    gg.searchNumber(search_value, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    local results = gg.getResults(20)

    gg.addListItems(results)
    gg.clearResults()

    if #results > 0 then
        for _, result in ipairs(results) do
            apply_modifications(result.address)
        end
        gg.alert("Magic Bullets et ESP appliques sur " .. #results .. " objets.")
    else
        gg.alert("Aucun resultat pour " .. search_value .. ". Relance le jeu et reessaie.")
    end
end

local menu = { "[👑] Magic Bullets" }

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        local choice = gg.choice(menu, 0, "PrismHub")
        if choice == 1 then
            run_magic_bullets()
        end
    end
    gg.sleep(100)
end