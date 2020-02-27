local dbname = "GjbL9VBOuX"
local username = "GjbL9VBOuX"
local password = "****"
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
    local self = {}
    self.connection = dbConnect( "mysql", "dbname=GjbL9VBOuX;host=remotemysql.com;charset=utf8", username, password)
    if (not self.connection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server")
    else
        outputDebugString("Success: Connected to the MySQL database server")
    end

    function self.query(callback,query) 
        dbQuery(callback,self.connection,query)
    end

    function self.columnNamesCallback(queryHandler) 
        local result = dbPoll( queryHandler, 0 )

        -- {
        --     [1]={["COLUMN_NAME"] = "id"},
        --     [2]={["COLUMN_NAME"] = "FirstName"},
        --     [3]={["COLUMN_NAME"] = "LastName"},
        --     [4]={["COLUMN_NAME"] = "Location"},
        -- }
        for k,v in pairs(result) do 
            result[k] = result[k].COLUMN_NAME

        end
    end
    -- function self.usersCallback(queryHandler,executeFunction) 
    --     local result = dbPoll( queryHandler, 0 )
    --     -- {
    --     --     [1]={
    --     --         ["FirstName"] = "Illya",
    --     --         ["Location"] = "Kiev",
    --     --         ["LastName"] = "Shchukin",
    --     --         ["id"] = "1",
    --     --     },
    --     -- }
    --     for k,v in pairs(result) do 
    --         outputDebugString(k..": "..tostring(v))
    --         -- result[k] = result[k].COLUMN_NAME

    --     end
    --     if executeFunction then executeFunction() end
    -- end
    function self.getUsers(callback)
        self:query(callback,getUsersSQLQuery) 
    end

    function self:getColumnNames(callback)
        self:query(callback,columnNamesSQLQuery) 
    end
    setmetatable(self,{})
    self.__index = self
    return self
end
function execute(...)
    local queryHandle = dbQuery(DBConnection, ...)
    local result, numRows = dbPoll(queryHandle, -1)
    return numRows
end

local db= Database:new()
-- db:getColumnNames()
function us(queryHandler) 
    local result = dbPoll( queryHandler, 0 )
    outputDebugString("GOTTA")
end
db:getUsers(us)