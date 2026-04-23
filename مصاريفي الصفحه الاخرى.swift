//
//  مصاريفي الصفحه الاخرى.swift
//  wazen
//
//  Created by جنى عبدالله الشبانات on 03/07/1447 AH.
//
import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: Tab = .expenses
    @State private var selectedCategory: String = "" // لمعرفة أي تصنيف تم اختياره
    @State private var expenseAmount: String = "" // متغير لحفظ الرقم اللي تكتبينه
    let activeColor = Color(red: 0.25, green: 0.6, blue: 0.5)
    @Binding var mealsAmount: Double
    // التدرج العلوي الواضح
    let topGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.88, green: 0.94, blue: 0.93), .white]),
        startPoint: .top,
        endPoint: .center
    )
    
    var body: some View {
        ZStack {
            // إضافة التدرج في الخلفية ليكون واضحاً
            topGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        HStack {
                            Image(systemName: "magnifyingglass").font(.system(size: 26))
                            Spacer()
                            HStack(spacing: 8) {
                                Image("riyal").resizable().scaledToFit().frame(width: 30, height: 30)
                                Text("مصاريفي").font(.system(size: 28, weight: .bold))
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // منطقه الدائرة والمبلغ
                        HStack(spacing: 16) {
                            ZStack {
                                Circle().stroke(activeColor.opacity(0.2), lineWidth: 4).frame(width: 65, height: 65)
                                Circle().trim(from: 0, to: 0.20).stroke(activeColor, style: StrokeStyle(lineWidth: 4, lineCap: .round)).frame(width: 65, height: 65).rotationEffect(.degrees(-90))
                                Text("20%").font(.system(size: 15, weight: .bold))
                            }
                            VStack(spacing: 6) {
                                HStack {
                                    Text("400").font(.system(size: 22, weight: .bold))
                                    Spacer()
                                    Text("وجباتي").font(.system(size: 20, weight: .bold))
                                }
                                Rectangle().frame(height: 1.2).foregroundColor(.black.opacity(0.2))
                            }
                        }
                        .padding(.horizontal, 25)

                        // حقول الإدخال والخيارات التفاعلية
                        VStack(alignment: .trailing, spacing: 15) {
                            Text("ادخال المبلغ المصروف").font(.headline).foregroundColor(.gray)
                            TextField("0.00", text: $expenseAmount)
                                .keyboardType(.decimalPad) // عشان تطلع لك أرقام بس
                                .padding()
                                .frame(height: 50)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .multilineTextAlignment(.trailing) // عشان الأرقام تبدأ من اليمين

                            Text("حدد").font(.headline).foregroundColor(.gray).padding(.top, 10)
                            
                            // أزرار التصنيفات (صارت قابلة للضغط الآن)
                            VStack(spacing: 12) {
                                CategoryButton(title: "وجباتي", isSelected: selectedCategory == "وجباتي") {
                                    selectedCategory = "وجباتي"
                                }
                                CategoryButton(title: "قهوتي", isSelected: selectedCategory == "قهوتي") {
                                    selectedCategory = "قهوتي"
                                }
                                CategoryButton(title: "بنزيني", isSelected: selectedCategory == "بنزيني") {
                                    selectedCategory = "بنزيني"
                                }
                            }
                            
                            Button(action: {
                                // يحول النص لرقم ويجمعه
                                if let amount = Double(expenseAmount) {
                                    mealsAmount += amount
                                }
                                expenseAmount = ""
                                dismiss()
                            }) {
                                Text("إضافة")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(activeColor)
                                    .cornerRadius(15)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 25)
                    }
                }
                
                Spacer()
               
            } // نهاية الـ VStack
                      .safeAreaInset(edge: .top) {
                          Color.clear.frame(height: 0)
                      }
                      .onTapGesture {
                          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                      }
                  } // نهاية الـ ZStack
              }
          }

    
// تصميم الزر التفاعلي للتصنيفات
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isSelected ? Color(red: 0.25, green: 0.6, blue: 0.5) : Color.gray.opacity(0.1))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}


#Preview {
    AddExpenseView(mealsAmount: .constant(400.0))
}
