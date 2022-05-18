--- Your custom inventory ---

function CustomInventory()
    print("jsem custom")
end

function CustomInventoryShop()
    print("jsem custom shop")
end

--- Inventoryhud by Trsak ---

function InventoryhudByTrsak()
    TriggerEvent("esx_inventoryhud:openStorageInventory", "society_police")
end

function InventoryhudByTrsakShop()
    local elements = {}
    for i = 1, #Config.PoliceShop.items, 1 do
        local item = Config.PoliceShop.items[i]

        table.insert(
                elements,
                {
                    name = item.name,
                    label = item.label,
                    type = "item_standard",
                    usable = false,
                    rare = item.rare,
                    limit = -1,
                    price = item.price,
                    canRemove = false
                }
        )
    end

    TriggerEvent("esx_inventoryhud:openShop", "custom", elements)

end