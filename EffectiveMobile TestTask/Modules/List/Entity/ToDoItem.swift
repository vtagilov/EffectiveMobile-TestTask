struct ToDoItem: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    
    var description: String {
        "Задача: \n\(todo)\nСделано: \(completed ? "да" : "нет")"
    }
}
