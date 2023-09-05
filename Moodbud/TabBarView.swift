//
//  TabBarView.swift
//  Moodbud
//
//  Created by Lulu on 6/11/23.
//

import SwiftUI

struct TabBarItem: View {
    var imageName: String
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
        }
        .padding()
    }
}

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var dotOffset: CGFloat = 0
    @State private var cover: Color = Color("DarkGray")

    
    var body: some View {

        ZStack(alignment: .top) {

            
            CalendarView()
                .zIndex(0)
                .onAppear()
            {
                print("calendar view")
            }
            cover
                .ignoresSafeArea()
                .zIndex(1)


            if selectedTab == 0 {
                DashboardView()
                    .zIndex(2)

                    .onAppear()
                {
                    print("Dashboard view")
                }
            } else if selectedTab == 2 {
//                TestView()
//                    .zIndex(2)
//
//                    .onAppear()
//                {
//                    print("Test view")
//                }
                AvatarView()
                    .zIndex(2)
            } else {
//                CalendarView()
            }
            
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 20) {
                    Spacer()
                    
                    TabBarItem(imageName: "triangle.fill", isSelected: selectedTab == 0)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedTab = 0
                            }
                        }
                    
                    TabBarItem(imageName: "square.fill", isSelected: selectedTab == 1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedTab = 1
                            }
                        }
                    
                    TabBarItem(imageName: "circle.fill", isSelected: selectedTab == 2)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedTab = 2
                            }
                        }
                    
                    Spacer()
                }
                .padding(.top,0)
                .padding(.bottom,30)
                .background(Color("LightGray"))
                .overlay(
                    DotView()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                        .offset(x: -75+dotOffset,y:10)
                )
                .preference(key: TabBarPreferenceKey.self, value: selectedTab)
                .onPreferenceChange(TabBarPreferenceKey.self) { preferences in

                    
                    let offset = CGFloat(selectedTab)*76
                    withAnimation(.spring()) {
                        dotOffset = offset
                    }
                    if selectedTab == 1
                    {
                        cover = Color.clear
                    } else {
                        cover = Color("DarkGray")
                    }
                    print("Selected tab: \(selectedTab)")
                }
            }
            .zIndex(3)

        }
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct DotView: View {
    var body: some View {
        Circle()
            .frame(width: 7, height: 7)
    }
}

struct TabBarPreferenceKey: PreferenceKey {
    static var defaultValue: Int?
        
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = nextValue()
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

