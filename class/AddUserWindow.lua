AddUserWindow = {}
function AddUserWindow:new()
    local obj = {}
    obj.window = dgsCreateWindow(0.525,0.35,0.15,0.3,"Add user",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
    dgsMoveToBack(obj.window)
    obj.closeButton = dgsWindowGetCloseButton(obj.window)
    obj.editBoxWidth = 0.8
    dgsSetProperty(obj.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})
    obj.editBoxes = {
        firstNameEdit = dgsCreateEdit (0.5 - (obj.editBoxWidth/2),0.25, obj.editBoxWidth, 0.1, "", true, obj.window),
        secondNameEdit = dgsCreateEdit (0.5 - (obj.editBoxWidth/2),0.35, obj.editBoxWidth, 0.1, "", true, obj.window),
        locationEdit = dgsCreateEdit (0.5 - (obj.editBoxWidth/2),0.45, obj.editBoxWidth, 0.1, "", true, obj.window),
    }
    obj.addButton = dgsCreateButton(0.5 - (obj.editBoxWidth/2),0.55, obj.editBoxWidth,0.1,"Insert", true,obj.window)
    dgsEditSetPlaceHolder(obj.editBoxes.firstNameEdit,"First Name")
    dgsEditSetPlaceHolder(obj.editBoxes.secondNameEdit,"Second Name")
    dgsEditSetPlaceHolder(obj.editBoxes.locationEdit,"Location")
    for key,editBox in pairs(obj.editBoxes) do 
        dgsSetProperty(editBox,"placeHolderFont",dxCreateFont("sf.ttf",9,false,"antialiased"))--"default")
        dgsSetProperty(editBox,"font",dxCreateFont("sf.ttf",9,false,"antialiased"))--"default")
    end
    dgsMoveTo ( obj.window, 0.675,0.35, true, false, "InQuad", 200)
    
    addEventHandler("onDgsMouseClickUp",obj.addButton,function(button, absoluteX, absoluteY) 
        if source ~= obj.addButton or button ~= "left" then return end
        local firstName = dgsGetText(obj.editBoxes.firstNameEdit)
        local lastName = dgsGetText(obj.editBoxes.secondNameEdit)
        local location = dgsGetText(obj.editBoxes.locationEdit)
        -- outputDebugString("firstName: "..firstName.." ;lastName: "..lastName.." ;location: "..location)
        triggerServerEvent("onClientInsertUser",root,localPlayer,firstName,lastName,location)
    end)
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end
    end
    setmetatable(obj,self)
    self.__index = self
    return obj
end