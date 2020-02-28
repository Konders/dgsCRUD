
--     Общий список пользователей

--     Добавление нового пользователя:
--     		Имя пользователя
--     		Фамилия пользователя
--     		Адрес проживания

--     Редактирование пользователей

--     Удаление пользователей с всплывающим окном подтверждения

--Импортируем dgs
loadstring(exports.dgs:dgsImportFunction())()
--Ставим стандартный шрифт
dgsSetSystemFont("sf.ttf",9,false,"proof")

local window 
addEvent("retrieveUsers",true)
--Handler который выдает нам список игроков, и названия столбцов
addEventHandler("retrieveUsers",localPlayer,function(list,columns) 
    --Проверка на то, существует ли окно
    if window and dgsGetType(window.window) == "dgs-dxwindow" then 
        --Заполняем грид-лист нашими игроками
        window:updateGridList(list) 
    else
        --Если окно не существует, то создаем новое и заполняем его игроками
        window = UsersWindow:new(list,columns)
    end
end)
--Команда для того чтобы открыть/обновнить окно
addCommandHandler("crud",function(cmd,player) 
    triggerServerEvent("onClientGetUsers",root,localPlayer)
end)
--По умолчанию при запуске ресурса запустим окно
triggerServerEvent("onClientGetUsers",root,localPlayer)