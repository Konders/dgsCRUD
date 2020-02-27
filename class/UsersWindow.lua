
UsersWindow = {}
function UsersWindow:new(list,columns)
    local self = {}
    
    self.columns = {}
    function self:initDgsElements()
        self.window = dgsCreateWindow(0.325,0.35,0.35,0.3,"CRUD",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
        dgsWindowSetMovable(self.window,false)
        dgsWindowSetSizable(self.window,false)

        self.closeButton = dgsWindowGetCloseButton(self.window)
        dgsSetProperty(self.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})

        self.gridList = dgsCreateGridList(0,0,1,1,true,self.window)

        for k,v in pairs(columns) do
            local column = dgsGridListAddColumn(self.gridList,v,0.3)
            --last 2 arguments works only with up-to-date version of dgs
            dgsGridListAutoSizeColumn(self.gridList,k,0.5,true)
            table.insert(self.columns,column)
        end
    end
    -- function self:getColumnAVGWidth(columnID,relative)
        --     if not columns[columnID] then return end
        
    --     local totalWidth = 0
    --     --Счетчик пустых строк, поможет правильно настроить работу среднего арифметического ширины столбца
    --     local emptyStringsCounter = 0
    --     for k,v in pairs(list) do 
    --         local rowText = v[columnID] or ""
    --         if string.len(rowText) == 0 then emptyStringsCounter = emptyStringsCounter + 1 end
    --         totalWidth = totalWidth + dxGetTextWidth(rowText,1,dgsGetSystemFont())
    --     end
    --     if relative then 
    --         -- local x,_ = dgsGetSize(self.window)
    --         local screenWidth,screenHeight = guiGetScreenSize()
    --         return (totalWidth/(#list - emptyStringsCounter))/screenWidth
    --     end
    --     return totalWidth/(#list - emptyStringsCounter)
    -- end
    
    --fill our gridlist with users information
    function self.fillGridList()
        for k,v in pairs(list) do
            -- outputDebugString(v)
            dgsGridListAddRow(self.gridList,0,tostring(k),unpack(v))--unpack(v))
            -- dgsGridListAddRow(self.gridList,0,tostring(k),v["firstName"],v["secondName"],v["location"])
        end
    end
    function self:invokeAddUserWindow(selectedID)
        if self.addUserWindow then self.addUserWindow:destroy() end
        self.addUserWindow = EditUserWindow:new()
        -- local output= dgsGridListGetItemText(self.gridList,selectedID,1)
    end
    function self:initEventHandlers()
        addEventHandler ( "onDgsMouseClickDown",self.gridList,function(button, absoluteX, absoluteY) 
            if button == "right" and source == self.gridList then
                if self.contextMenuWindow then self.contextMenuWindow:destroy() end
                local screenWidth,screenHeight = guiGetScreenSize()
                local relativeX = absoluteX / screenWidth
                local relativeY = absoluteY / screenHeight
                self.contextMenuWindow = ContextMenuWindow:new(relativeX,relativeY,self)
            end
        end)
        addEventHandler( "onDgsMouseDoubleClick", self.gridList, 
            function(button, state, x, y)
                if button == 'left' and state == 'up' and source == self.gridList then
                    local Selected = dgsGridListGetSelectedItem(self.gridList)
                    if Selected ~= -1 then 
                        self:invokeAddUserWindow(Selected)
                    end
                end
            end
        )
        addEventHandler("onDgsDestroy",getRootElement(),function() 
            if source == self.window then 
                if self.addUserWindow then self.addUserWindow:destroy() end
                if self.contextMenuWindow then self.contextMenuWindow:destroy() end
                showCursor(false)
            end
        end)
    end
    self:initDgsElements()
    self:initEventHandlers()
    self:fillGridList()
    showCursor(true)
    setmetatable(self,{})
    self.__index = self
    return self
end