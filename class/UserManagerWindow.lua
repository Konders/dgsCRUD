UserManagerWindow = {}
function UserManagerWindow:new(columns,parent,editingID)
    local obj = {}
    function obj:initDgsElements()
        obj.window = dgsCreateWindow(0.525,0.35,0.15,0.3,"User Manager",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
        dgsMoveToBack(obj.window)
        obj.closeButton = dgsWindowGetCloseButton(obj.window)

        
        obj.scrollPane = dgsCreateScrollPane(0,0,1,1,true,obj.window)
        dgsSetProperty(obj.scrollPane,"scrollBarThick",5)
        dgsSetProperty(obj.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})

        obj.editBoxWidth = 0.8
        obj.editBoxes = {}
    end
    function obj:initDynamicColumns()
        for columnID,columnName in pairs(columns) do
            if columnName ~= "id" then
            obj.editBoxes[columnID] = dgsCreateEdit(0.5-(obj.editBoxWidth)/2,columnID*0.11,obj.editBoxWidth,0.1,"",true,obj.scrollPane)
            dgsEditSetPlaceHolder(obj.editBoxes[columnID],columnName)
            dgsSetProperty(obj.editBoxes[columnID],"placeHolderFont",dxCreateFont("sf.ttf",9,false,"antialiased"))
            dgsSetProperty(obj.editBoxes[columnID],"font",dxCreateFont("sf.ttf",9,false,"antialiased"))
            if editingID then
                local columnText = dgsGridListGetItemText(parent.gridList,editingID,columnID)
                if columnText then
                    dgsSetText(obj.editBoxes[columnID],columnText)
                end
            end
            end
        end
        obj.addButton = dgsCreateButton(0.5 - (obj.editBoxWidth/2),(#obj.editBoxes + 1) * 0.11, obj.editBoxWidth,0.1,"Insert", true,obj.scrollPane)
        if editingID then dgsSetText(obj.addButton,"Save") end
    end
    function obj:initEventHandlers()
        addEventHandler("onDgsMouseClickUp",obj.addButton,function(button, absoluteX, absoluteY) 
            if source ~= obj.addButton or button ~= "left" then return end
            local dataList = {}
            for i,editBox in pairs(obj.editBoxes) do 
                table.insert(dataList,dgsGetText(editBox))
            end
            
            if editingID then 
                local databaseRowID = dgsGridListGetItemText(parent.gridList, editingID,1)
                triggerServerEvent("onClientUpdateUser",root,localPlayer,databaseRowID,unpack(dataList))
            else
                triggerServerEvent("onClientInsertUser",root,localPlayer,unpack(dataList))
            end
        end)
    end
    function obj:startAnimations()
        dgsMoveTo ( obj.window, 0.675,0.35, true, false, "InQuad", 200)
    end
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end
    end
    
    obj:initDgsElements()
    obj:initDynamicColumns()
    obj:initEventHandlers()
    obj:startAnimations()

    setmetatable(obj,self)
    self.__index = self
    return obj
end