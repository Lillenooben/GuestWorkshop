//
//  ContentView.swift
//  GuestWorkshop
//
//  Created by Jesper Li on 2022-11-07.
//

import SwiftUI

struct GradientBackground : ViewModifier
{
    @State private var animateGradient = false
    
    func body(content: Content) -> some View
    {
        content
            .background(
            LinearGradient(colors: [.orange, .red, .purple],
                           startPoint: animateGradient ? .topLeading : .bottomLeading,
                           endPoint: animateGradient ? .bottomTrailing : .topTrailing)
            .onAppear{
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        )
    }
}

extension View
{
    func gradientBackgound() -> some View
    {
        modifier(GradientBackground())
    }
}



struct MovingCircles : View {
    
    @State private var scale = 0.2
    @State private var animate = false
    
    var body: some View
    {
        VStack
        {
            ZStack
            {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 210, height: 210)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true),
                               value: animate)
                Circle()
                    .fill(.white.opacity(0.5))
                    .frame(width: 170, height: 170)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true),
                               value: animate)
                Circle()
                    .fill(.white.opacity(0.5))
                    .frame(width: 120, height: 120)
                    .shadow(color: Color(.systemGray6), radius: 0)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 0.9).repeatForever(autoreverses: true),
                               value: scale)
            }
            .gradientBackgound()
            Button("Animate")
            {
                self.animate.toggle()   
                self.scale = self.animate ? 1.0 : 0.2
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
}

struct PictureView : View
{
    @State private var scale = false
    @State private var fade = false
    
    var body : some View
    {
        Image("dog")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .scaleEffect(scale ? 0.5 : 1.0)
            .opacity(fade ? 0.5 : 1.0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.5))
                {
                    self.scale.toggle()
                    self.fade.toggle()
                }
            }
    }
}

struct EmojiFaces : View
{
    let emojis = ["😀", "😄", "🙃", "😇", "👻"]
    
    var body : some View
    {
        TimelineView(.periodic(from: .now, by: 1)) {timeline in
            let randomEmoji = emojis.randomElement() ?? ""
            HStack
            {
                Text("\(timeline.date)")
                    .font(.caption2)
                Spacer()
                Text(randomEmoji)
                    .font(.largeTitle)
                    .scaleEffect(2.0)
            }
            .padding()
        }
    }
}

struct WaterDrop : Shape
{
    var height: Int
    
    private var heightAsDouble : Double
    
    var animatableData: Double
    {
        get { return heightAsDouble }
        set { heightAsDouble = newValue }
    }
    
    init (height : Int)
    {
        self.height = height
        self.heightAsDouble = Double(height)
    }
    
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: rect.width/2, y: CGFloat(heightAsDouble)), control: CGPoint(x: rect.width, y: CGFloat(heightAsDouble)))
        path.addQuadCurve(to: CGPoint(x: rect.width/2, y: 0), control: CGPoint(x: 0, y: CGFloat(heightAsDouble)))
        
        path.closeSubpath()
        
        return path
    }
}

struct WaterDropView : View
{
    var body: some View
    {
        TimelineView(.periodic(from: .now, by: 0.5))
        { timeline in
            
            let randomHeight = Int.random(in: 100...150)
            
            WaterDrop(height: randomHeight)
                .fill(
                    LinearGradient(colors: [.white, .blue],
                                   startPoint: .topLeading,
                                   endPoint: .bottom)
                )
                .animation(.default, value: randomHeight)
        }
        .frame(width: 100, height: 150)
    }
}

struct AsCardView : ViewModifier
{
    func body(content: Content) -> some View
    {
        HStack
        {
            Spacer()
            content
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .shadow(radius: 10)
        .cornerRadius(10)
        .listRowSeparator(.hidden)
        
    }
}

extension View
{
    func asCardView() -> some View
    {
        modifier(AsCardView())
    }
}

struct CardView <Content : View>: View
{
    let content : Content
    init(@ViewBuilder content: () -> Content)
    {
        self.content = content()
    }
    
    var body : some View
    {
        HStack
        {
            Spacer()
            content
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .shadow(radius: 10)
        .cornerRadius(10)
        .listRowSeparator(.hidden)
    }
}

struct ContentView: View
{
    var body: some View
    {
        NavigationStack
        {
            List
            {
                CardView
                {
                    MovingCircles()
                }
                //MovingCircles()
                    //.asCardView()
                PictureView()
                    .asCardView()
                EmojiFaces()
                    .asCardView()
                WaterDropView()
                    .asCardView()
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Animations!")
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
