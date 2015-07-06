
import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var decimalButton: UIButton!
    
    var userIsInTheMiddleOfTypingANumber = false
    let decimalSeparator = NSNumberFormatter().decimalSeparator!
    
    private var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decimalButton.setTitle(decimalSeparator, forState: UIControlState.Normal)
        display.text = " "
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if (digit == decimalSeparator) && (display.text!.rangeOfString(decimalSeparator) != nil) { return }
                if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
                if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {
                    if (display.text == "0") {
                        display.text = digit
                    } else {
                        display.text = "-" + digit
                    }
                } else {
                    display.text = display.text! + digit
                }
            } else {
                if digit == decimalSeparator {
                    display.text = "0" + decimalSeparator
                } else {
                    display.text = digit
                }
                userIsInTheMiddleOfTypingANumber = true
                history.text = brain.description != "?" ? brain.description : ""
            }
        }
        //println("digit = \(digit)");
        
       
    }
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if operation == "±" {
                    let displayText = display.text!
                    if (displayText.rangeOfString("-") != nil) {
                        display.text = dropFirst(displayText)
                    } else {
                        display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // error?
                displayValue = nil
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                // error?
                displayValue = nil
            }
        }
    }
    
    @IBAction func clear() {
        brain = CalculatorBrain()
        displayValue = nil
        history.text = ""
    }
    
    @IBAction func backSpace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if count(displayText) > 1 {
                display.text = dropLast(displayText)
                if (count(displayText) == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "-0"
                }
            } else {
                display.text = "0"
            }
        } else {
            if let result = brain.popOperand() {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func storeVariable(sender: UIButton) {
        if let variable = last(sender.currentTitle!) {
            if displayValue != nil {
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                if let result = brain.evaluateAndReportErrors() as? String {
                    display.text = result
                } else {
                    display.text = " "
                }
            }
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.description != "" ? brain.description + " =" : ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController
        }
        
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "show Graph":
                        gvc.program = brain.program
                        gvc.title = brain.description == "" ? "Graph" : brain.description.componentsSeparatedByString(", ").last
                default:
                    break
                }
            }
        }
    }
}

