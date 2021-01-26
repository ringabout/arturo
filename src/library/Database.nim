######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: library/Database.nim
######################################################

#=======================================
# Methods
#=======================================

builtin "close",
    alias       = unaliased, 
    description = "close given database",
    args        = {
        "database"  : {Database}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
    """:
        ##########################################################
        if x.dbKind == SqliteDatabase:
            closeSqliteDb(x.sqlitedb)
        # elif x.dbKind == MysqlDatabase:
        #     closeMysqlDb(x.mysqldb)

builtin "query",
    alias       = unaliased, 
    description = "execute command or block of commands in given database and get returned rows",
    args        = {
        "database"  : {Database},
        "commands"  : {String,Block}
    },
    attrs       = {
        "id"    : ({Boolean},"return last INSERT id")
    },
    returns     = {Integer,Block,Null},
    example     = """
    """:
        ##########################################################
        if x.dbKind == SqliteDatabase:
            if y.kind == String:
                if (let got = execSqliteDb(x.sqlitedb, y.s); got[0]==ValidQueryResult):
                    stack.push(newBlock(got[1]))
            else:
                if (let got = execManySqliteDb(x.sqlitedb, y.a.map(proc (v:Value):string = v.s)); got[0]==ValidQueryResult):
                    stack.push(newBlock(got[1]))
            
            if (popAttr("id") != VNULL):
                stack.push(newInteger(getLastIdSqliteDb(x.sqlitedb)))

        # elif x.dbKind == MysqlDatabase:
        #     execMysqlDb(x.mysqldb, y.s)

builtin "open",
    alias       = unaliased, 
    description = "opens a new database connection and returns database",
    args        = {
        "name"  : {String}
    },
    attrs       = {
        "sqlite": ({Boolean},"support for SQLite databases"),
        "mysql" : ({Boolean},"support for MySQL databases")
    },
    returns     = {Integer},
    example     = """
    """:
        ##########################################################
        var dbKind = SqliteDatabase

        if (popAttr("mysql") != VNULL):
            dbKind = MysqlDatabase

        let dbName = x.s

        if dbKind == SqliteDatabase:
            stack.push(newDatabase(openSqliteDb(dbName)))
        # elif dbKind == MysqlDatabase:
        #     stack.push(newDatabase(openMysqlDb(dbName)))
