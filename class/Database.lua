local dbname = "GjbL9VBOuX"
local username = "GjbL9VBOuX"
local password = "*"
local columnNamesSQLQuery = [[
    SELECT `COLUMN_NAME` 
FROM `INFORMATION_SCHEMA`.`COLUMNS` 
WHERE `TABLE_SCHEMA`='GjbL9VBOuX' 
    AND `TABLE_NAME`='users';
]]
local tableSQLQuery = [[
    CREATE TABLE IF NOT EXISTS `GjbL9VBOuX`.`users` ( `id` INT NOT NULL AUTO_INCREMENT , `FirstName` TEXT NOT NULL , `LastName` TEXT NOT NULL , `Location` TEXT NOT NULL , PRIMARY KEY (`id`))
    ]]
local insertSQLQuery = [[
    INSERT INTO `users` (`id`, `FirstName`, `LastName`, `Location`) VALUES (NULL, 'Illya', 'Shchukin', 'Kiev');
]]
local getUsersSQLQuery = [[
    SELECT * FROM `users`
]]

Database = {}
function Database:new()
    local obj = {}
    obj.connection = dbConnect( "mysql", "dbname=GjbL9VBOuX;host=remotemysql.com;charset=utf8", username, password)
    if (not obj.connection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server")
    else
        outputDebugString("Success: Connected to the MySQL database server")
    end

    function obj:query(callback,query,...) 
        dbQuery(callback,{...},obj.connection,query)
    end
    function obj:getUsers(callback,player,columns)
        obj:query(callback,getUsersSQLQuery,player,columns) 
    end
    
    function obj:getColumnNames(callback,player)
        obj:query(callback,columnNamesSQLQuery,player) 
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
        local formatted = {}
        for i,userData in pairs(result) do 
            formatted[i] = {}
            for j,columnName in pairs(columns) do 
                formatted[i][j] = userData[columnName]
            end
        end
        triggerClientEvent(player,"retrieveUsers",player,formatted,columns)
    end
    addEvent("getUsers",true)
    addEventHandler("getUsers",root,function() 
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
