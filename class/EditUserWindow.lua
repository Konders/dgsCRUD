EditUserWindow = {}
function EditUserWindow:new()
    local self = {}
    self.window = dgsCreateWindow(0.525,0.35,0.15,0.3,"Add user",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
    dgsMoveToBack(self.window)
    self.closeButton = dgsWindowGetCloseButton(self.window)
    self.editBoxWidth = 0.8
    dgsSetProperty(self.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})
    self.editBoxes = {
        firstNameEdit = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.25, self.editBoxWidth, 0.1, "", true, self.window),
        secondNameEdit = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.35, self.editBoxWidth, 0.1, "", true, self.window),
        locationEdit = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.45, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit2 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.55, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit3 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.65, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit4 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.75, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit5 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.85, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit6 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.95, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit7 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.105, self.editBoxWidth, 0.1, "", true, self.window),
        -- locationEdit8 = dgsCreateEdit (0.5 - (self.editBoxWidth/2),0.115, self.editBoxWidth, 0.1, "", true, self.window),
    }
    dgsCreateScrollPane(0.85,0,0.15,1, true, self.window)
    dgsEditSetPlaceHolder(self.editBoxes.firstNameEdit,"First Name")
    dgsEditSetPlaceHolder(self.editBoxes.secondNameEdit,"Second Name")
    dgsEditSetPlaceHolder(self.editBoxes.locationEdit,"Location")
    for key,editBox in pairs(self.editBoxes) do 
        dgsSetProperty(editBox,"placeHolderFont",dxCreateFont("sf.ttf",9,false,"antialiased"))--"default")
        dgsSetProperty(editBox,"font",dxCreateFont("sf.ttf",9,false,"antialiased"))--"default")
    end
    dgsMoveTo ( self.window, 0.675,0.35, true, false, "InQuad", 200)
    function self:destroy()
        if dgsGetType(self.window) == "dgs-dxwindow" then 
            dgsCloseWindow(self.window)
        end
        -- self = nil
    end
    setmetatable(self,{})
    self.__index = self
    return self
end