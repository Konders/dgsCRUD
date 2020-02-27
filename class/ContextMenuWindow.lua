--TODO
--Сделать отельный класс для кнопки
ContextMenuWindow = {}
function ContextMenuWindow:new(x,y,parent)
    local self = {}
    self.window = dgsCreateWindow(x,y,0.1,0.1,"",true,tocolor(255,255,255),0,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,true)
    dgsBringToFront(self.window)
    dgsFocus(self.window)
    local buttonNames = {"Add user","Edit selected user","Delete selected user"}
    --for example 100/3 == 33,333..., now 33,333... * 0.01 = 0,3333 and we have relative offset/height
    local offset = (100 / #buttonNames) * 0.01
    self.buttons = {}
    for k,v in pairs(buttonNames) do 
        self.buttons[k] = dgsCreateButton(0,(k-1) * offset,1,offset,v,true,self.window)
    end
    function self:destroy()
        if dgsGetType(self.window) == "dgs-dxwindow" then 
            dgsCloseWindow(self.window)
        end
    end
    function self:getButtonIDByName(name)
        for k,v in pairs(buttonNames) do 
            if v == name then return k end
        end
        return false
    end
    addEventHandler("onDgsMouseClickDown", self.window, function ( btn,x,y) 
        if btn ~= "left" then return end

        if dgsGetParent(source) ~= self.window then return end
        
        local btnID = self:getButtonIDByName(dgsGetText(source))
        if not btnID then return end

        local Selected = dgsGridListGetSelectedItem(parent.gridList)
        
        if btnID == 1 then
            
            if Selected ~= -1 then 
                parent:invokeAddUserWindow(Selected)
                dgsCloseWindow(self.window)
            end
        elseif btnID == 2 then

        end

    end)
    addEventHandler("onDgsFocus", root, function()
        --Если фокус переносится на обьект который не является контекстным меню, или его дочерними элементами то тогда вызываем деструктор данного окна
        if source ~= self.window and dgsGetParent(source) ~= self.window then 
            self:destroy()
        end
    end)
    addEventHandler("onDgsBlur", self.window, function()
        self:destroy()
    end)
    setmetatable(self,{})
    self.__index = self
    return self
end