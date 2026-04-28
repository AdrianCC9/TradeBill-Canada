import Foundation
import UIKit

enum PDFRenderService {
    static func render(request: PDFRenderRequest) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: PDFLayout.pageBounds)
        return renderer.pdfData { context in
            context.beginPage()
            drawPage(request: request)
        }
    }

    static func writeTemporaryPDF(request: PDFRenderRequest, filename: String) throws -> URL {
        let data = render(request: request)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: url, options: [.atomic])
        return url
    }

    private static func drawPage(request: PDFRenderRequest) {
        let bounds = PDFLayout.pageBounds
        UIColor(red: 0.094, green: 0.749, blue: 0.765, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: PDFLayout.accentHeight)).fill()

        var y = PDFLayout.margin
        draw(request.businessName, at: CGPoint(x: PDFLayout.margin, y: y), font: .boldSystemFont(ofSize: 24))
        draw(request.documentType.uppercaseName, at: CGPoint(x: 410, y: y), font: .boldSystemFont(ofSize: 24), alignment: .right, width: 160)
        y += 30

        request.businessContactLines.prefix(5).forEach { line in
            draw(line, at: CGPoint(x: PDFLayout.margin, y: y), font: .systemFont(ofSize: 10), color: .darkGray)
            y += 14
        }

        draw("No. \(request.documentNumber)", at: CGPoint(x: 410, y: PDFLayout.margin + 34), font: .systemFont(ofSize: 11), alignment: .right, width: 160)
        draw("Issue: \(DateFormatterFactory.shortDate.string(from: request.issueDate))", at: CGPoint(x: 410, y: PDFLayout.margin + 50), font: .systemFont(ofSize: 11), alignment: .right, width: 160)
        draw("Due: \(DateFormatterFactory.shortDate.string(from: request.dueDate))", at: CGPoint(x: 410, y: PDFLayout.margin + 66), font: .systemFont(ofSize: 11), alignment: .right, width: 160)

        y = 160
        draw("Bill To", at: CGPoint(x: PDFLayout.margin, y: y), font: .boldSystemFont(ofSize: 12))
        y += 18
        request.clientLines.prefix(5).forEach { line in
            draw(line, at: CGPoint(x: PDFLayout.margin, y: y), font: .systemFont(ofSize: 11))
            y += 15
        }

        y = 260
        if !request.title.isEmpty {
            draw(request.title, at: CGPoint(x: PDFLayout.margin, y: y), font: .boldSystemFont(ofSize: 14))
            y += 26
        }

        drawTableHeader(y: y)
        y += PDFLayout.rowHeight

        request.lineItems.prefix(12).forEach { item in
            draw(item.description, at: CGPoint(x: PDFLayout.margin, y: y + 6), font: .systemFont(ofSize: 10), width: 260)
            draw("\(NSDecimalNumber(decimal: item.quantity))", at: CGPoint(x: 330, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 48)
            draw(CurrencyFormatter.string(from: item.unitPrice), at: CGPoint(x: 390, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 70)
            draw(CurrencyFormatter.string(from: item.lineTotal), at: CGPoint(x: 486, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 84)
            strokeLine(y: y + PDFLayout.rowHeight)
            y += PDFLayout.rowHeight
        }

        y += 22
        drawTotals(request.totals, y: y)

        let footerY: CGFloat = 650
        if !request.notes.isEmpty {
            draw("Notes", at: CGPoint(x: PDFLayout.margin, y: footerY), font: .boldSystemFont(ofSize: 11))
            draw(request.notes, at: CGPoint(x: PDFLayout.margin, y: footerY + 18), font: .systemFont(ofSize: 10), color: .darkGray, width: 250)
        }
        if !request.terms.isEmpty {
            draw("Terms", at: CGPoint(x: 330, y: footerY), font: .boldSystemFont(ofSize: 11))
            draw(request.terms, at: CGPoint(x: 330, y: footerY + 18), font: .systemFont(ofSize: 10), color: .darkGray, width: 240)
        }

        draw("Thank you for your business.", at: CGPoint(x: PDFLayout.margin, y: 742), font: .boldSystemFont(ofSize: 11), color: UIColor(red: 0.055, green: 0.561, blue: 0.580, alpha: 1))
    }

    private static func drawTableHeader(y: CGFloat) {
        UIColor(red: 0.969, green: 0.980, blue: 0.980, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: PDFLayout.margin, y: y, width: 528, height: PDFLayout.rowHeight)).fill()
        draw("Description", at: CGPoint(x: PDFLayout.margin + 8, y: y + 7), font: .boldSystemFont(ofSize: 10))
        draw("Qty", at: CGPoint(x: 330, y: y + 7), font: .boldSystemFont(ofSize: 10), alignment: .right, width: 48)
        draw("Rate", at: CGPoint(x: 390, y: y + 7), font: .boldSystemFont(ofSize: 10), alignment: .right, width: 70)
        draw("Amount", at: CGPoint(x: 486, y: y + 7), font: .boldSystemFont(ofSize: 10), alignment: .right, width: 84)
        strokeLine(y: y + PDFLayout.rowHeight)
    }

    private static func drawTotals(_ totals: DocumentTotals, y startY: CGFloat) {
        var y = startY
        let rows: [(String, Decimal, Bool)] = [
            ("Subtotal", totals.subtotal, false),
            ("Discount", -totals.discountAmount, false)
        ] + totals.taxLines.map { ("\($0.label) \($0.ratePercent)%", $0.amount, false) } + [
            ("Total", totals.total, true),
            ("Balance Due", totals.balanceDue, true)
        ]

        rows.forEach { label, amount, isBold in
            let font: UIFont = isBold ? .boldSystemFont(ofSize: 12) : .systemFont(ofSize: 11)
            draw(label, at: CGPoint(x: 360, y: y), font: font, color: isBold ? .black : .darkGray)
            draw(CurrencyFormatter.string(from: amount), at: CGPoint(x: 486, y: y), font: font, alignment: .right, width: 84)
            y += 18
        }
    }

    private static func strokeLine(y: CGFloat) {
        UIColor(red: 0.867, green: 0.906, blue: 0.910, alpha: 1).setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: PDFLayout.margin, y: y))
        path.addLine(to: CGPoint(x: 570, y: y))
        path.lineWidth = 0.5
        path.stroke()
    }

    private static func draw(
        _ text: String,
        at point: CGPoint,
        font: UIFont,
        color: UIColor = .black,
        alignment: NSTextAlignment = .left,
        width: CGFloat = 300
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ]
        let rect = CGRect(x: point.x, y: point.y, width: width, height: 48)
        NSString(string: text).draw(with: rect, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil)
    }
}
