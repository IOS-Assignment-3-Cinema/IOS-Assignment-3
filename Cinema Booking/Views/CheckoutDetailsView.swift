//
//  CheckoutDetailsView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 11/5/2025.
//


import SwiftUI

struct CheckoutDetailsView: View {
    let totalPrice: Double
    @State private var name = UserDefaults.standard.string(forKey: "userName") ?? ""
    @State private var email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var showSuccess = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                }

                Section(header: Text("Card Information")) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Expiry Date (MM/YY)", text: $expiry)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Pay $\(String(format: "%.2f", totalPrice))") {
                            validateAndProceed()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Checkout Details")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $showSuccess) {
                CheckoutSuccessView()
            }
        }
    }

    private func validateAndProceed() {
        if name.isEmpty {
            alertTitle = "Missing Name"
            alertMessage = "Please enter your name."
            showingAlert = true
        } else if !isValidEmail(email) {
            alertTitle = "Invalid Email"
            alertMessage = "Please enter a valid email address."
            showingAlert = true
        } else if cardNumber.count != 16 || !cardNumber.allSatisfy({ $0.isNumber }) {
            alertTitle = "Invalid Card Number"
            alertMessage = "Card number must be 16 digits."
            showingAlert = true
        } else if !isValidExpiry(expiry) {
            alertTitle = "Invalid Expiry"
            alertMessage = "Please enter expiry in MM/YY format."
            showingAlert = true
        } else if cvv.count != 3 || !cvv.allSatisfy({ $0.isNumber }) {
            alertTitle = "Invalid CVV"
            alertMessage = "CVV must be 3 digits."
            showingAlert = true
        } else {
            showSuccess = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidExpiry(_ expiry: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(0[1-9]|1[0-2])/\\d{2}$")
        let range = NSRange(location: 0, length: expiry.utf16.count)
        return regex.firstMatch(in: expiry, options: [], range: range) != nil
    }
}
