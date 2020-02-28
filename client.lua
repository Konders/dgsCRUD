
--     Общий список пользователей

--     Добавление нового пользователя:
--     		Имя пользователя
--     		Фамилия пользователя
--     		Адрес проживания

--     Редактирование пользователей

--     Удаление пользователей с всплывающим окном подтверждения

loadstring(exports.dgs:dgsImportFunction())()
dgsSetSystemFont("sf.ttf",9,false,"proof")

local window 
addEvent("retrieveUsers",true)
addEventHandler("retrieveUsers",localPlayer,function(list,columns) 
    if window and dgsGetType(window.window) == "dgs-dxwindow" then window:updateGridList(list) 
    else
        window = UsersWindow:new(list,columns)
    end

end)
addCommandHandler("crud",function(cmd,player) 
    triggerServerEvent("onClientGetUsers",root,localPlayer)
end)
triggerServerEvent("onClientGetUsers",root,localPlayer)