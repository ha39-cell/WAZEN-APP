//
//  ادخار.swift
//  wazen
//
//  Created by جنى عبدالله الشبانات on 02/07/1447 AH.
//
import SwiftUI

// MARK: - الأقسام (Tab)
// وضعناها هنا مرة واحدة فقط ليتعرف عليها كامل المشروع
//enum Tab {
//    case home
//    case expenses
//    case wallet
//}

struct MyExpensesView: View {
    @State private var selectedTab: Tab = .expenses
    @State private var showAddPage = false
    @State private var mealsAmount: Double = 400.0
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)
    
    // التدرج العلوي
    let topGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.88, green: 0.94, blue: 0.93), .white]),
        startPoint: .top,
        endPoint: .center
    )

    var body: some View {
        ZStack {
            topGradient.ignoresSafeArea()

            VStack {
                // MARK: Header (الساعة والبطارية تظهر فوق هذا الجزء)
                HStack {
                    Image(systemName: "magnifyingglass").font(.system(size: 26))
                    Spacer()
                    HStack(spacing: 8) {
                        Image("riyal").resizable().scaledToFit().frame(width: 32, height: 32)
                        Text("مصاريفي").font(.system(size: 30, weight: .bold))
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 12)

                Divider().padding(.top, 10)

                // بطاقة الرصيد
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.85, green: 0.92, blue: 0.90)).frame(height: 80)
                    HStack(spacing: 8) {
                        Text("2000").font(.system(size: 44, weight: .bold))
                        Image("riyal").resizable().scaledToFit().frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 30)

                // القائمة
                VStack(spacing: 35) {
                    ExpenseRow(amount: "\(Int(mealsAmount))", title: "وجباتي", percentage: "30%", color: activeColor)
                    ExpenseRow(amount: "150", title: "قهوتي", percentage: "10%", color: activeColor)
                    ExpenseRow(amount: "300", title: "بنزيني", percentage: "26%", color: activeColor)
                }
                .padding(.top, 40).padding(.horizontal, 25)

                // زر الزائد (يفتح الصفحة الثانية)
                HStack {
                    Spacer()
                    Button(action: { showAddPage.toggle() }) {
                        Image(systemName: "plus.app").resizable().frame(width: 45, height: 45).foregroundColor(activeColor)
                    }
                }
                .padding(.trailing, 30).padding(.top, 20)

                Spacer()

                // شريط الأيقونات السفلي
               
            }
            // هذا هو الكود اللي يخلي الساعة والبطارية تظهر بوضوح ولا يغطيها الكلام
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0)
            }
        }
        // ربط الصفحة الثانية
        .sheet(isPresented: $showAddPage) {
            AddExpenseView(mealsAmount:$mealsAmount)
        }
    }
}

// MARK: - شريط الأيقونات (تعريف واحد لكل المشروع)
//struct BottomBar: View {
//    @Binding var selectedTab: Tab
//    let activeColor = Color( colorLiteral(red: 0.25, green: 0.6, blue: 0.5, alpha: 1))
//    
//    var body: some View {
//        HStack {
//            Button(action: { selectedTab = .wallet }) {
//                Image(systemName: "wallet.bifold.fill").font(.system(size: 26))
//                    .foregroundColor(selectedTab == .wallet ? activeColor : .black)
//            }
//            Spacer()
//            Button(action: { selectedTab = .expenses }) {
//                ZStack {
//                    Circle()
//                        .fill(selectedTab == .expenses ? activeColor.opacity(0.15) : Color.clear)
//                        .frame(width: 58, height: 58)
//                    Image("riyal").resizable().scaledToFit().frame(width: 32, height: 32)
//                }
//            }
//            Spacer()
//            Button(action: { selectedTab = .home }) {
//                Image(systemName: "house.fill").font(.system(size: 26))
//                    .foregroundColor(selectedTab == .home ? activeColor : .black)
//            }
//        }
//        .padding(.horizontal, 40).padding(.vertical, 10)
//        .background(Color.white).cornerRadius(24).shadow(radius: 6)
//        .padding(.horizontal).padding(.bottom, 12)
//    }
//}

// MARK: - صفوف المصاريف
struct ExpenseRow: View {
    let amount: String; let title: String; let percentage: String; let color: Color
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().stroke(color.opacity(0.2), lineWidth: 4).frame(width: 65, height: 65)
                Circle().trim(from: 0, to: 0.25).stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round)).frame(width: 65, height: 65).rotationEffect(.degrees(-90))
                Text(percentage).font(.system(size: 15, weight: .bold))
            }
            VStack(spacing: 6) {
                HStack {
                    Text(amount).font(.system(size: 22, weight: .bold))
                    Spacer()
                    Text(title).font(.system(size: 20, weight: .bold))
                }
                Rectangle().frame(height: 1.2).foregroundColor(.black.opacity(0.2))
            }
        }
    }
}

#Preview {
    MyExpensesView()
}

