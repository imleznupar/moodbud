//
//  AvatarView.swift
//  Moodbud
//
//  Created by Lulu on 6/11/23.
//

import SwiftUI

enum Styles : String, CaseIterable {
    case clothes = "Clothes"
    case hairstyle = "Hairstyle"
}


struct AvatarView: View {

    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([:], for: .normal)
        UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "LightGray")
        UserDefaults.standard.register(defaults: ["Clothes": 0])
        UserDefaults.standard.register(defaults: ["Hairstyle": 0])
        UserDefaults.standard.register(defaults: ["ClothesColor": 0])
        UserDefaults.standard.register(defaults: ["HairstyleColor": 0])
    }
    
    let imageScale = (UIScreen.main.bounds.height)/270
    @State var segmentationSelection : Styles = .clothes
    @State private var showPopover = false


    @State private var currentIndex: Int = UserDefaults.standard.integer(forKey: "Clothes")
    @State private var currentColorIndex: Int = UserDefaults.standard.integer(forKey: "ClothesColor")
    

    let lists: [String: [String]] = [
        "Clothes": ["default", "shorts","dress","suit"],
        "Hairstyle": ["short", "long","mushroom","fuzzy"]
    ]
    
    let colorLists: [String: [Color]] = [
        "Clothes": [.white,.red,.orange,.yellow,.green,.mint,.cyan,.teal,.blue,.indigo,.purple,.pink,.brown,.gray],
        "Hairstyle": [.black,.brown,.gray,.yellow]
    ]

    var body: some View {
        let _ = print("avatar")
        VStack (spacing: 0) {
            Text("Build your bud:")
                .font(Font.custom("Roboto Mono", size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color("LightGray"))
                .onTapGesture {
                    print("Clothes Color: \(UserDefaults.standard.integer(forKey: "ClothesColor"))")
                    print("Hairstyle Color: \(UserDefaults.standard.integer(forKey: "HairstyleColor"))")
                }
            Spacer()
            
            Picker("", selection: $segmentationSelection) {
                        ForEach(Styles.allCases, id: \.self) { option in
                            Image(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: segmentationSelection) { newValue in
                        currentIndex = UserDefaults.standard.integer(forKey: newValue.rawValue)
                        currentColorIndex = UserDefaults.standard.integer(forKey: newValue.rawValue+"Color")
                    }
            
            ZStack(alignment: .topTrailing) {
                
                Image("Naked")
                    .resizable()
                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                    .offset(x:-12,y:0)
                    .clipped()
                    .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
               
                if segmentationSelection.rawValue != "Clothes"
                {
                    if let clothesSelected = lists["Clothes"]
                    {
                        if let clothesColorSelected = colorLists["Clothes"] {
                            Image(clothesSelected[UserDefaults.standard.integer(forKey: "Clothes")])
                                .resizable()
                                .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                                .offset(x:-12,y:0)
                                .clipped()
                                .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                                .allowsHitTesting(false)
                                .colorMultiply(clothesColorSelected[UserDefaults.standard.integer(forKey: "ClothesColor")])
                        }
                    }
                }

                TabView(selection: $currentIndex) {
                    if let selectedList = lists[segmentationSelection.rawValue] {
                        if let selectedColorList = colorLists[segmentationSelection.rawValue] {
                            ForEach(0..<selectedList.count, id: \.self) { index in
                                if (segmentationSelection.rawValue == "Clothes")
                                {
                                    Image(selectedList[index])
                                        .resizable()
                                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                                        .offset(x:-12,y:0)
                                        .clipped()
                                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                                        .tag(index)
                                        .colorMultiply(selectedColorList[ currentColorIndex<selectedColorList.count ? currentColorIndex : UserDefaults.standard.integer(forKey: "ClothesStyle")])
                                    
                                } else if (segmentationSelection.rawValue == "Hairstyle")
                                {
                                     Image(selectedList[index])
                                        .resizable()
                                        .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                                        .offset(x:-12,y:0)
                                        .clipped()
                                        .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                                        .tag(index)
                                        .colorMultiply(selectedColorList[ currentColorIndex<selectedColorList.count ? currentColorIndex : UserDefaults.standard.integer(forKey: "HairStyle")])
                                }
                                
                            }

                        } else {
                            let _ = print("no color list found")
                        }
                    } else {
                        let _ = print("no list found")
                    }
                      
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .onChange(of: currentIndex) { newValue in
                    UserDefaults.standard.set(newValue, forKey: segmentationSelection.rawValue)
                }
                .onChange(of: currentColorIndex) { newValue in
                    UserDefaults.standard.set(newValue, forKey: segmentationSelection.rawValue+"Color")
                }
                .onTapGesture {
                    if let colorList = colorLists[segmentationSelection.rawValue] {
                        if currentColorIndex+1 >= colorList.count {
                            currentColorIndex = 0
                        } else {
                            currentColorIndex += 1
                        }
                        
                    }
                }
                
                if segmentationSelection.rawValue != "Hairstyle"
                {
                    if let hairstyleSelected = lists["Hairstyle"]
                    {
                        if let hairstyleColorSelected = colorLists["Hairstyle"] {
                            Image(hairstyleSelected[UserDefaults.standard.integer(forKey: "Hairstyle")])
                                .resizable()
                                .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                                .offset(x:-12,y:0)
                                .clipped()
                                .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                                .allowsHitTesting(false)
                                .colorMultiply(hairstyleColorSelected[UserDefaults.standard.integer(forKey: "HairstyleColor")])
                        }
                    }
                }
                
                Image("Ear")
                    .resizable()
                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                    .offset(x:-12,y:0)
                    .clipped()
                    .frame(width: UIScreen.main.bounds.width, height: 154*CGFloat(imageScale))
                    .allowsHitTesting(false)
                
                
                Button(action: {
                    showPopover = true
                }) {
                    Text("?")
                        .font(Font.custom("Roboto Mono", size: 30))
                        .padding()
                        .background(Color("LightGray"))
                }

            }
            .popover(isPresented: $showPopover) {
                PopoverContent()

            }
            Rectangle()
                .frame(height: 86)
                .foregroundColor(Color("LightGray"))
        }
        .background(Color("DarkGray"))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PopoverContent: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "info.circle.fill")
                Text("Tip")
                Spacer()
            }
            .font(Font.custom("Roboto Mono", size: 50))
            Divider()
                .frame(height: 5)
                .overlay(.black)
                .padding(.horizontal,100)


            HStack {
                Image(systemName: "hand.draw.fill")
                    .padding()
                    .font(Font.custom("Roboto Mono", size: 30))

                Text("Swipe to switch between designs")
            }
            .font(Font.custom("Roboto Mono", size: 20))
            .padding(.vertical,50)
            
            HStack {
                Image(systemName: "hand.tap.fill")
                    .padding()
                    .font(Font.custom("Roboto Mono", size: 30))

                Text("Tap to change the \ncolor of the design")
            }
            .font(Font.custom("Roboto Mono", size: 20))
            Spacer()
        }
        .background(Color("LightGray"))
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView()
    }
}
