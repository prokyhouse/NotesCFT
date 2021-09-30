//
//  EditNoteView.swift
//  EditNoteView
//
//  Created by Кирилл Прокофьев on 27.09.2021.
//

import SwiftUI
import CoreData

struct EditNoteView: View {

	var nbTitle: String = "Редактирование"

	@ObservedObject var myItem: Note
	@State var noteText: String = ""
	@Binding var editView: Bool

	@Environment(\.managedObjectContext) private var viewContext

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
		animation: .default)
	private var notes: FetchedResults<Note>

	var body: some View {

		VStack {
			Form {
				TextEditor(text: $noteText)
					.frame(minHeight: 100, idealHeight: 300, maxHeight: .infinity, alignment: .center)
			}
			HStack {
				Button("Сохранить изменения") {
					if !noteText.isEmpty {
						myItem.text = noteText
						editNote()
					}
					self.editView.toggle()
				}

				.frame(width: 300, height: 30)
				.foregroundColor(Color.accentColor)

				.cornerRadius(13.0)
				.font(Font.headline.weight(.bold))
			}

			Button("Cкопировать заметку") {
				UIPasteboard.general.string = myItem.text
			}

			.frame(width: 300, height: 35)
			.foregroundColor(Color.gray)
			.cornerRadius(13.0)
			.font(Font.headline.weight(.bold))
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: buttonBack)
		.navigationBarTitle(nbTitle, displayMode: .inline)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Menu {
					Section {
						Button(action: { if !noteText.isEmpty {
							myItem.text = noteText
							editNote()
						} }) {
							Label("Сохранить", systemImage: "square.and.pencil")
						}
						Button(action: { UIPasteboard.general.string = myItem.text }) {
							Label("Скопировать", systemImage: "doc.on.doc")
						}
					}
				}
			label: {
				Label("Настройки", systemImage: "slider.horizontal.3")
			}
			}
		}
	}

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	var buttonBack : some View { Button(action: {
		self.presentationMode.wrappedValue.dismiss()
		if !noteText.isEmpty {
			myItem.text = noteText
			editNote()
		}
	}) {
		HStack {
			Image(systemName: "chevron.backward") // set image here
				.aspectRatio(contentMode: .fit)
				.foregroundColor(.accentColor)
			Text("Назад")
				.foregroundColor(.accentColor)
		}
	}
	}

	private func actionSheet() {
		guard let urlShare = URL(string: noteText) else { return }
		let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
		UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
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

	private func editNote() {
		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}

	private let itemFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		// formatter.timeStyle = .medium
		return formatter
	}()
}

extension Binding {
	func unwrap<Wrapped>() -> Binding<Wrapped>? where Wrapped? == Value {
		guard let value = self.wrappedValue else { return nil }
		return Binding<Wrapped>(
			get: {
				return value
			},
			set: { value in
				self.wrappedValue = value
			}
		)
	}
}
