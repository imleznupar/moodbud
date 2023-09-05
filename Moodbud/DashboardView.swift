//
//  DashboardView.swift
//  Moodbud
//
//  Created by Lulu on 6/11/23.
//

import SwiftUI

private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

private func dateConverter(day:Date) -> Date {
    return Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: day))
               , since: day)
}


struct DashboardView: View {
    
    let imageScale = 1
    @State private var decided: String = ""
    @State private var textValue: String = ""
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: [],
                  
//                  predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Calendar.current.startOfDay(for: Date()) as NSDate, Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as NSDate)
                  
//                  predicate: NSPredicate(format: "(date >= %@)", argumentArray: [Calendar.current.startOfDay(for: Date())])
                  
//                  predicate: NSPredicate(format: "(date <= %@)", argumentArray: [dateConverter(day: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!)] )
                  
                  predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [dateConverter(day:Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!), dateConverter(day: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!)])
    
    )
    private var entries: FetchedResults<Entry>
    
    
    
    init() {
        UIScrollView.appearance().bounces = false
        let largeTitleFont = UIFont(name: "Roboto Mono", size: 30)!
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: largeTitleFont]
    }
    
    let buttons = ["Happy", "Sad", "Scared", "Surprised", "Nothing", "Angry"]

    var body: some View {
        if decided != "", entries.count>0 {
            DetailView(mood: decided, decided: $decided, textValue: $textValue, clothes: Int(entries[0].clothes), hairstyle: Int(entries[0].hairstyle), clothesColor: Int(entries[0].clothesColor), hairstyleColor: Int(entries[0].hairstyleColor), currentEntry: entries[0])
            
            let _ = print(type(of:entries[0]))
            
        } else {
            NavigationStack {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(buttons, id: \.self) { buttonTitle in
                                    if buttonTitle != "more" {
                                        NavigationLink(value: buttonTitle) {
                                                Image(buttonTitle)
                                                    .resizable()
                                                    .scaleEffect(3)
                                                    .background(Color("LightGray"))
                                                    .offset(x:20,y:0)
                                                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                                                    .clipShape(Circle().size(width: 100, height: 100).offset(x:50,y:30))
                                        }
                                        .contentShape(Circle().size(width: 100, height: 100).offset(x:50,y:30))
                                    }
                                        
                                }
                            }
                            .padding(.bottom,30)
                                
                        }
                        .background(Color("DarkGray"))
                        .padding(.bottom,86)
                        .padding(.top,10)

                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color("LightGray"))
                .navigationBarTitle("How you feelin'?")
                .navigationDestination(for: String.self) { moodName in
                    DetailView(mood: moodName, decided: $decided,textValue: $textValue, clothes: UserDefaults.standard.integer(forKey: "Clothes"), hairstyle: UserDefaults.standard.integer(forKey: "Hairstyle"), clothesColor: UserDefaults.standard.integer(forKey: "ClothesColor"), hairstyleColor: UserDefaults.standard.integer(forKey: "HairstyleColor"), currentEntry: nil)
                }
                
            }
            .onAppear {
                
                print(entries.count)
                if entries.count > 0
                {
                    decided = entries[0].mood!
                    textValue = entries[0].content!
                } else {
                    decided = ""
                    textValue = ""
                }
            }
        }
    }
}

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    let mood: String
    let clothes: Int
    let hairstyle: Int
    let clothesColor: Int
    let hairstyleColor: Int
    let currentEntry: Optional<Entry>
    
    let imageScale = (UIScreen.main.bounds.height)/300
    let characterLimit = 200
    @Binding private var decided: String
    @Binding private var textValue: String
    @State private var keyboardHeight: CGFloat = 0
    @State private var confirmationShown = false
    
    
    let Clothes:[String] = ["default", "shorts","dress","suit"]
    let Hairstyle:[String] = ["short", "long","mushroom","fuzzy"]
    let ClothesColor:[Color] = [.white,.red,.orange,.yellow,.green,.mint,.cyan,.teal,.blue,.indigo,.purple,.pink,.brown,.gray]
    let HairstyleColor:[Color] = [.black,.brown,.gray,.yellow]


    init(mood: String,decided: Binding<String>,textValue: Binding<String>, clothes: Int, hairstyle: Int, clothesColor: Int, hairstyleColor: Int, currentEntry: Optional<Entry>) {
        self._decided = decided
        self.mood = mood
        self.clothes = clothes
        self.hairstyle = hairstyle
        self.clothesColor = clothesColor
        self.hairstyleColor = hairstyleColor
        self.currentEntry = currentEntry
        self._textValue = textValue
        UIScrollView.appearance().bounces = true

    }

    var body: some View {

        if decided == "" {

            
            VStack (spacing:0){
                Spacer()
                HStack {
                    Text("*changes not saved")
                        .foregroundColor(.secondary)
                        .font(Font.custom("Roboto Mono", size: 15))
//                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .padding(.leading,20)
                    
                    Text("\(textValue.count)/\(characterLimit)")
                        .foregroundColor(textValue.count > characterLimit ? .red : .secondary)
                        .font(Font.custom("Roboto Mono", size: 15))
                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .padding(.trailing,20)
                }
                
                
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textValue)
                        .padding()
                        .font(Font.custom("Roboto Mono", size: 20))
                        .onChange(of: textValue) { newValue in
                            if newValue.count > characterLimit {
                                textValue = String(newValue.prefix(characterLimit))
                            }
                        }
                    
                    if textValue == "" {
                        Text("Say something...")
                            .font(Font.custom("Roboto Mono", size: 20))
                            .foregroundColor(Color("DarkGray"))
                            .allowsHitTesting(false)
                            .padding(22)
                    }
                    
                }
                

                ZStack {
                    Image("Naked")
                        .resizable()
                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                        .offset(x:-12,y:0)
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                    Image(Clothes[clothes])
                        .resizable()
                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                        .offset(x:-12,y:0)
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                        .colorMultiply(ClothesColor[clothesColor])
                    Image(Hairstyle[hairstyle])
                        .resizable()
                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                        .offset(x:-12,y:0)
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                        .colorMultiply(HairstyleColor[hairstyleColor])

                    Image(mood)
                        .resizable()
                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                        .offset(x:-12,y:0)
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                }
                .background(Color("DarkGray"))
                
                Rectangle()
                    .frame(height: 86)
                    .foregroundColor(Color("LightGray"))
                
            }
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color("LightGray"))
            .toolbar {
                ToolbarItem() {
                    Button {
                        decided = mood
                        addEntry()
                    } label: {
                        Text("Done")
                            .font(Font.custom("Roboto Mono", size: 30))
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                        Button {
                            hideKeyboard()
                        } label: {
                            Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                        }
                    }

            }
            
        } else {
            ZStack (alignment: .topTrailing) {
                VStack (spacing:0){
                    Spacer()
                    
                    Text("Today\nI'm feelin'...")
                        .font(Font.custom("Roboto Mono", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if textValue != "" {
                        Divider()
                            .frame(height: 2)
                            .overlay(Color("DarkGray"))
                            .padding(.horizontal)
                        ScrollView {
                            Text(textValue)
                                .font(Font.custom("Roboto Mono", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .background(Color("LightGray"))
                    }

                                  
                    ZStack {
                        Image("Naked")
                            .resizable()
                            .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                            .offset(x:-12,y:0)
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                        Image(Clothes[clothes])
                            .resizable()
                            .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                            .offset(x:-12,y:0)
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                            .colorMultiply(ClothesColor[clothesColor])
                        Image(Hairstyle[hairstyle])
                            .resizable()
                            .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                            .offset(x:-12,y:0)
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                            .colorMultiply(HairstyleColor[hairstyleColor])

                        Image(mood)
                            .resizable()
                            .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                            .offset(x:-12,y:0)
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                        
                    }
                    .background(Color("DarkGray"))

                    Rectangle()
                        .frame(height: 86)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color("LightGray"))
                .navigationBarHidden(true)
                
                HStack {
                    Button(action: {
                        confirmationShown = true
                    }) {
                        Image(systemName: "trash.fill")
                            .font(Font.custom("Roboto Mono", size: 20))
                            .padding(10)
                            .background(Color("DarkGray"))
                    }
                    .alert("Are you sure?", isPresented: $confirmationShown) {
                        Button("OK") {
                            // Handle acknowledgement.
                        }
                        Button("Not OK") {
                            // Handle acknowledgement.
                        }
                        .onAppear()
                        {
                            print("alert appeared")
                        }
                    }
//                    .alert(
//                        "Are you sure?",
//                         isPresented: $confirmationShown
//                    ) {
//                        Button("Cancel", role: .cancel) {
//                            print("cancel")
//                        }
//                        Button("Yes", role: .destructive) {
//                            if currentEntry != nil {
//                                print("yes delete")
//                                print(currentEntry!)
//                                viewContext.delete(currentEntry!)
//                                print("done delete")
//                                saveContext()
//                                print("done save")
//                                decided = ""
//                                textValue = ""
//                            }
//                        }
//                    }
                    
                    Button(action: {
                        print("share")
                    }) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(Font.custom("Roboto Mono", size: 20))
                            .padding(10)
                            .background(Color("DarkGray"))
                    }
                }
                
                .padding()
            }
            
        }
        
    }
    
    private func addEntry()
    {
        let entry = Entry(context: viewContext)
        entry.mood = decided
        entry.content = textValue
        entry.date = Date()
        entry.clothes = Int16(UserDefaults.standard.integer(forKey: "Clothes"))
        entry.hairstyle = Int16(UserDefaults.standard.integer(forKey: "Hairstyle"))
        entry.clothesColor = Int16(UserDefaults.standard.integer(forKey: "ClothesColor"))
        entry.hairstyleColor = Int16(UserDefaults.standard.integer(forKey: "HairstyleColor"))

        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            print("no error occured")
        } catch {
            let error = error as NSError
            print("An error occured: \(error)")
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
