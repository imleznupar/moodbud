//
//  TestView.swift
//  Moodbud
//
//  Created by Lulu on 6/23/23.
//

import SwiftUI


struct TestView: View {
    
    @State var mood: String = ""
    @State var content: String = ""
//    @State var image: Transformable = ""
//    @State var date: Date =
        
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: [])
    private var entries: FetchedResults<Entry>
    
    



    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Product name", text: $mood)
                TextField("Product quantity", text: $content)
                
                HStack {
                    Spacer()
                    Button("Add") {
                        addProduct()
                    }
                    Spacer()
                    Button("Clear") {
                        mood = "Sad"
                        content = "plz stop crashing"
                    }
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                List {
                    ForEach(entries, id: \.self) { entity in
                        Text(entity.mood ?? "no mood")
                        Text(entity.content ?? "no content")
                        Text("\(entity.hairstyle)")
                        Text("\(entity.clothes)")
//                        let _ = print("test view \(entity.date!)" ?? "no date")
                    }
                    .onDelete(perform: removeLanguages)

                }
                
//                List(entries, id: \.self) { entity in
//                    Text(entity.mood ?? "no mood")
//                    Text(entity.content ?? "no content")
//                    let _ = print(entity.date)
//                    let _ = print(entity.image)
//                    let _ = print("")
//                }
                .background(.blue)
            }
        }
    }
    
    private func removeLanguages(at offsets: IndexSet) {
        print("remove entry")

        for index in offsets {
            let entry = entries[index]
            print(type(of: entry))
            viewContext.delete(entry)
            saveContext()
        }
    }

    
    private func addProduct() {
        withAnimation {
            let entry = Entry(context: viewContext)
            entry.mood = mood
            entry.content = content
            
//            let dateFormat = DateFormatter()
//            dateFormat.dateFormat = "yyyy-MM-dd"
//            let formattedDate = dateFormat.string(from: )
            
            entry.date = Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: Date()))
                              , since: Date())

            
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            print("An error occured: \(error)")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    
    static var previews: some View {
        TestView()
//            .environment(\.managedObjectContext, managedObjectContext)
    }
}
