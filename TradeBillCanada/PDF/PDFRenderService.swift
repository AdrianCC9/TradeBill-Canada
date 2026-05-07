import Foundation
import UIKit

enum PDFRenderService {
    private static let singlePageLineItemLimit = 6
    private static let firstPageLineItemLimit = 15
    private static let continuationPageLineItemLimit = 24

    static func render(request: PDFRenderRequest) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: PDFLayout.pageBounds)
        return renderer.pdfData { context in
            if request.lineItems.count <= singlePageLineItemLimit {
                context.beginPage()
                drawFirstPage(
                    request: request,
                    lineItems: request.lineItems,
                    includeSummary: true,
                    pageNumber: 1
                )
                return
            }

            let lineItemPages = paginatedLineItems(request.lineItems)
            for (index, lineItems) in lineItemPages.enumerated() {
                context.beginPage()
                if index == 0 {
                    drawFirstPage(
                        request: request,
                        lineItems: lineItems,
                        includeSummary: false,
                        pageNumber: index + 1
                    )
                } else {
                    drawContinuationPage(
                        request: request,
                        lineItems: lineItems,
                        pageNumber: index + 1
                    )
                }
            }

            context.beginPage()
            drawSummaryPage(request: request, pageNumber: lineItemPages.count + 1)
        }
    }

    static func writeTemporaryPDF(request: PDFRenderRequest, filename: String) throws -> URL {
        let data = render(request: request)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: url, options: [.atomic])
        return url
    }

    private static func drawFirstPage(
        request: PDFRenderRequest,
        lineItems: [CalculationLineItem],
        includeSummary: Bool,
        pageNumber: Int
    ) {
        let bounds = PDFLayout.pageBounds
        drawAccentLine(in: bounds)

        var y = PDFLayout.margin
        let logoRect = CGRect(x: PDFLayout.margin, y: y - 4, width: 54, height: 54)
        let didDrawLogo = drawImage(from: request.logoURL, in: logoRect)
        let businessX = didDrawLogo ? PDFLayout.margin + 68 : PDFLayout.margin

        draw(request.businessName, at: CGPoint(x: businessX, y: y), font: .boldSystemFont(ofSize: 24), width: didDrawLogo ? 250 : 300)
        draw(request.documentType.uppercaseName, at: CGPoint(x: 410, y: y), font: .boldSystemFont(ofSize: 24), alignment: .right, width: 160)
        y += 30

        request.businessContactLines.prefix(5).forEach { line in
            draw(line, at: CGPoint(x: businessX, y: y), font: .systemFont(ofSize: 10), color: .darkGray, width: didDrawLogo ? 250 : 300)
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

        y = drawLineItems(lineItems, startingAt: y)

        if includeSummary {
            let totalsEndY = drawTotals(request: request, y: y + 22)
            drawFooterSections(request: request, y: totalsEndY + 22)
        } else {
            drawContinuationNotice(pageNumber: pageNumber)
        }

        drawPageNumber(pageNumber)
    }

    private static func drawContinuationPage(
        request: PDFRenderRequest,
        lineItems: [CalculationLineItem],
        pageNumber: Int
    ) {
        drawAccentLine(in: PDFLayout.pageBounds)
        draw(request.businessName, at: CGPoint(x: PDFLayout.margin, y: PDFLayout.margin), font: .boldSystemFont(ofSize: 14))
        draw("No. \(request.documentNumber)", at: CGPoint(x: 410, y: PDFLayout.margin), font: .systemFont(ofSize: 11), alignment: .right, width: 160)
        draw("Line items continued", at: CGPoint(x: PDFLayout.margin, y: 82), font: .boldSystemFont(ofSize: 13))
        drawTableHeader(y: 112)
        _ = drawLineItems(lineItems, startingAt: 112 + PDFLayout.rowHeight)
        drawContinuationNotice(pageNumber: pageNumber)
        drawPageNumber(pageNumber)
    }

    private static func drawSummaryPage(request: PDFRenderRequest, pageNumber: Int) {
        drawAccentLine(in: PDFLayout.pageBounds)
        draw(request.businessName, at: CGPoint(x: PDFLayout.margin, y: PDFLayout.margin), font: .boldSystemFont(ofSize: 14))
        draw("No. \(request.documentNumber)", at: CGPoint(x: 410, y: PDFLayout.margin), font: .systemFont(ofSize: 11), alignment: .right, width: 160)
        draw("Summary", at: CGPoint(x: PDFLayout.margin, y: 94), font: .boldSystemFont(ofSize: 18))
        let totalsEndY = drawTotals(request: request, y: 136)
        drawFooterSections(request: request, y: totalsEndY + 32)
        drawPageNumber(pageNumber)
    }

    private static func paginatedLineItems(_ lineItems: [CalculationLineItem]) -> [[CalculationLineItem]] {
        var pages: [[CalculationLineItem]] = []
        var startIndex = 0
        var limit = firstPageLineItemLimit

        while startIndex < lineItems.count {
            let endIndex = min(startIndex + limit, lineItems.count)
            pages.append(Array(lineItems[startIndex..<endIndex]))
            startIndex = endIndex
            limit = continuationPageLineItemLimit
        }

        return pages
    }

    private static func drawAccentLine(in bounds: CGRect) {
        UIColor(red: 0.094, green: 0.749, blue: 0.765, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: PDFLayout.accentHeight)).fill()
    }

    private static func drawLineItems(_ lineItems: [CalculationLineItem], startingAt startY: CGFloat) -> CGFloat {
        var y = startY
        lineItems.forEach { item in
            draw(item.description, at: CGPoint(x: PDFLayout.margin + 8, y: y + 6), font: .systemFont(ofSize: 10), width: 252)
            draw("\(NSDecimalNumber(decimal: item.normalizedQuantity))", at: CGPoint(x: 330, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 48)
            draw(CurrencyFormatter.string(from: item.normalizedUnitPrice), at: CGPoint(x: 390, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 70)
            draw(CurrencyFormatter.string(from: item.lineTotal), at: CGPoint(x: 486, y: y + 6), font: .systemFont(ofSize: 10), alignment: .right, width: 84)
            strokeLine(y: y + PDFLayout.rowHeight)
            y += PDFLayout.rowHeight
        }
        return y
    }

    private static func drawContinuationNotice(pageNumber: Int) {
        draw(
            "Continued on next page",
            at: CGPoint(x: PDFLayout.margin, y: 742),
            font: .systemFont(ofSize: 10),
            color: .darkGray
        )
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

    private static func drawTotals(request: PDFRenderRequest, y startY: CGFloat) -> CGFloat {
        var y = startY
        var rows: [(String, Decimal, Bool)] = [
            ("Subtotal", request.totals.subtotal, false)
        ]

        if request.totals.discountAmount > .zero {
            rows.append(("Discount", -request.totals.discountAmount, false))
        }

        rows.append(contentsOf: request.totals.taxLines.map { ("\($0.label) \($0.ratePercent)%", $0.amount, false) })

        if request.amountPaid > .zero {
            rows.append((request.documentType == .estimate ? "Deposit / Paid" : "Paid", -request.amountPaid, false))
        }

        rows.append(contentsOf: [
            ("Total", request.totals.total, true),
            ("Balance Due", request.totals.balanceDue, true)
        ])

        rows.forEach { label, amount, isBold in
            let font: UIFont = isBold ? .boldSystemFont(ofSize: 12) : .systemFont(ofSize: 11)
            draw(label, at: CGPoint(x: 360, y: y), font: font, color: isBold ? .black : .darkGray)
            draw(CurrencyFormatter.string(from: amount), at: CGPoint(x: 486, y: y), font: font, alignment: .right, width: 84)
            y += 18
        }

        return y
    }

    private static func drawFooterSections(request: PDFRenderRequest, y startY: CGFloat) {
        var y = startY

        if !request.notes.isEmpty || !request.terms.isEmpty {
            if !request.notes.isEmpty {
                draw("Notes", at: CGPoint(x: PDFLayout.margin, y: y), font: .boldSystemFont(ofSize: 11))
                draw(request.notes, at: CGPoint(x: PDFLayout.margin, y: y + 18), font: .systemFont(ofSize: 10), color: .darkGray, width: 250)
            }
            if !request.terms.isEmpty {
                draw("Terms", at: CGPoint(x: 330, y: y), font: .boldSystemFont(ofSize: 11))
                draw(request.terms, at: CGPoint(x: 330, y: y + 18), font: .systemFont(ofSize: 10), color: .darkGray, width: 240)
            }
            y += 108
        }

        if drawImage(from: request.signatureURL, in: CGRect(x: PDFLayout.margin, y: y + 18, width: 160, height: 58)) {
            draw("Signature", at: CGPoint(x: PDFLayout.margin, y: y), font: .boldSystemFont(ofSize: 11))
            y += 90
        }

        draw(
            "Thank you for your business.",
            at: CGPoint(x: PDFLayout.margin, y: max(y, 742)),
            font: .boldSystemFont(ofSize: 11),
            color: UIColor(red: 0.055, green: 0.561, blue: 0.580, alpha: 1)
        )
    }

    @discardableResult
    private static func drawImage(from url: URL?, in rect: CGRect) -> Bool {
        guard let url, let image = UIImage(contentsOfFile: url.path) else { return false }

        let imageAspectRatio = image.size.width / max(image.size.height, 1)
        let rectAspectRatio = rect.width / max(rect.height, 1)
        let drawRect: CGRect

        if imageAspectRatio > rectAspectRatio {
            let height = rect.width / imageAspectRatio
            drawRect = CGRect(x: rect.minX, y: rect.midY - height / 2, width: rect.width, height: height)
        } else {
            let width = rect.height * imageAspectRatio
            drawRect = CGRect(x: rect.midX - width / 2, y: rect.minY, width: width, height: rect.height)
        }

        image.draw(in: drawRect)
        return true
    }

    private static func drawPageNumber(_ pageNumber: Int) {
        draw("Page \(pageNumber)", at: CGPoint(x: 486, y: 760), font: .systemFont(ofSize: 9), color: .darkGray, alignment: .right, width: 84)
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
