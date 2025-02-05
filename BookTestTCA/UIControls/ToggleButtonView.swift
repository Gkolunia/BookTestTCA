//
//  ToggleButtonView.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import SwiftUI

struct ToggleButtonView: View {
    
    @Binding var isRightSelected: Bool
    @State var leftIcon: String
    @State var rightIcon: String
    
    var body: some View {
            ZStack{
                Capsule()
                    .fill(.white)
                    .stroke(.gray.opacity(0.4), lineWidth: 1)
                    .frame(width: 106, height: 52)
                HStack{
                    ZStack{
                        Capsule()
                            .fill(.blue)
                            .frame(width: 44, height: 44)
                            .offset(x: isRightSelected ? 50 : 0)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: 0.5)
                        
                        Image(systemName: leftIcon)
                            .renderingMode(.template)
                            .foregroundStyle( isRightSelected ? Color.black : Color.white)
                    }
                    ZStack{
                        Image(systemName: rightIcon)
                            .renderingMode(.template)
                            .frame(width: 44, height: 44)
                            .foregroundStyle( isRightSelected ? Color.white : Color.black)
                    }
                }
            }
            .onTapGesture {
                isRightSelected.toggle()
            }
    }
}

#Preview {
    ToggleButtonView(isRightSelected: .constant(false), leftIcon: "headphones", rightIcon: "text.alignleft")
}
