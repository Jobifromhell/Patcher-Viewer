import SwiftUI

struct StageElementView: View {
    let element: StageElement
    let size: CGSize

    var body: some View {
        Group {
            switch element.type {
            case "Riser":
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.1)
            case "Source":
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.05, height: element.height ?? size.height * 0.05)
            case "Patch":
                Rectangle()
                    .fill(Color.orange.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.05)
            case "Power":
                Rectangle()
                    .fill(Color.green.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.05)
            case "People":
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.05, height: element.height ?? size.height * 0.05)
            case "Wedge":
                Ellipse()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.05)
            case "IEM":
                Ellipse()
                    .fill(Color.purple.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.05)
            case "SideFill":
                Ellipse()
                    .fill(Color.yellow.opacity(0.5))
                    .frame(width: element.width ?? size.width * 0.1, height: element.height ?? size.height * 0.05)
            default:
                EmptyView()
            }
        }
        .rotationEffect(Angle(degrees: element.rotation))
        .position(x: size.width * element.positionXPercent, y: size.height * element.positionYPercent)
        .onAppear {
            print("Element Type: \(element.type)")
            print("Element Position: \(element.positionXPercent), \(element.positionYPercent)")
            print("Element Size: \(element.width ?? size.width * 0.1), \(element.height ?? size.height * 0.1)")
            print("Element Rotation: \(element.rotation)")
        }
    }
}

