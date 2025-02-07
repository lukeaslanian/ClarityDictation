import Foundation
import SQLite3

class PromptsDatabaseHelper {
    private let dbPath: String = "prompts.sqlite"
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
        CREATE TABLE IF NOT EXISTS Prompt(
        Id TEXT PRIMARY KEY,
        Name TEXT,
        Text TEXT,
        RequiresSelection INTEGER);
        """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Prompt table created.")
            } else {
                print("Prompt table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    func addPrompt(_ prompt: PromptModel) {
        let insertStatementString = "INSERT INTO Prompt (Id, Name, Text, RequiresSelection) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, prompt.id.uuidString, -1, nil)
            sqlite3_bind_text(insertStatement, 2, prompt.name, -1, nil)
            sqlite3_bind_text(insertStatement, 3, prompt.text, -1, nil)
            sqlite3_bind_int(insertStatement, 4, prompt.requiresSelection ? 1 : 0)

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

    func updatePrompt(_ prompt: PromptModel) {
        let updateStatementString = "UPDATE Prompt SET Name = ?, Text = ?, RequiresSelection = ? WHERE Id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, prompt.name, -1, nil)
            sqlite3_bind_text(updateStatement, 2, prompt.text, -1, nil)
            sqlite3_bind_int(updateStatement, 3, prompt.requiresSelection ? 1 : 0)
            sqlite3_bind_text(updateStatement, 4, prompt.id.uuidString, -1, nil)

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

    func deletePrompt(by id: UUID) {
        let deleteStatementString = "DELETE FROM Prompt WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, id.uuidString, -1, nil)

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

    func getAllPrompts() -> [PromptModel] {
        let queryStatementString = "SELECT * FROM Prompt;"
        var queryStatement: OpaquePointer? = nil
        var prompts: [PromptModel] = []

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = UUID(uuidString: String(cString: sqlite3_column_text(queryStatement, 0)))!
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let text = String(cString: sqlite3_column_text(queryStatement, 2))
                let requiresSelection = sqlite3_column_int(queryStatement, 3) != 0

                prompts.append(PromptModel(id: id, name: name, text: text, requiresSelection: requiresSelection))
                print("Query Result:")
                print("\(id) | \(name) | \(text) | \(requiresSelection)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return prompts
    }
}
