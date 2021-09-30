//
//  ContentView.swift
//  NotesCFT
//
//  Created by Кирилл Прокофьев on 27.09.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {

	@State var didnotLaunch: Bool = !UserDefaults.standard.bool(forKey: "didLaunchBefore")

	@ViewBuilder
	var body: some View {
		VStack {
			NotesView()
		}.sheet(isPresented: $didnotLaunch) {
			WelcomeView(didnotLaunch: $didnotLaunch)
		}
	}
}
