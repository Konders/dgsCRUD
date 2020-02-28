--TODO
--Сделать отельный класс для кнопки
--Отрефакторить всё это дело

ContextMenuWindow = {}
--Конструктор контекстного меню
function ContextMenuWindow:new(x,y,parent)
    local obj = {}
    obj.window = dgsCreateWindow(x,y,0.1,0.1,"",true,tocolor(255,255,255),0,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,true)
    --Вытягиваем окно наперёд
    dgsBringToFront(obj.window)
    --Принудительно ставим фокус на окно
    dgsFocus(obj.window)
    --need separate class for this shit
    local buttonNames = {"Add user","Edit selected user","Delete selected user"}
    --Переменная для расчета смещения и размера кнопок
    --for example 100/3 == 33,333..., now 33,333... * 0.01 = 0,3333 and we have relative offset/height
    local offset = (100 / #buttonNames) * 0.01
    obj.buttons = {}
    for k,v in pairs(buttonNames) do 
        obj.buttons[k] = dgsCreateButton(0,(k-1) * offset,1,offset,v,true,obj.window)
    end
    function obj:getButtonIDByName(name)
        for k,v in pairs(buttonNames) do 
            if v == name then return k end
        end
        return false
    end
    --need refactoring
    addEventHandler("onDgsMouseClickUp", obj.window, function ( btn,x,y) 
        if btn ~= "left" then return end
        --Проверяем является ли кнопка элементом нашего окна, и только в том случае выполняем функцию дальше
        if dgsGetParent(source) ~= obj.window then return end
        
        local btnID = obj:getButtonIDByName(dgsGetText(source))
        if not btnID then return end

        --Вытягиваем айди ряда
        local Selected = dgsGridListGetSelectedItem(parent.gridList)
        --Вытягиваем айди юзера
        local rowID = dgsGridListGetItemText(parent.gridList,Selected,1)
        --добавление юзера
        if btnID == 1 then
            
            parent:invokeUserManagerWindow()
            --Редактирование юзера
        elseif btnID == 2 then
            if Selected ~= -1 then 
                parent:invokeUserManagerWindow(Selected)
            end
            --Удаление юзера
        elseif btnID == 3 then
            if Selected ~= -1 then 
                --Если messageBox уже существует, то закрываем его
                if parent.messageBox then parent.messageBox:destroy() end
                --Создание нового messagebox'а
                --Передаём в него текст который нам нужен, и callback функцию
                parent.messageBox = MessageBox:new("Do you really want to delete user with id "..rowID.."?",function() triggerServerEvent("onClientDeleteUser",root,localPlayer,rowID) end)
            end
        end
        --Закрываем контекстное меню
        dgsCloseWindow(obj.window)

    end)
    addEventHandler("onDgsFocus", root, function()
        --Если фокус переносится на обьект который не является контекстным меню, или его дочерними элементами то тогда вызываем деструктор данного окна
        if source ~= obj.window and dgsGetParent(source) ~= obj.window then 
            obj:destroy()
        end
    end)
    addEventHandler("onDgsBlur", obj.window, function()
        obj:destroy()
    end)
    --Деструктор
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end
    end

    setmetatable(obj,self)
    self.__index = self
    return obj
end