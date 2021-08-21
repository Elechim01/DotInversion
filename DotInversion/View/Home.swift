//
//  Home.swift
//  Home
//
//  Created by Michele Manniello on 21/08/21.
//

import SwiftUI

//This project will work for IOS 14 also...
struct Home: View {

//    Curret State...
    @State var dotState : DotState = .normal
//    Scale Value...
    @State var dotScale: CGFloat = 1
//    Rotation..
    @State var dotrotation : Double = 0

// To avoidn multiple taps...
    @State var isAnimating = false
    
    var body: some View {
        ZStack{
            ZStack {
                (dotState == .normal ? Color("Gold") : Color("Grey"))
                if dotState == .normal{
                    MinimesdView()
                }else{
                    ExpandedView()
                }
            }
            .animation(.none, value: dotState)

            Rectangle()
                .fill(dotState != .normal ? Color("Gold") : Color("Grey"))
                .overlay(
                    ZStack {
//                        Put View in reverse..
//                        so that it will look like masking effect...
//                        changing view based on state..
                        if dotState != .normal{
                            MinimesdView()
                        }else{
                            ExpandedView()
                        }
                    }
                )
                .animation(.none, value: dotState)
//            Masking the view with circle to create dot inversion animation...
                .mask(
                    GeometryReader{ proxy in
                        Circle()
//                        While increasing the scale the content will be visible...
                            .frame(width: 100, height: 100)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotrotation), axis: (x: 0,y:1,z:0),
                                              anchorZ: dotState == .flipped ? -10 : 10, perspective: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -60)
                        
                    }
                )
//            For Tao Gestire...
            Circle()
                .foregroundColor(Color.black.opacity(0.01))
                .frame(width: 100, height: 100)
            //            arrow
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .foregroundColor(.white)
//                                opacity animation...
                                    .opacity(isAnimating ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.4), value: isAnimating)
                            )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .onTapGesture(perform: {
                    
                    if isAnimating{return}
                    
                    isAnimating = true
                    
//                    checkin if dot is flipped...
                    if dotState == .flipped{
//                       Reversng the effect...
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            withAnimation(.linear(duration: 1.5)){
                                dotScale = 1
                                dotState = .normal
                            }
                        }
                        withAnimation(.linear(duration: 1.5)){
                            dotrotation = 0
                            dotScale = 8
                        }
                    }else{
                        
//                        At mind of 1.5 just resetting the scale to again 1....
//                        so taht it will be look like dot inversion...
//                        just trail and error the delay value...
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            withAnimation(.linear(duration: 1.5)){
                                dotScale = 1
                                dotState = .flipped
                            }
                        }
                        withAnimation(.linear(duration: 1.5)){
                            dotrotation = -180
                            dotScale = 8
                        }
                    }
//                    After 1.4s resetting isAnimating State...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        isAnimating = false
                    }
                })
                .offset(y: -60)
        }
        .ignoresSafeArea()
    }
//    Expanded and Minimised Views....
    @ViewBuilder
    func ExpandedView() -> some View{
        VStack(spacing: 10){
            Image(systemName: "ipad")
                .font(.system(size: 145))
            Text("iPad")
                .font(.system(size: 38).bold())
            
        }
        .foregroundColor(.white)
    }
    @ViewBuilder
    func MinimesdView() -> some View{
        VStack(spacing: 10){
            Image(systemName: "applewatch")
                .font(.system(size: 145))
            Text("Apple Watch")
                .font(.system(size: 38).bold())
            
        }
        .foregroundColor(.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
//Enum for current Dit State..
enum DotState {
    case normal
    case flipped
}
