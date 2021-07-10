//
//  View+navigate.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 01/05/2020.
//

import SwiftUI

// Navigate to a new view when a certain 'Binding' condition is true
extension View {
    func navigate<SomeView: View>(to view: SomeView, when binding: Binding<Bool>) -> some View {
        modifier(NavigateModifier(destination: view, binding: binding))
    }
}

fileprivate struct NavigateModifier<SomeView: View>: ViewModifier {
    fileprivate let destination: SomeView
    @Binding fileprivate var binding: Bool

    fileprivate func body(content: Content) -> some View {
        NavigationView {
            ZStack {
                content
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                NavigationLink(destination: destination
                    .navigationBarTitle("")
                    .navigationBarHidden(true),
                               isActive: $binding) {
                    EmptyView()
                }
            }
        }
    }
}
