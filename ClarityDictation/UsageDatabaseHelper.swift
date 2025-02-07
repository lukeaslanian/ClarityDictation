import Foundation
import SQLite3

class UsageDatabaseHelper {
    private let dbPath: String = "usage.sqlite"
    private var db: OpaquePointer?

    init() {
        db = openDatabase()
        createTable()
    }

    deinit {
        sqlite3_close(db)
    }

    private func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }

    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Usage(
        ModelName TEXT PRIMARY KEY,
        AudioTime REAL,
        InputTokens INTEGER,
        OutputTokens INTEGER);
        """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Usage table created.")
            } else {
                print("Usage table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    func addUsage(_ usage: UsageModel) {
        let insertStatementString = "INSERT INTO Usage (ModelName, AudioTime, InputTokens, OutputTokens) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, usage.modelName, -1, nil)
            sqlite3_bind_double(insertStatement, 2, usage.audioTime)
            sqlite3_bind_int(insertStatement, 3, Int32(usage.inputTokens))
            sqlite3_bind_int(insertStatement, 4, Int32(usage.outputTokens))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func updateUsage(_ usage: UsageModel) {
        let updateStatementString = "UPDATE Usage SET AudioTime = ?, InputTokens = ?, OutputTokens = ? WHERE ModelName = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_double(updateStatement, 1, usage.audioTime)
            sqlite3_bind_int(updateStatement, 2, Int32(usage.inputTokens))
            sqlite3_bind_int(updateStatement, 3, Int32(usage.outputTokens))
            sqlite3_bind_text(updateStatement, 4, usage.modelName, -1, nil)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteUsage(by modelName: String) {
        let deleteStatementString = "DELETE FROM Usage WHERE ModelName = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, modelName, -1, nil)

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }

    func getAll() -> [UsageModel] {
        let queryStatementString = "SELECT * FROM Usage;"
        var queryStatement: OpaquePointer? = nil
        var usageData: [UsageModel] = []

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let modelName = String(cString: sqlite3_column_text(queryStatement, 0))
                let audioTime = sqlite3_column_double(queryStatement, 1)
                let inputTokens = Int(sqlite3_column_int(queryStatement, 2))
                let outputTokens = Int(sqlite3_column_int(queryStatement, 3))

                usageData.append(UsageModel(modelName: modelName, audioTime: audioTime, inputTokens: inputTokens, outputTokens: outputTokens))
                print("Query Result:")
                print("\(modelName) | \(audioTime) | \(inputTokens) | \(outputTokens)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return usageData
    }

    func reset() {
        let deleteStatementString = "DELETE FROM Usage;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted all rows.")
            } else {
                print("Could not delete all rows.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }

    func getTotalCost() -> Double {
        let queryStatementString = "SELECT ModelName, AudioTime, InputTokens, OutputTokens FROM Usage;"
        var queryStatement: OpaquePointer? = nil
        var totalCost: Double = 0.0

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let modelName = String(cString: sqlite3_column_text(queryStatement, 0))
                let audioTime = sqlite3_column_double(queryStatement, 1)
                let inputTokens = Int(sqlite3_column_int(queryStatement, 2))
                let outputTokens = Int(sqlite3_column_int(queryStatement, 3))

                totalCost += DictateUtils.calcModelCost(modelName: modelName, audioTime: audioTime, inputTokens: inputTokens, outputTokens: outputTokens)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return totalCost
    }
}
