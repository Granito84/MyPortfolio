//
//  ButtonStyles.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 1/11/20.
//

import SwiftUI


struct WideButtonStyleModifier: ButtonStyle {
    var color: Color = .accentColor
    var padding: CGFloat = 0
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: .infinity).fill(color))
            .padding(.horizontal, padding)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

extension View {
    func wideButtonStyle(color: Color = .accentColor, padding: CGFloat = 0) -> some View {
        self.buttonStyle(WideButtonStyleModifier(color: color, padding: padding))
    }
}


// MARK: - previews
struct ButtonStyles: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Test Wide Button") {
                //
            }
            .wideButtonStyle()
            
            Button("Test Wide Button") {
                //
            }
            .wideButtonStyle(color: .orange, padding: 20)
        }
    }
}
