UserManagerWindow = {}
--Конструктор менеджера данных пользователя
--Если в функцию будет передан аргумент editingID, то окно преобразится в редактирование данных
--Если этого аргумента не будет, то это будет окно для добавления нового пользователя
function UserManagerWindow:new(parent,editingID)
    local obj = {}
    --Инициализация всех элементов интерфейса
    function obj:initDgsElements()
        obj.window = dgsCreateWindow(0.525,0.35,0.15,0.3,"User Manager",true,tocolor(255,255,255),20,nil,tocolor(60,72,84),nil,tocolor(60,72,84),5,false)
        --Прячем окно на задний план, чтобы из-под основного окна можно было высунуть анимацией это окно
        dgsMoveToBack(obj.window)

        --Вытягиваем стандартную кнопку закрытия окна, и применяем ей свои стили
        obj.closeButton = dgsWindowGetCloseButton(obj.window)
        dgsSetProperty(obj.closeButton,"color",{tocolor(60,72,84),tocolor(48,58,67),tocolor(38,46,54)})

        --Создание панельки с скроллбаром
        --Она нам нужна из-за того что у нас количество редактируемых элементов может быть заданно в любом количестве
        --так как эти элементы динамически создаются в зависимости от количества столбцов таблицы в БД
        obj.scrollPane = dgsCreateScrollPane(0,0,1,1,true,obj.window)
        --Задаём ширину скроллбара, по умолчанию он будет слишком большим
        dgsSetProperty(obj.scrollPane,"scrollBarThick",5)

        --Ширина полей для редактирования и кнопок
        obj.editBoxWidth = 0.8
        --Инициализируем переменную которая будет хранить в себе список всех полей
        obj.editBoxes = {}
    end
    --Инициализация наших полей
    --Создадутся поля такие-же как и столбцы с таблицы БД
    function obj:initDynamicColumns()
        for columnID,columnName in pairs(parent.columnNames) do
            --Игнорируем создание поля для ID
            if columnName ~= "id" then
            --Создаём поле в нашей панельке скролла
            obj.editBoxes[columnID] = dgsCreateEdit(0.5-(obj.editBoxWidth)/2,columnID*0.11,obj.editBoxWidth,0.1,"",true,obj.scrollPane)
            --Задаём подсказку для поля(текст который пропадёт при вводе)
            dgsEditSetPlaceHolder(obj.editBoxes[columnID],columnName)
            --Задаём шрифты
            dgsSetProperty(obj.editBoxes[columnID],"placeHolderFont",dxCreateFont("sf.ttf",9,false,"antialiased"))
            dgsSetProperty(obj.editBoxes[columnID],"font",dxCreateFont("sf.ttf",9,false,"antialiased"))
            --Если есть аргумент выделенного ряда, то делаем автозаполнение полей нужными данными(режим редактирования)
            if editingID then
                local columnText = dgsGridListGetItemText(parent.gridList,editingID,columnID)
                if columnText then
                    dgsSetText(obj.editBoxes[columnID],columnText)
                end
            end
            end
        end
        obj.addButton = dgsCreateButton(0.5 - (obj.editBoxWidth/2),(#obj.editBoxes + 1) * 0.11, obj.editBoxWidth,0.1,"Insert", true,obj.scrollPane)
        --Если включён режим редактирования, меняем название кнопки
        if editingID then dgsSetText(obj.addButton,"Save") end
    end
    --Инициализация хендлеров событий
    function obj:initEventHandlers()
        --Событие на клик
        addEventHandler("onDgsMouseClickUp",obj.addButton,function(button, absoluteX, absoluteY) 
            --Если клик был на нашу кнопку, и левым нажатием мыши, то идём дальше
            if source ~= obj.addButton or button ~= "left" then return end
            --Список данных вытянутый с полей
            local dataList = {}
            --Проходимся по всем нашим полям, вытягиваем их текст и вносим в наш список
            for i,editBox in pairs(obj.editBoxes) do 
                table.insert(dataList,dgsGetText(editBox))
            end
            
            --Если включен режим редактирования, вытягиваем идентификатор ряда в бд, и триггерим событие для апдейта юзера
            if editingID then 
                local databaseRowID = dgsGridListGetItemText(parent.gridList, editingID,1)
                triggerServerEvent("onClientUpdateUser",root,localPlayer,databaseRowID,unpack(dataList))
            else
                --Если стоит стандартный режим добавления юзера, то мы unpack'аем наши данные из полей и триггерим вставку нового юзера
                triggerServerEvent("onClientInsertUser",root,localPlayer,unpack(dataList))
            end
        end)
    end
    --Инициализация анимаций
    function obj:startAnimations()
        dgsMoveTo ( obj.window, 0.675,0.35, true, false, "InQuad", 200)
    end
    --Деструктор
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