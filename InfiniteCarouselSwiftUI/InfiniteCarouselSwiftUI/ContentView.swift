//
//  ContentView.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Ishu Passi on 28/08/24.
//

import SwiftUI

struct HorizontalPagingGrid: View {
    let items = Array(0..<10)
    let itemsCount = Array(0..<3000)
    @State private var currentPage = 1500

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let itemWidth = geometry.size.width * 0.7 // Make the item width smaller to see the adjacent views
                let spacing = (geometry.size.width - itemWidth) / 5 // Adjust spacing to control visibility of left and right views

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.fixed(itemWidth))], spacing: spacing) {
                        ForEach(itemsCount, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .frame(width: itemWidth, height: itemWidth)
                                    .foregroundColor(.red)
                                    .cornerRadius(10)
                                    .scaleEffect(currentPage == item ? 1.1 : 0.9) // Scaling effect for center item
                                    .animation(.easeInOut, value: currentPage)
                            }
                            .id(item)
                        }
                    }
                    .padding(.horizontal, spacing)
                }
                .content.offset(x: -CGFloat(currentPage) * (itemWidth + spacing) + 30)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width < -threshold {
                                currentPage = min(currentPage + 1, itemsCount.count - 1)
                            } else if value.translation.width > threshold {
                                currentPage = max(currentPage - 1, 0)
                            }
                        }
                )
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.gray.opacity(0.2))
            
            // Page Control
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage % items.count ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
        HorizontalPagingGrid()
    }
}

#Preview {
    ContentView()
}

