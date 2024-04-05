//import SwiftUI
//
//func getShape(for type: ElementType?) -> AnyShape {
//    guard let type = type else {
//        return AnyShape(Rectangle()) // Fournir une forme par défaut en cas de nil
//    }
//    switch type {
//    case /*.riser2x2, .riser3x2, .riser2x1, .riser4x3, */.riser:
//        return AnyShape(RoundedRectangle(cornerRadius: 1))
//    case .source, .wedge, .side/*, .monitor*/: // Assume .monitor similar to .wedge
//        return AnyShape(RoundedRectangle(cornerRadius: 5))
//    case .iem:
//        return AnyShape(RoundedRectangle(cornerRadius: 10))
//    case .patchBox, .musician, .powerOutlet:
//        return AnyShape(Circle())
//    }
//}
//
//func getColor(for type: ElementType?) -> Color {
//    guard let type = type else {
//        return .clear // Fournir une couleur par défaut en cas de nil
//    }
//    switch type {
//    case /*.riser2x2, .riser3x2, .riser2x1, .riser4x3,*/ .riser:
//        return .gray
//    case .source:
//        return .brown
//    case .patchBox:
//        return .orange
//    case .powerOutlet:
//        return .green
//    case .musician:
//        return .mint
//    case .iem, .wedge, .side/*, .monitor*/: // Add monitor here with similar color as wedge
//        return .blue
//    }
//}
//
//func getWidth(for type: ElementType) -> CGFloat {
//    switch type {
////    case .riser2x1:
////        return 200
////    case .riser4x3:
////        return 400
////    case .riser3x2:
////        return 300
//    case /*.riser2x2,*/ .riser:
//        return 200
//    case .source, .musician:
//        return 70
//    case .patchBox:
//        return 60
//    case .powerOutlet:
//        return 45
//    case .wedge/*, .monitor*/: // Assume monitor has the same width as wedge
//        return 70
//    case .iem:
//        return 60
//    case .side:
//        return 80
//    }
//}
//
//func getHeight(for type: ElementType) -> CGFloat {
//    switch type {
////    case .riser2x1:
////        return 100
////    case .riser4x3:
////        return 300
////    case .riser2x2, .riser3x2:
////        return 200
//    case .riser:
//        return 100
//    case .source, .musician:
//        return 70
//    case .patchBox:
//        return 60
//    case .powerOutlet:
//        return 80
//    case .iem:
//        return 60
//    case .wedge:
//        return 45
//    case .side:
//        return 80
//    }
//}
