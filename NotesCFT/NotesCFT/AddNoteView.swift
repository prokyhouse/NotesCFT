//
//  addNoteView.swift
//  addNoteView
//
//  Created by Кирилл Прокофьев on 28.09.2021.
//

import SwiftUI

struct AddNoteView: View {

	@State var noteText: String = ""
	var nbTitle: String = "Новая заметка"

	@Binding var showNoteView: Bool
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
		animation: .default)

	private var notes: FetchedResults<Note>

	var body: some View {
		NavigationView {
			Form {
				TextEditor(text: $noteText)
					.frame(minHeight: 100, idealHeight: 300, maxHeight: .infinity, alignment: .center)
			}
			.navigationBarTitle(nbTitle, displayMode: .inline)
			.toolbar {
				Button("Сохранить") {
					addNote(noteText: noteText)
					self.showNoteView.toggle()
				}
			}
		}
	}

	private func addNote(noteText: String) {
		withAnimation {
			let newNote = Note(context: viewContext)
			newNote.timestamp = Date()
			newNote.text = noteText
			do {
				try viewContext.save()
			} catch {

				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}
