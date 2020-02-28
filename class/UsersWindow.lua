
UsersWindow = {}
function UsersWindow:new(list,columns)
    local obj = {}
    obj.columnNames = columns
    obj.columns = {}
    function obj:initDgsElements()
        obj.window = dgsCreateWindow(0.325,0.35,0.35,0.3,"CRUD",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
        dgsWindowSetMovable(obj.window,false)
        dgsWindowSetSizable(obj.window,false)

        obj.closeButton = dgsWindowGetCloseButton(obj.window)
        dgsSetProperty(obj.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})

        obj.gridList = dgsCreateGridList(0,0,1,1,true,obj.window)

        for k,v in pairs(columns) do
            local column = dgsGridListAddColumn(obj.gridList,v,0.3)
            --last 2 arguments works only with up-to-date version of dgs
            dgsGridListAutoSizeColumn(obj.gridList,k,1,true)
            table.insert(obj.columns,column)
        end
    end
    
    --fill our gridlist with users information
    function obj:fillGridList(data)
        for k,v in pairs(data) do
            dgsGridListAddRow(obj.gridList,1,unpack(v))
        end
    end
    function obj:updateGridList(data)
        dgsGridListClear(obj.gridList)
        obj:fillGridList(data)
    end
    function obj:invokeUserManagerWindow(editingID)
        if obj.additionalUserWindow then obj.additionalUserWindow:destroy() end
        obj.additionalUserWindow = UserManagerWindow:new(obj.columnNames,obj,editingID or false)

    end
    -- function obj:invokeEditUserWindow(selectedID)
    --     if obj.additionalUserWindow then obj.additionalUserWindow:destroy() end
    --     obj.additionalUserWindow = EditUserWindow:new(selectedID,obj)

    -- end
    function obj:initEventHandlers()
        addEventHandler ( "onDgsMouseClickDown",obj.gridList,function(button, absoluteX, absoluteY) 
            if button == "right" and source == obj.gridList then
                if obj.contextMenuWindow then obj.contextMenuWindow:destroy() end
                local screenWidth,screenHeight = guiGetScreenSize()
                local relativeX = absoluteX / screenWidth
                local relativeY = absoluteY / screenHeight
                obj.contextMenuWindow = ContextMenuWindow:new(relativeX,relativeY,obj)
            end
        end)
        addEventHandler( "onDgsMouseDoubleClick", obj.gridList, 
            function(button, state, x, y)
                if button == 'left' and state == 'down' and source == obj.gridList then
                    local Selected = dgsGridListGetSelectedItem(self.gridList)
                    if Selected ~= -1 and type(Selected) == "number" then 
                        obj:invokeUserManagerWindow(Selected)
                    end
                end
            end
        )
        addEventHandler("onDgsDestroy",getRootElement(),function() 
            if source == obj.window then 
                if obj.additionalUserWindow then obj.additionalUserWindow:destroy() end
                if obj.contextMenuWindow then obj.contextMenuWindow:destroy() end
                if obj.messageBox then obj.messageBox:destroy() end
                showCursor(false)
            end
        end)
    end
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end

    end
    obj:initDgsElements()
    obj:initEventHandlers()
    obj:fillGridList(list)
    showCursor(true)
    setmetatable(obj,self)
    self.__index = self
    return obj
end

-- function obj:getColumnAVGWidth(columnID,relative)
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
    --         -- local x,_ = dgsGetSize(obj.window)
    --         local screenWidth,screenHeight = guiGetScreenSize()
    --         return (totalWidth/(#list - emptyStringsCounter))/screenWidth
    --     end
    --     return totalWidth/(#list - emptyStringsCounter)
    -- end