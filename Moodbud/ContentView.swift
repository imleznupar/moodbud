//
//  ContentView.swift
//  Moodbud
//
//  Created by Lulu on 6/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showTabBarView = false
    
    var body: some View {

//        TestView()
        if showTabBarView {
            TabBarView()
        } else {
            StartView(showTabBarView: $showTabBarView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
