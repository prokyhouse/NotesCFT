//
//  Persistence.swift
//  NotesCFT
//
//  Created by Кирилл Прокофьев on 27.09.2021.
//

import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

	static var preview: PersistenceController = {
		let result = PersistenceController(inMemory: true)
		let viewContext = result.container.viewContext
		for _ in 0..<10 {
			let newItem = Note(context: viewContext)
			newItem.timestamp = Date()
		}
		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		return result
	}()

	let container: NSPersistentContainer

	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "NotesCFT")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
	}
}
