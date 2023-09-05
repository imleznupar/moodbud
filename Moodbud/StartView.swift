//
//  StartView.swift
//  Moodbud
//
//  Created by Lulu on 6/10/23.
//

import SwiftUI

struct StartView: View {
    
    let imageScale = 2.5
    @Binding var showTabBarView: Bool
    let Clothes:[String] = ["default", "shorts","dress","suit"]
    let Hairstyle:[String] = ["short", "long","mushroom","fuzzy"]
    let ClothesColor:[Color] = [.white,.red,.orange,.yellow,.green,.mint,.cyan,.teal,.blue,.indigo,.purple,.pink,.brown,.gray]
    let HairstyleColor:[Color] = [.black,.brown,.gray,.yellow]
    

    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Group {
                Text("MOODBUD")
                    .font(Font.custom("Roboto Mono", size: 60))

                Button(action: {
                            print("Button tapped")
                            showTabBarView = true
                        }) {
                            Text("GET STARTED")
                                .font(Font.custom("Roboto Mono", size: 20))
                                .padding(.vertical, 25.0)
                                .padding(.horizontal, 50.0)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
            }
            
            Spacer()

            ZStack {
                Image("Naked")
                    .resizable()
                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                    .offset(x:-12,y:0)
                Image(Clothes[UserDefaults.standard.integer(forKey: "Clothes")])
                    .resizable()
                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                    .offset(x:-12,y:0)
                    .colorMultiply(ClothesColor[UserDefaults.standard.integer(forKey: "ClothesColor")])
                Image(Hairstyle[UserDefaults.standard.integer(forKey: "Hairstyle")])
                    .resizable()
                    .frame(width: 205*CGFloat(imageScale), height: 154*CGFloat(imageScale))
                    .offset(x:-12,y:0)
                    .colorMultiply(HairstyleColor[UserDefaults.standard.integer(forKey: "HairstyleColor")])
                
            }
        }
        .ignoresSafeArea()
        .background(Color("LightGray"))
    }
}

struct StartView_Previews: PreviewProvider {
    @State static private var showTabBarView = false
        
    static var previews: some View {
        StartView(showTabBarView: $showTabBarView)
    }
}
