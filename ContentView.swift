//
//  ContentView.swift
//  wazen
//
//  Created by جنى عبدالله الشبانات on 04/07/1447 AH.
//
import SwiftUI

enum Tab {
    case home
    case expenses
    case wallet
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView()
            case .expenses:
                MyExpensesView()
            case .wallet:
                SavingsOverviewView()
            }

            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab)

            }
        }
      
    }
}

struct HomeView: View {
    @State private var showNotifications = false
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)
    
    let topGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.88, green: 0.94, blue: 0.93), .white]),
        startPoint: .top,
        endPoint: .center
    )

    var body: some View {
        ZStack {
            topGradient.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button {
                        showNotifications = true
                    } label: {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 22))
                            .foregroundColor(activeColor)
                    }
                    .sheet(isPresented: $showNotifications) {
                        NotificationsView()
                    }

                    Spacer()

                    Text("أهلاً!")
                        .font(.system(size: 20, weight: .bold))

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 38, height: 38)
                        .foregroundColor(.gray.opacity(0.5))
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)

                VStack(spacing: 15) {
                    VStack(spacing: 5) {
                        Text("الرصيد الحالي")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            Text("10,000")
                                .font(.system(size: 40, weight: .bold))
                            Image(systemName: "plus.square.fill")
                                .font(.title2)
                                .foregroundColor(activeColor)
                        }
                    }
                    ZStack{
                        Image("Rectangle 24")
                            .resizable()
                            .scaledToFit()
                        
                        VStack(spacing: 8) {
                            Text("إدخارك")
                                .font(.system(size: 22, weight: .bold))
                            Text("6,000 / 5,500")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10)
                    .padding(.horizontal, 25)
                }

                VStack(spacing: 10) {
                    Text("الصرف اليومي")
                        .font(.system(size: 18, weight: .bold))
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 200, height: 45)
                }

                VStack(spacing: 25) {
                    HStack(spacing: 40) {
                        CategoryView(title: "بنزينك", icon: "car.fill", green: 0.7, red: 0.15)
                        CategoryView(title: "وجباتك", icon: "fork.knife", green: 0.6, red: 0.2)
                    }
                    CategoryView(title: "قهوتك", icon: "cup.and.saucer.fill", green: 0.8, red: 0.1)
                }
                .padding(.bottom, 110)
                
                Spacer()
            }
        }
    }
}


// MARK: - CATEGORY VIEW
struct CategoryView: View {
    let title: String
    let icon: String
    let green: CGFloat
    let red: CGFloat

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .trim(from: 0, to: green)
                    .stroke(
                        Color(red: 0.25, green: 0.6, blue: 0.5),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Circle()
                    .trim(from: green, to: green + red)
                    .stroke(
                        Color.red,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Image(systemName: icon)
                    .font(.title2)
            }
            .frame(width: 80, height: 80)

            Text(title)
                .font(.headline)
        }
    }
}

// MARK: - NOTIFICATIONS VIEW
struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.96, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("الإشعارات")
                    .font(.largeTitle)
                    .bold()

                Text("لا توجد إشعارات حالياً")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
    }
}



#Preview {
    ContentView()
}

struct BottomBar: View {
    @Binding var selectedTab: Tab
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)
    
    var body: some View {
        HStack {
            // 1. أيقونة المحفظة (تكون على اليسار وتروح لصفحة المحفظة)
            Button(action: { selectedTab = .wallet }) {
                Image(systemName: "wallet.bifold.fill")
                    .font(.system(size: 26))
                    .foregroundColor(selectedTab == .wallet ? activeColor : .gray)
            }
            
            Spacer()
            
            // 2. زر الريال (في النص ويروح لصفحتك "مصاريفي")
            Button(action: { selectedTab = .expenses }) {
                ZStack {
                    Circle()
                        .fill(selectedTab == .expenses ? activeColor.opacity(0.15) : Color.clear)
                        .frame(width: 58, height: 58)
                    
                    Image("riyal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(selectedTab == .expenses ? activeColor : .black)
                }
            }
            
            Spacer()
            
            // 3. أيقونة البيت (تكون على اليمين وتروح لصفحة الواجهة)
            Button(action: { selectedTab = .home }) {
                Image(systemName: "house.fill")
                    .font(.system(size: 26))
                    .foregroundColor(selectedTab == .home ? activeColor : .gray)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
        .background(
            Color.white
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
