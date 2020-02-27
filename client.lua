
--     Общий список пользователей

--     Добавление нового пользователя:
--     		Имя пользователя
--     		Фамилия пользователя
--     		Адрес проживания

--     Редактирование пользователей

--     Удаление пользователей с всплывающим окном подтверждения

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

local columns = {"ID","FirstName","SecondName","Location"}

loadstring(exports.dgs:dgsImportFunction())()
dgsSetSystemFont("sf.ttf",9,false,"proof")

local listOfUsers = {} 
--Генерация списка, на тот момент пока не реализована бд
for i=0,math.random(1,100) do 
    listOfUsers[i] = {}
    for k,v in pairs(columns) do 
        table.insert(listOfUsers[i], randomString(math.random(0,50)))
    end
end

local window = UsersWindow:new(listOfUsers,columns)