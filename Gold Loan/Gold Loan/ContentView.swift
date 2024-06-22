//
//  ContentView.swift
//  Gold Loan
//
//  Created by Kabir Soni  on 20/07/23.


import SwiftUI
import PDFKit

struct ContentView: View {
    
    @State var name = ""
    @State var mob = ""
    @State var Weight = ""
    @State var GoldPrice = ""
    @State var cutt = 0.7
    @State var interest = ""
    @State var interest2 = ""
    @State var day = ""
    @State var dayss = ""
    @State var div = ""
    @State var num1 = ""
    @State var num2 = ""
    @State private var birthdate = Date()
    @State private var age: (years: Int, months: Int, days: Int)?
    @State private var isShareSheetPresented = true
    
    
    
    
    // calculate gold price
    
    func amount() -> Double  {
        _ = String(((Double(Weight) ?? 0) * (Double(GoldPrice) ?? 0 )) / 10 )
        return ((Double(Weight) ?? 0) * (Double(GoldPrice) ?? 0)) / 10
    }
    
    // 30% of gold amount
    
    func cut() -> Double {
        _ = String((Double(amount())) * (Double(cutt)))
        return ((Double(amount() )) * (Double(cutt)))
    }
    
    func calint() -> Double {
        _ = String((Double(cut())) * (Double(interest2) ?? 0) / 100)
        return ((Double(cut())) * (Double(interest2) ?? 0) / 100)
    }
    
    func calint2() -> Double {
        _ = String((Double(calint())) / (Double(day) ?? 0))
        return ((Double(calint())) / (Double(day) ?? 0))
    }
    
    func calint3() -> Double {
        _ = String((Double(calint2())) * (Double(dayss) ?? 0))
        return ((Double(calint2())) * (Double(dayss) ?? 0))
    }
    
    func totalfinal() -> Double {
        _ = String((Double(cut())) + (Double(calint3())))
        return ((Double(cut())) + (Double(calint3())))
    }
    
    
    
    
    
    // Interest calculate date...
    
    func calculateAge() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdate, to: currentDate)
        if let years = ageComponents.year, let months = ageComponents.month, let days = ageComponents.day {
            age = (years, months, days)
        }
    }
    
    
    
    
    
    
    func generatePDFData() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "My App",
            kCGPDFContextAuthor: "My Name"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pdfData = NSMutableData()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 2,  width: 210, height: 297), format: format)
        
        
        let text = """
            
            
                                           || जय श्री राम ||
            
                                    -: Personal Information :-
            
                Name: \(name)
                Mobile Number: \(mob)
                Today Date: \(Date.now)
            
            
                                    -: Loan Information :-
            
                Weight: \(Weight)
                Gold Price: \(GoldPrice)
                Gold Amount: ₹ \(String(format: "%.2f", amount() ))
                Loan Gold Amount (30% cut): ₹ \(String(format: "%.2f", cut() ))
                
            
                                    -: Interest Information :-
            
                Interest Rate(Yearly): \(interest2) Month
            
                Starting Date: \(birthdate)
            
                Ending Date  : \(Date())
            
                Interest Period: \(age?.years ?? 0) Years \(age?.months ?? 0) Months \(age?.days ?? 0) Days
            
            ---> Final Amount: ₹\(String(format: "%.2f ", totalfinal()))
            
            
            
            """
        
        // for pdf to print
        let pdf = renderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8)
            ]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: CGRect(x: 0, y: 0, width: 500, height: 500))
        }
        
        pdfData.append(pdf)
        
        return pdfData as Data
    }
    
    
    
    var body: some View {
        
        NavigationView{
            
            Form{
                Section(header: Text ("Enter Gold information").bold().foregroundColor(Color.indigo)) {
                    TextField("Enter Customer Name", text: $name).keyboardType(.default).padding()
                    
                        .autocorrectionDisabled(true)
                    TextField("Mobile Number", text: $mob).keyboardType(.numberPad).padding()
                    TextField("Weight", text: $Weight).keyboardType(.decimalPad).padding()
                    TextField("Gold Price", text: $GoldPrice).keyboardType(.decimalPad).padding()
                    Text("Gold Amount :- ₹ \(amount(), specifier: "%.2f" ) ").padding().bold()
                }
                
                
                Section(header: Text("Loan Gold Amount (30% cut)").bold().foregroundColor(Color.indigo)) {
                    Text("₹ \(cut(), specifier: "%.2f")").foregroundColor(Color.red).bold()
                        .padding()
                }
                
                Section(header: Text("Date Selection").bold().foregroundColor(Color.indigo)) {
                    VStack {
                        Text("Select Interest Starting Date:")
                            .foregroundColor(Color.blue)
                            .font(.headline)
                            .padding()
                        
                        DatePicker("Birthdate", selection: $birthdate, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .padding()
                        
                        
                        Button("Calculate Date") {
                            calculateAge()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        if let age = age {
                            let totalDays = age.years * 365 + age.months * 30 + age.days
                            Text("\(totalDays) Days")
                                .bold()
                                .padding()
                        }
                    }
                    
                }.foregroundColor(Color.red)
                
                Section(header: Text("Interest Information").bold().foregroundColor(Color.indigo)) {
                    TextField("Interest Rate (Per Year) %",text: $interest2 ).keyboardType(.default).padding()
                    TextField("Per Year Days(365 days)",text: $day).keyboardType(.default).padding()
                    TextField(" Interest days ",text: $dayss).keyboardType(.default).padding()
                }
                
                Section(header: Text("Interest Rupees").bold().foregroundColor(Color.indigo)) {
                    Text("\(calint3(), specifier: "%.2f" ) ").padding().bold()
                }
                
                Section(header: Text("Total Amount With Interest").bold().foregroundColor(Color.indigo)) {
                    Text("\(totalfinal(), specifier: "%.2f")").padding().bold()
                }
                
                
                Button("Convert PDF") {
                    isShareSheetPresented = true
                    
                }
                
            }.navigationTitle("Gold Loan")
                .tint(.pink)
            
          
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use for iPhone
        .navigationViewStyle(DoubleColumnNavigationViewStyle()) // Use for iPad
        
        
        
        .sheet(isPresented: $isShareSheetPresented) {
            // Use the ShareSheet to present the share options
            ShareSheet(activityItems: [generatePDFData()], applicationActivities: nil)
            
        }
        
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    // ShareSheet to wrap UIActivityViewController
    struct ShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]
        let applicationActivities: [UIActivity]?
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }
    
    
    
}
    
    
  
