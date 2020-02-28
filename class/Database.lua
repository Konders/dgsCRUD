local dbname = "GjbL9VBOuX"
local username = "GjbL9VBOuX"
local password = "Kj6Pytyuze"
local columnNamesSQLQuery = [[
    SELECT `COLUMN_NAME` 
    FROM `INFORMATION_SCHEMA`.`COLUMNS` 
    WHERE `TABLE_SCHEMA`=']]..dbname..[[' 
    AND `TABLE_NAME`='users';
]]
local tableSQLQuery = [[
    CREATE TABLE IF NOT EXISTS `]]..dbname..[[`.`users` ( `id` INT NOT NULL AUTO_INCREMENT , `FirstName` TEXT NOT NULL , `LastName` TEXT NOT NULL , `Location` TEXT NOT NULL , PRIMARY KEY (`id`))
    ]]
local insertSQLQuery = "INSERT INTO `users` (`id`, `FirstName`, `LastName`, `Location`) VALUES (NULL, ?, ?, ?)"

local getUsersSQLQuery = [[
    SELECT * FROM `users`
]]

Database = {}
function Database:new()
    local obj = {}
    obj.connection = dbConnect( "mysql", "dbname="..dbname..";host=remotemysql.com;charset=utf8", username, password)
    if (not obj.connection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server")
    else
        outputDebugString("Success: Connected to the MySQL database server")
    end

    dbExec(obj.connection,tableSQLQuery)
    function obj:query(callback,query,...) 
        dbQuery(callback,{...},obj.connection,query)
    end
    function obj:insert(query,...)
        local readyQuery = dbPrepareString(obj.connection,query,...)
        dbExec(obj.connection,readyQuery)
    end
    function obj:insertUser(firstName,lastName,location)
        obj:insert(insertSQLQuery,firstName,lastName,location)
    end
    function obj:getUsers(callback,player,columns)
        obj:query(callback,getUsersSQLQuery,player,columns) 
    end
    
    function obj:getColumnNames(callback,player)
        obj:query(callback,columnNamesSQLQuery,player) 
    end
    function obj:updateUser(id,firstName,lastName,location)
        local query = dbPrepareString(obj.connection,"UPDATE `users` SET `FirstName`=?,`LastName`=?,`Location`=? WHERE `id` = ?", firstName, lastName, location,id)
        dbExec( obj.connection, query )
    end
    function obj:deleteUser(id)
        local query = dbPrepareString(obj.connection,"DELETE FROM `users` WHERE `id` = ?", id)
        dbExec( obj.connection, query )
    end
    
    obj.columnNamesCallback = function(queryHandler,player) 
        local result = dbPoll( queryHandler, 0 )
            --result = {
            --     [1]={["COLUMN_NAME"] = "id"},
            --     [2]={["COLUMN_NAME"] = "FirstName"},
            --     [3]={["COLUMN_NAME"] = "LastName"},
            --     [4]={["COLUMN_NAME"] = "Location"},
            -- }
        for k,v in pairs(result) do 
            result[k] = result[k].COLUMN_NAME
        end
        obj:getUsers(obj.usersCallback,player,result)
    end
    obj.usersCallback = function(queryHandler,player,columns) 
        local result = dbPoll( queryHandler, 0 )
            --result = {
            --     [1]={
            --         ["FirstName"] = "Illya",
            --         ["Location"] = "Kiev",
            --         ["LastName"] = "Shchukin",
            --         ["id"] = "1",
            --     },
            -- }
        if not columns then return end
        local formatted = {}
        for i,userData in pairs(result) do 
            formatted[i] = {}
            for j,columnName in pairs(columns) do 
                formatted[i][j] = userData[columnName]
            end
        end
        triggerClientEvent(player,"retrieveUsers",player,formatted,columns)
    end
    addEvent("onClientGetUsers",true)
    addEvent("onClientInsertUser",true)
    addEvent("onClientUpdateUser",true)
    addEvent("onClientDeleteUser",true)
    addEventHandler("onClientGetUsers",root,function() 
        obj:getColumnNames(obj.columnNamesCallback,client)
    end)
    addEventHandler("onClientInsertUser",root,function(_,firstName,lastName,location)
        obj:insertUser(firstName,lastName,location)
        obj:getColumnNames(obj.columnNamesCallback,client)
    end)
    addEventHandler("onClientUpdateUser",root,function(_,id,firstName,lastName,location) 
        obj:updateUser(id,firstName,lastName,location)
        obj:getColumnNames(obj.columnNamesCallback,client)
    end)
    addEventHandler("onClientDeleteUser",root,function(_,id) 
        obj:deleteUser(id)
        obj:getColumnNames(obj.columnNamesCallback,client)
    end)
    setmetatable(obj,self)
    self.__index = self
    return obj
end
function execute(...)
    local queryHandle = dbQuery(DBConnection, ...)
    local result, numRows = dbPoll(queryHandle, -1)
    return numRows
end
local DB = Database:new()
