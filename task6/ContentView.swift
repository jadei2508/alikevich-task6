//
//  ContentView.swift
//  task6
//
//  Created by Роман on 15/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stackState: StackState = .vertical
    private let count = 7
    var body: some View {
        let layout =
            stackState == .vertical
                ? AnyLayout(HStackLayout())
                : AnyLayout(CustomLayout())

        layout {
            ForEach((0...count - 1), id: \.self) { i in
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .aspectRatio(1, contentMode: .fit)
            }
        }.onTapGesture {
            withAnimation(.linear(duration: 0.5)) {
                stackState =
                    stackState == .vertical
                        ? .horizontal
                        : .vertical
            }
            
        }
    }
    
    private enum StackState {
        case horizontal
        case vertical
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return .init(width: proposal.width ?? 0.0,
                     height: proposal.height ?? 0.0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.enumerated().forEach { (index, subview) in
            let sideSize = bounds.size.height / CGFloat(subviews.count)
            
            let rectWidthSize = (bounds.size.width - sideSize) / CGFloat(subviews.count - 1)
            let rectHeightSize = (bounds.size.height - sideSize) / CGFloat(subviews.count - 1)
            let startX: CGFloat =
                index > 0
                    ? bounds.origin.x
                        + CGFloat(index) * rectWidthSize
                    : bounds.origin.x
            let startY = index > 0
                ? (bounds.maxY) - CGFloat(index) * rectHeightSize - sideSize
                : bounds.maxY - sideSize
            
            subview.place(at: CGPoint(x: startX, y: startY), proposal: ProposedViewSize(CGSize(width: sideSize, height: sideSize)))
        }
    }
    
    
}
