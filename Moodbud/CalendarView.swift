//
//  CalendarView.swift
//  Moodbud
//
//  Created by Lulu on 6/11/23.
//
import SwiftUI
import CoreData


private func dateConverter(day:Date) -> Date {
    return Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: day))
               , since: day)
}

struct DayView: View {
    @FetchRequest var entries: FetchedResults<Entry>

    let date: Date
    let imageScale = 0.38
//    let month:
//    let day: Int
    let week: String
    let today: Bool
    
    var dayString:String {
        if Calendar.current.component(.day, from: date)<10
        {
            return "0\(Calendar.current.component(.day, from: date))"
        }
        return String(Calendar.current.component(.day, from: date))
    }
    
    init(date: Date, week: String, today: Bool) {
        self.week = week
        self.today = today
        self.date = date
        self._entries = FetchRequest<Entry>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [dateConverter(day:Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!), dateConverter(day: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!)]))
        
    }
    
    var body: some View {
        HStack (spacing: 50) { //86xsmth smaller
            VStack {
                Text("\(Calendar.current.component(.month, from: date))/\(dayString)")
                    .font(Font.custom("Roboto Mono", size: 30))
                Text(week)
                    .font(Font.custom("Roboto Mono", size: 35))
            }
            .foregroundColor(today ? Color.black : Color.gray)
            
            Divider()
                .frame(width: 2)
                .overlay(today ? Color.black : Color.gray)
            
            ZStack {
                if entries.count > 0
                {
                    Image("Naked")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                        .scaleEffect(2.5)
                        .offset(x:0,y:10)
                        .clipped()
                    Image("default")
                        .resizable()
                        .colorMultiply(.cyan)
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                        .scaleEffect(2.5)
                        .offset(x:0,y:10)
                        .clipped()
                    Image("short")
                        .resizable()
                        .colorMultiply(.black)
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                        .scaleEffect(2.5)
                        .offset(x:0,y:10)
                        .clipped()
                    Image(entries[0].mood!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                        .scaleEffect(2.5)
                        .offset(x:0,y:10)
                        .clipped()
                }
                
                VStack {
                    Text("\(entries.count)/01")
                        .font(Font.custom("Roboto Mono", size: 30))
                        .foregroundColor(.clear)
                    Text("MON")
                        .font(Font.custom("Roboto Mono", size: 35))
                        .foregroundColor(.clear)
                }
            }
        }
        
        .padding()
    }
        
}


struct CalendarView: View {
    
    struct aDay: Identifiable {
        
        let day: Int
        let month: Int
        let year: Int
        
        var id: String {
            return "\(day)-\(month)-\(year)"
        }
        
        var week:String {
            
            guard let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1)) else {
                fatalError("Invalid start date")
            }
            
            guard let targetDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
                fatalError("Invalid target date")
            }
            
            let daySince = Int(targetDate.timeIntervalSince(startDate)/86400)
            
            switch daySince%7
            {
                case 0: return "SUN"
                case 1: return "MON"
                case 2: return "TUE"
                case 3: return "WED"
                case 4: return "THU"
                case 5: return "FRI"
                case 6: return "SAT"
                default:return "NULL"
            }
        }
    }
    
    @State private var years: [Int] = Array(2023...(
        2025 + 1)) // Array to store the years
    @State private var isLoadingNextYear: Bool = false // Flag to indicate if next year is being loaded
    @State private var scrolling: Bool = true
    
    @State private var initialLoad: Bool = true
    
    @State private var currentDay = Date() //in UTC
                
//    private var dataManager: DataManager {
//        DataManager.shared
//    }
    
        
    let monthDic = [
        "1": 31,
        "2": 28,
        "3": 31,
        "4": 30,
        "5": 31,
        "6": 30,
        "7": 31,
        "8": 31,
        "9": 30,
        "10": 31,
        "11": 30,
        "12": 31
    ]
    
    let monthName = [
        1: "January",
        2: "February",
        3: "March",
        4: "April",
        5: "May",
        6: "June",
        7: "July",
        8: "August",
        9: "September",
        10: "October",
        11: "November",
        12: "December"
    ]

    var body: some View {
        ScrollViewReader { scrollView in
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        ForEach(years, id: \.self) { year in
                            Section(header: Text(String(year))
                                .padding()
                                .background(Color("LightGray"))
                                .font(Font.custom("Roboto Mono", size: 50))
                            ) {
                                ForEach(1..<monthDic.count+1) { month in
                                    Section(header: Text("\(monthName[month]!)")
                                        .padding()
                                        .background(Color("LightGray"))
                                        .font(Font.custom("Roboto Mono", size: 30))) {
                                            let Days = getADay(mon: month, yr: year)
                                            ForEach(Days, id: \.id) { day in

                                                let theDay = createDate(day: day.day, month: month, year: year)
//
                                                if year == Calendar.current.component(.year, from: currentDay), month == Calendar.current.component(.month, from: currentDay), day.day == Calendar.current.component(.day, from: currentDay)
                                                {

                                                    DayView(date: theDay, week: day.week, today: true)
                                                } else {
                                                    DayView(date: theDay, week: day.week, today: false)

                                                }

                                            }
                                    }
                                }
                            }
                            .onAppear {
                                print("current day: \(currentDay)  \(Calendar.current.component(.day, from: currentDay))")
                                if year == years.first, initialLoad {
                                    scrollToSpecificDate(scrollView: scrollView, year: Calendar.current.component(.year, from: currentDay), month: Calendar.current.component(.month, from: currentDay), day: Calendar.current.component(.day, from: currentDay))
                                    print("hi")

                                    scrolling = false
                                    initialLoad = false
                                }
                                if year == years.last, !isLoadingNextYear, !scrolling {
                                    print("load following years \(year+1)")
                                    loadNextYear()
                                }
                            }
                        }
                    }
                }
                Button(action: {
                    print("button")
                    scrollToSpecificDate(scrollView: scrollView, year: Calendar.current.component(.year, from: currentDay), month: Calendar.current.component(.month, from: currentDay), day: Calendar.current.component(.day, from: currentDay))

                }) {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(Font.custom("Roboto Mono", size: 30))
                        .padding()
                        .background(Color("LightGray"))
                }
                .padding(.bottom,106)
            }
            .background(Color("DarkGray"))
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.NSCalendarDayChanged).receive(on: DispatchQueue.main)) { _ in
                print("date change")
                currentDay = Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: Date()))
                                  , since: Date())
                scrollToSpecificDate(scrollView: scrollView, year: Calendar.current.component(.year, from: currentDay), month: Calendar.current.component(.month, from: currentDay), day: Calendar.current.component(.day, from: currentDay))
            }
        }
    }

    private func loadNextYear() {
        isLoadingNextYear = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let lastYear = years.last ?? Calendar.current.component(.year, from: Date())
            let nextYear = lastYear + 1

            years.append(nextYear)
            isLoadingNextYear = false
        }
    }
    
    private func scrollToSpecificDate(scrollView: ScrollViewProxy, year: Int, month: Int, day: Int) {
        scrolling = true
        withAnimation(.spring())
        {
            scrollView.scrollTo("\(day)-\(month)-\(year)",anchor:.center)
        }
        print(currentDay)
    }
    
    private func getADay(mon: Int, yr: Int) -> [aDay] {
        if mon == 2 && yr%4==0
        {
            //leap year
            return (1..<monthDic["\(mon)"]!+2).map {
                aDay(day: $0, month: mon, year: yr)
            }
        } else
        {
            return (1..<monthDic["\(mon)"]!+1).map {
                aDay(day: $0, month: mon, year: yr)
            }
        }
    }
    
    private func createDate(day: Int, month: Int, year:Int) -> Date {
        let comp = DateComponents(year:year, month:month,day:day)
        let datee = Calendar.current.date(from: comp)
        return datee!
    }
}




struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
