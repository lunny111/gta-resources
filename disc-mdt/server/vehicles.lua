ESX.RegisterServerCallback('disc-mdt:searchVehicles', function(source, cb, search, model)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles o JOIN users u on u.identifier = o.owner WHERE lower(plate) LIKE lower(@plate)', {
        ['@plate'] = '%' .. search .. '%'
    }, function(vehicles)
        if model ~= nil then
            MySQL.Async.fetchAll('SELECT * from OWNED_VEHICLES o JOIN users u on u.identifier = o.owner where JSON_EXTRACT(VEHICLE, "$.model") = @model', {
                ['@model'] = model
            }, function(models)
                cb(table.combine(vehicles, models))
            end)
        else
            cb(vehicles)
        end
    end)
end)