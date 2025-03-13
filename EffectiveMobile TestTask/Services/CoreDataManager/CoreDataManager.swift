import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoItemEntity")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveItems(_ items: [ToDoItem]) {
        for item in items {
            let entity = ToDoItemEntity(context: context)
            entity.id = Int16(item.id)
            entity.todo = item.todo
            entity.completed = item.completed
            entity.userId = Int16(item.userId)
        }
        saveContext()
    }
    
    func fetchItems() -> [ToDoItem] {
        let request: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map {
                ToDoItem(
                    id: Int($0.id),
                    todo: $0.todo ?? "",
                    completed: $0.completed,
                    userId: Int($0.userId)
                )
            }
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
    }
    
    func updateItem(_ item: ToDoItem) {
        DispatchQueue.main.async {
            let request: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(item.id)")
            
            do {
                let results = try self.context.fetch(request)
                if let entity = results.first {
                    entity.completed = item.completed
                    entity.todo = item.todo
                    self.saveContext()
                }
            } catch {
                print("Ошибка обновления: \(error)")
            }
        }
    }
    
    func deleteItem(_ item: ToDoItem) {
        let request: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(item.id)")
        
        do {
            let results = try context.fetch(request)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                saveContext()
            }
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }
}
