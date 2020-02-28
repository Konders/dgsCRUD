
UsersWindow = {}
function UsersWindow:new(list,columns)
    local obj = {}
    --Список с названиями столбцов из БД
    obj.columnNames = columns
    --Список столбцов конкретно грид-листа
    obj.columns = {}
    --Инициализация всех элементов интерфейса
    function obj:initDgsElements()
        obj.window = dgsCreateWindow(0.325,0.35,0.35,0.3,"CRUD",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
        --Отключаем подвижность и изменение размеров окна
        dgsWindowSetMovable(obj.window,false)
        dgsWindowSetSizable(obj.window,false)

        --Вытягиваем стандартную кнопку закрытия окна, и применяем ей свои стили
        obj.closeButton = dgsWindowGetCloseButton(obj.window)
        dgsSetProperty(obj.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})

        obj.gridList = dgsCreateGridList(0,0,1,1,true,obj.window)

        --Проходимся циклом по названиям столбцов, и добавляем их в грид-лист
        for k,v in pairs(columns) do
            local column = dgsGridListAddColumn(obj.gridList,v,0.3)

            --last 2 arguments works only with up-to-date version of dgs
            --Включаем автоматический расчёт размера столбцов
            dgsGridListAutoSizeColumn(obj.gridList,k,1,true)
            table.insert(obj.columns,column)
        end
    end
    
    --fill our gridlist with users information
    --Заполняем наш гридлист
    function obj:fillGridList(data)
        for k,v in pairs(data) do
            --распаковываем наши столбцы через unpack
            dgsGridListAddRow(obj.gridList,1,unpack(v))
        end
    end
    --Обновляем наш гридлист(очищаем его, и заполняем данными)
    function obj:updateGridList(data)
        dgsGridListClear(obj.gridList)
        obj:fillGridList(data)
    end
    --Вызов окна с добавлением/редактированием пользователя
    function obj:invokeUserManagerWindow(editingID)
        --Если окно такого типа уже существует, то закрываем его
        if obj.additionalUserWindow then obj.additionalUserWindow:destroy() end
        --Создаем новое окно, если передать editingID, то окно будет предназначено для редактирования данных пользователя
        obj.additionalUserWindow = UserManagerWindow:new(obj,editingID or false)

    end
    --Инициализация наших Handler'ов
    function obj:initEventHandlers()
        --Handler на клик мыши, нужен в данной ситуации для создания контекстного меню
        addEventHandler ( "onDgsMouseClickDown",obj.gridList,function(button, absoluteX, absoluteY) 
            --Если клик был правой кнопкой, и юзер кликнул на гридлист, то идём дальше
            if button == "right" and source == obj.gridList then
                --Если контекстное меню уже существует, то удаляем его
                if obj.contextMenuWindow then obj.contextMenuWindow:destroy() end
                --Берём размеры экрана, и расчитываем относительную позицию создания контекстного меню
                local screenWidth,screenHeight = guiGetScreenSize()
                --Расчитываем позицию создания контекстного меню вручную, потому-что этот ивент возвращает нам обычные координаты
                local relativeX = absoluteX / screenWidth
                local relativeY = absoluteY / screenHeight
                --Создаем контекстное меню
                obj.contextMenuWindow = ContextMenuWindow:new(relativeX,relativeY,obj)
            end
        end)
        --Handler на двойное нажатие мыши(В данном случае нужно для быстрого перехода к редактированию пользователя)
        addEventHandler( "onDgsMouseDoubleClick", obj.gridList, 
            function(button, state, x, y)
                --Если кнопка левая и всё еще зажата, а так-же клик был произведен на гридлисте, то идём дальше
                if button == 'left' and state == 'down' and source == obj.gridList then
                    --Берём выбранный элемент из списка(если пользователь не выбрал в гридлисте ряд, то функция вернёт -1)
                    local Selected = dgsGridListGetSelectedItem(self.gridList)
                    --Если у нас есть номер выбранного ряда, то создаем окно редактирования данных
                    if Selected ~= -1 then 
                        obj:invokeUserManagerWindow(Selected)
                    end
                end
            end
        )
        --Handler который сработает тогда - когда наше головное окно закроется
        --Нужен он для того чтобы удалить из памяти все дочерние элементы, и убрать курсор
        addEventHandler("onDgsDestroy",getRootElement(),function() 
            if source == obj.window then 
                if obj.additionalUserWindow then obj.additionalUserWindow:destroy() end
                if obj.contextMenuWindow then obj.contextMenuWindow:destroy() end
                if obj.messageBox then obj.messageBox:destroy() end
                showCursor(false)
            end
        end)
    end
    --Деструктор
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


--Функция для расчёта средней ширины столбца
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