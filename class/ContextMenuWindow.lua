--TODO
--Сделать отельный класс для кнопки
ContextMenuWindow = {}
function ContextMenuWindow:new(x,y,parent)
    local obj = {}
    obj.window = dgsCreateWindow(x,y,0.1,0.1,"",true,tocolor(255,255,255),0,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,true)
    dgsBringToFront(obj.window)
    dgsFocus(obj.window)
    --need separate class for this shit
    local buttonNames = {"Add user","Edit selected user","Delete selected user"}
    --for example 100/3 == 33,333..., now 33,333... * 0.01 = 0,3333 and we have relative offset/height
    local offset = (100 / #buttonNames) * 0.01
    obj.buttons = {}
    for k,v in pairs(buttonNames) do 
        obj.buttons[k] = dgsCreateButton(0,(k-1) * offset,1,offset,v,true,obj.window)
    end
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end
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

        if dgsGetParent(source) ~= obj.window then return end
        
        local btnID = obj:getButtonIDByName(dgsGetText(source))
        if not btnID then return end

        local Selected = dgsGridListGetSelectedItem(parent.gridList)
        local rowID = dgsGridListGetItemText(parent.gridList,Selected,1)
        if btnID == 1 then
            
            parent:invokeUserManagerWindow()
            dgsCloseWindow(obj.window)
        elseif btnID == 2 then
            if Selected ~= -1 then 
                parent:invokeUserManagerWindow(Selected)
                dgsCloseWindow(obj.window)
            end
        elseif btnID == 3 then
            if Selected ~= -1 then 
                if parent.messageBox then parent.messageBox:destroy() end
                parent.messageBox = MessageBox:new("Do you really want to delete user with id "..rowID.."?",function() triggerServerEvent("onClientDeleteUser",root,localPlayer,rowID) end)
                -- triggerServerEvent("onClientDeleteUser",root,localPlayer,rowID)
                dgsCloseWindow(obj.window)
            end
        end

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
    setmetatable(obj,self)
    self.__index = self
    return obj
end