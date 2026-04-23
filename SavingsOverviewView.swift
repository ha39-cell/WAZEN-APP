//
//  SavingsOverviewView.swift
//  wazen
//
//  Created by جنى عبدالله الشبانات on 05/07/1447 AH.
//

import SwiftUI

// MARK: - 1. Model
struct SavingGoal: Identifiable {
    let id = UUID()
    let name: String
    let targetAmount: Double
    var savedAmount: Double
    let duration: String
}

// MARK: - 2. Main Savings View
struct SavingsOverviewView: View {
    
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)
    let cardBackground = Color(red: 0.88, green: 0.91, blue: 0.90)
    
    @State private var goals: [SavingGoal] = [
        SavingGoal(name: "سفر", targetAmount: 10000, savedAmount: 2500, duration: "شهري"),
        SavingGoal(name: "سيارة", targetAmount: 30000, savedAmount: 8000, duration: "سنوي")
    ]

    @State private var selectedGoalIndex: Int = 0
    @State private var addedAmount: String = ""
    @State private var showAddAmountSheet = false
    @State private var selectedTab = 2 // المحفظة (أقصى اليسار)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // HEADER
                HStack {
                    HStack(spacing: 8) {
                        Text("مدخراتي").font(.largeTitle).bold()
                        Image(systemName: "wallet.bifold.fill").font(.title).foregroundColor(activeColor)
                    }
                    Spacer()
                    
                    NavigationLink(destination: AddGoalView(goals: $goals)) {
                        Image(systemName: "plus").font(.title2).padding(8)
                            .foregroundColor(activeColor)
                    }
                }
                .padding()

                // GOALS LIST + ADD AMOUNT BUTTON
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(goals) { goal in
                            goalRow(for: goal)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .onDelete(perform: deleteGoal) // السحب لليمين للحذف
                        
                        // مساحة فارغة في نهاية القائمة لضمان عدم تغطية الزر لآخر هدف
                        Color.clear.frame(height: 80).listRowSeparator(.hidden).listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)

                    // زر "إضافة مبلغ" - ثابت فوق القائمة في الأسفل
                    Button {
                        showAddAmountSheet = true
                    } label: {
                        Text("إضافة مبلغ")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(activeColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }

                // FOOTER
                customFooter
            }
            .sheet(isPresented: $showAddAmountSheet) {
                addAmountSheetView
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    // تصميم بطاقة الهدف
    func goalRow(for goal: SavingGoal) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(goal.name).font(.headline)
                Spacer()
                Text(goal.duration)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(activeColor.opacity(0.1))
                    .cornerRadius(8)
            }
            Text("المبلغ المدخر: \(Int(goal.savedAmount)) ر.س")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ProgressView(value: goal.savedAmount, total: goal.targetAmount)
                .tint(activeColor)
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(12)
    }

    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    // الفوتر (المحفظة أقصى اليسار مرتبطة بالصفحة)
    var customFooter: some View {
        HStack {
            footerItem(icon: "house.fill", index: 0)
            Spacer()
            footerItem(icon: "banknotes.fill", index: 1)
            Spacer()
            footerItem(icon: "wallet.bifold.fill", index: 2) // أيقونة المحفظة
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 10)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    func footerItem(icon: String, index: Int) -> some View {
        Button { selectedTab = index } label: {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(selectedTab == index ? activeColor : .gray)
        }
    }

    // شيت إضافة مبلغ
    var addAmountSheetView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("إضافة مبلغ").font(.title).bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("اختر الهدف").font(.caption).foregroundColor(.gray)
                Picker("الهدف", selection: $selectedGoalIndex) {
                    ForEach(0..<goals.count, id: \.self) { index in
                        Text(goals[index].name).tag(index)
                    }
                }
                .pickerStyle(.menu)
            }

            TextField("ادخل المبلغ", text: $addedAmount)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            
            Button("حفظ") {
                if let value = Double(addedAmount), selectedGoalIndex < goals.count {
                    goals[selectedGoalIndex].savedAmount += value
                }
                addedAmount = ""; showAddAmountSheet = false
            }
            .frame(maxWidth: .infinity).padding().background(activeColor).foregroundColor(.white).cornerRadius(12)
            Spacer()
        }
        .padding().presentationDetents([.medium]).environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - 3. Add Goal View (العنوان بجانب السهم)
struct AddGoalView: View {
    @Binding var goals: [SavingGoal]
    @Environment(\.dismiss) private var dismiss
    @State private var goalName: String = ""
    @State private var targetAmount: String = ""
    @State private var duration: String = "شهري"
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)

    var body: some View {
        VStack(spacing: 20) {
            TextField("اسم الهدف", text: $goalName).textFieldStyle(.roundedBorder)
            TextField("المبلغ المستهدف", text: $targetAmount).keyboardType(.numberPad).textFieldStyle(.roundedBorder)
            
            Picker("المدة", selection: $duration) {
                Text("أسبوعي").tag("أسبوعي")
                Text("شهري").tag("شهري")
                Text("سنوي").tag("سنوي")
            }.pickerStyle(.segmented)

            Button("حفظ الهدف") {
                if let target = Double(targetAmount), !goalName.isEmpty {
                    goals.append(SavingGoal(name: goalName, targetAmount: target, savedAmount: 0, duration: duration))
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity).padding().background(activeColor).foregroundColor(.white).cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("إضافة هدف جديد") // العنوان يظهر في التول بار بجانب السهم
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    SavingsOverviewView()
}
