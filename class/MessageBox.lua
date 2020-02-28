MessageBox = {}
function MessageBox:new(text,callback)
    local obj = {}
    obj.window = dgsCreateWindow(0.4,0.425,0.2,0.15,"Confirmation",true,tocolor(255,255,255),0,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,true)
    --Задаём самый большой приоритет по отрисовке среди элементов
    dgsSetLayer (obj.window,"top")

    obj.label = dgsCreateLabel(0.2,0.2,0.5,0.1,text,true,obj.window)
    obj.positiveButton = dgsCreateButton(0.25,0.45, 0.5,0.1,"Yes", true,obj.window)
    obj.negativeButton = dgsCreateButton(0.25,0.6, 0.5,0.1,"No", true,obj.window)
    --Наша callback' функция
    obj.callback = callback
    
    addEventHandler("onDgsMouseClickUp",obj.window,function(button, absoluteX, absoluteY) 
        if source ~= obj.positiveButton and source ~= obj.negativeButton then return end
            if source == obj.positiveButton then
                --Если мы кликнули на подтверждение, и наша callback функция существует, то вызываем её
                if obj.callback then 
                    obj.callback()
                end
            end
            --При клике на любую кнопку с реакцией(да,нет), окно уничтожается
            obj:destroy()

    end)
    --деструктор
    function obj:destroy()
        if dgsGetType(obj.window) == "dgs-dxwindow" then 
            dgsCloseWindow(obj.window)
        end
    end
    setmetatable(obj,self)
    self.__index = self
    return obj
end