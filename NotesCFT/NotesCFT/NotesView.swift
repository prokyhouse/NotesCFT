//
//  NotesView.swift
//  NotesView
//
//  Created by Кирилл Прокофьев on 29.09.2021.
//

import SwiftUI

struct NotesView: View {

	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
		animation: .default)

	private var notes: FetchedResults<Note>
	@State var showNoteView = false
	@State var editView = false

	var body: some View {
		NavigationView {
			List {
				ForEach(notes, id: \.self) { item in
					NavigationLink(destination: EditNoteView(myItem: item, noteText: item.text!, editView: $editView)) {
						VStack(alignment: .leading) {
							if !(item.text!.isEmpty) {
							Text(item.text ?? l10n("NO TEXT"))
								.lineLimit(2)
							} else {
							Text(l10n("NO TEXT"))
								.lineLimit(2)
								.foregroundColor(Color.gray)
							}
							Text("\(item.timestamp!, formatter: itemFormatter)").font(.caption)
								.lineLimit(1)
								.foregroundColor(Color.gray)
						}
					}
				}
				.onDelete(perform: deleteNote)
			}
			.navigationBarTitle(Text(l10n("APP_TITLE")))
			.navigationBarItems(trailing:
									Button(action: { self.showNoteView.toggle()
			}) {
				Label(l10n("ADD"), systemImage: "plus")
			}
			)
			.toolbar {
				EditButton()
			}
		}.sheet(isPresented: $showNoteView) {
			AddNoteView(showNoteView: $showNoteView)
		}
	}

	private func deleteNote(offsets: IndexSet) {
		withAnimation {
			offsets.map { notes[$0] }.forEach(viewContext.delete)
			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}

private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()
