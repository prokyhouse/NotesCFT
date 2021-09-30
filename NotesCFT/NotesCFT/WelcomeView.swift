//
//  WelcomeView.swift
//  WelcomeView
//
//  Created by Кирилл Прокофьев on 29.09.2021.
//

import SwiftUI

struct WelcomeView: View {

	@Binding var didnotLaunch: Bool

	var logoName = "startLogo"
	var startButtonLabel = l10n("CONTINUE")
	var title = l10n("WELCOME_TITLE")
	var description = l10n("WELCOME_DESCRIPTION")
	@Environment(\.managedObjectContext) private var viewContext

	var body: some View {
		VStack {
			Image(logoName)
				.padding(20)
				helloBlock
			VStack {

				Button(startButtonLabel) {
					addNote(noteText: l10n("TESTNOTE_TEXT"))
					self.didnotLaunch.toggle()
					opened()
				}
				.frame(minWidth: 60, idealWidth: 160, maxWidth: 327.0, minHeight: 20, idealHeight: 40, maxHeight: 56.0, alignment: .center)
				.foregroundColor(Color.white)
				.background(Color.accentColor)
				.cornerRadius(13.0)
				.font(Font.headline.weight(.bold))
				.padding(20)
			}
		}
		.padding(.top)
	}
	var helloBlock: some View {
		VStack {
			if #available(iOS 14.0, *) {
				Text(title)
					.font(Font.title2.weight(.bold))
					.multilineTextAlignment(.center)
					.lineLimit(1)
					.frame(minWidth: 100, idealWidth: 200, maxWidth: 371, minHeight: 20, idealHeight: 28, maxHeight: 28, alignment: .center)
			} else {
				Text(title)
					.font(Font.title.weight(.bold))
					.multilineTextAlignment(.center)
					.lineLimit(1)
					.frame(minWidth: 100, idealWidth: 200, maxWidth: 371, minHeight: 20, idealHeight: 28, maxHeight: 28, alignment: .center)
			}
			Text(description)
				.font(.body)
				.multilineTextAlignment(.center)
				.foregroundColor(Color(red: 124 / 255, green: 122 / 255, blue: 122 / 255))
				.frame(minWidth: 100, idealWidth: 200, maxWidth: 343, minHeight: 60, idealHeight: 80, maxHeight: 105, alignment: .center)
				.padding(20)
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

private func opened() {
	UserDefaults.standard.set(true, forKey: "didLaunchBefore")
}
