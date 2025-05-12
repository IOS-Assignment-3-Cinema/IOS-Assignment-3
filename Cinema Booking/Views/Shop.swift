//
//  Shop.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 11/5/2025.
//

import SwiftUI

struct Shop: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let price: Double
    var quantity: Int
}

struct ShopView: View {
    let initialTotal: Double

    @State private var cart: [Shop] = []
    @State private var totalPrice: Double = 0.0
    @State private var shopItems = [
        Shop(name: "Popcorn and drink combo", imageName: "popcornDrink", price: 15.90, quantity: 0),
        Shop(name: "Nachos and drink combo", imageName: "nachosDrink", price: 20.90, quantity: 0),
        Shop(name: "Hotdog and drink combo", imageName: "hotdogDrink", price: 17.90, quantity: 0),
        Shop(name: "Donut and drink combo", imageName: "donnutDrink", price: 19.90, quantity: 0)
    ]
    @State private var navigateToDetails = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Select Your Snacks")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom)

                    ForEach(shopItems.indices, id: \..self) { index in
                        let item = shopItems[index]
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 100, height: 100)

                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)

                                Text(String(format: "$%.2f", item.price))
                                    .font(.subheadline)

                                HStack {
                                    Button("-") {
                                        updateQuantity(at: index, increase: false)
                                    }

                                    Text("\(item.quantity)")
                                        .frame(width: 30)

                                    Button("+") {
                                        updateQuantity(at: index, increase: true)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(white: 0.97))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }

            VStack(spacing: 6) {
                let combinedTotal = initialTotal + totalPrice
                HStack {
                    Text("Total \(String(format: "$%.2f", combinedTotal))")
                        .foregroundColor(.black)
                        .bold()

                    Spacer()

                    NavigationLink(destination: CheckoutDetailsView(totalPrice: combinedTotal), isActive: $navigateToDetails) {
                        Button("Proceed to Payment") {
                            navigateToDetails = true
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }

                Text("Includes initial booking total of $\(String(format: "%.2f", initialTotal))")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }

    private func updateQuantity(at index: Int, increase: Bool) {
        if increase {
            shopItems[index].quantity += 1
            totalPrice += shopItems[index].price
        } else if shopItems[index].quantity > 0 {
            shopItems[index].quantity -= 1
            totalPrice -= shopItems[index].price
        }
    }
}
