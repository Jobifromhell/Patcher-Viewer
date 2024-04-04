//
//  StagePlotView.swift
//  Patcher Viewer
//
//  Created by Olivier Jobin on 01/04/2024.
//

import SwiftUI

// Vue de l'élément de scène
import SwiftUI

struct StageElementView: View {
    let element: StageElement
    let size: CGSize
    
    var body: some View {
        Group {
            switch ElementType(rawValue: element.type) {
            case .riser2x1, .riser3x2, .riser4x3, .riser2x2:
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: size.width * 0.03, height: size.height * 0.03)
            case .source, .musician:
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: size.width * 0.05, height: size.height * 0.05) // Exemple de taille fixe
            case .patchBox, .powerOutlet:
                Rectangle()
                    .fill(Color.orange.opacity(0.5))
                    .frame(width: size.width * 0.03, height: size.height * 0.03)
            case .wedge, .iem, .side:
                Ellipse()
                    .fill(Color.green.opacity(0.5))
                    .frame(width: size.width * 0.04, height: size.height * 0.02)
            default:
                EmptyView()
            }
        }
        .rotationEffect(Angle(degrees: Double(element.rotation)))
        // Position est basée sur le pourcentage de la taille totale de la vue.
        .position(x: size.width * CGFloat(element.positionXPercent), y: size.height * CGFloat(element.positionYPercent))
    }
    //}
    
    // Exemple de struct ElementType pour illustrer l'utilisation. Adaptez selon votre modèle.
    enum ElementType: String {
        case riser4x3 = "Riser 4x3", riser3x2 = "Riser 3x2", riser2x2 = "Riser 2x2", riser2x1 = "Riser 2x1"
        case source = "Source", patchBox = "Patch Box", powerOutlet = "Power Outlet", musician = "Musician"
        case wedge = "Wedge", iem = "IEM", side = "SIDE"
    }
    
    func getShape(for type: ElementType?) -> AnyShape {
        guard let type = type else {
            return AnyShape(Rectangle()) // Fournir une forme par défaut en cas de nil
        }
        switch type {
        case.riser2x2, .riser3x2, .riser2x1, .riser4x3 :
            return AnyShape(RoundedRectangle(cornerRadius: 1))
        case /*.amplifier, .keys,*/.source, .wedge, .side:
            return AnyShape(RoundedRectangle(cornerRadius: 10))
        case .iem :
            return AnyShape(RoundedRectangle(cornerRadius: 25))
            
        case  .patchBox, .musician, .powerOutlet :
            return AnyShape(Circle())
        }
    }
    
    func getColor(for type: ElementType?) -> Color {
        guard let type = type else {
            return .clear // Fournir une couleur par défaut en cas de nil
        }
        switch type {
        case .riser2x2, .riser3x2, .riser2x1, .riser4x3:
            return .gray
        case /*.amplifier, .keys,*/ .source:
            return . brown
        case .patchBox:
            return .orange
        case .powerOutlet:
            return .green
        case .musician:
            return .black
        case .iem, .wedge, .side:
            return .blue
        }
    }
    
    func getWidth(for type: ElementType) -> CGFloat {
        switch type {
        case .riser2x1:
            return 200
        case .riser4x3:
            return 400
        case .riser3x2:
            return 300
        case .riser2x2:
            return 200
            //    case .amplifier:
            //        return 100
            //    case .keys:
            //        return 120
        case .source, .musician:
            return 60
        case .patchBox:
            return 60
        case .powerOutlet:
            return 45
        case .wedge:
            return 70
        case .iem:
            return 45
        case .side:
            return 45
            
        }
    }
    
    func getHeight(for type: ElementType) -> CGFloat {
        switch type {
        case .riser2x1:
            return 100
        case .riser4x3:
            return 300
        case .riser2x2:
            return 200
        case .riser3x2:
            return 200
            //    case .amplifier:
            //        return 60
            //    case .keys:
            //        return 40
        case .source, .musician:
            return 60
        case .patchBox:
            return 45
        case .wedge:
            return 45
        case .iem, .powerOutlet:
            return 45
        case .side:
            return 80
        }
    }
}

// Vue du stage plot
struct StagePlotView: View {
    let project: Project
    @Binding var categorySelections: [ElementType: Bool]
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGPoint(x: 0, y: 0)

    var body: some View {
        GeometryReader { geometry in
            let stageWidth = geometry.size.width * scale
            let stageHeight = geometry.size.height * scale

            ZStack {
                // Dessinez ici le contour de la scène basé sur les dimensions du projet
                Rectangle()
                    .stroke(lineWidth: 2)
                    .frame(width: stageWidth, height: stageHeight)
                    .background(Color.white)
                
                ForEach(project.stageElements) { element in
                    // Vérifiez si l'élément doit être affiché selon les sélections de catégorie
                    if categorySelections[ElementType(rawValue: element.type) ?? .source] ?? false {
                        StageElementView(element: element, size: CGSize(width: stageWidth, height: stageHeight))
                    }
                }
                Button(action: resetZoomAndPosition) {
                                  Text("Reset Zoom and Position")
                              }
                              .padding()
                              .background(Color.blue.opacity(0.8))
                              .foregroundColor(.white)
                              .cornerRadius(10)
                              .position(x: geometry.size.width / 2, y: geometry.size.height - 50) // Positionnez le bouton dans la vue
                          }
            }
            .scaledToFit()
            .scaleEffect(scale)
            .offset(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
            .animation(.default, value: scale)
            .animation(.default, value: dragOffset)
            .animation(.default, value: position)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / self.lastScaleValue
                        self.lastScaleValue = value
                        self.scale *= delta
                    }
                    .onEnded { _ in
                        self.lastScaleValue = 1.0
                    }
            )
            .gesture(
                DragGesture()
                    .updating($dragOffset, body: { (value, state, transaction) in
                        state = value.translation
                    })
                    .onEnded { value in
                        self.position.x += value.translation.width
                        self.position.y += value.translation.height
                    }
            )
        }
    
private func resetZoomAndPosition() {
        withAnimation {
            scale = 1.0
            position = CGPoint(x: 0, y: 0)
        }
    }
}

enum ElementType: String, Codable, CaseIterable, Hashable {
    case riser4x3 = "Riser 4x3"
    case riser3x2 = "Riser 3x2"
    case riser2x2 = "Riser 2x2"
    case riser2x1 = "Riser 2x1"

    case source = "Source"
    case patchBox = "Patch Box"
    case powerOutlet = "Power Outlet"
    case musician = "Musician"

    case wedge = "Wedge"
    case iem = "IEM"
    case side = "SIDE"
}
