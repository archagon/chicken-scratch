//
//  TodayViewController.swift
//  TextBox
//
//  Created by Alexei Baboulevitch on 2018-8-7.
//  Copyright © 2018 Alexei Baboulevitch. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding
{
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textViewScrollView: NSScrollView!
    @IBOutlet var effectViewContainer: NSView!
    @IBOutlet var effectView: NSVisualEffectView!
    @IBOutlet var effectTintView: NSView!
    @IBOutlet var buttonStackView: NSStackView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    @IBOutlet var barTopOffset: NSLayoutConstraint!

    override var nibName: NSNib.Name?
    {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: ["TextValue" : "🐓 Type some stuff, friend! 🐓"])
        //UserDefaults.standard.set(nil, forKey: "TextValue")
        
        //self.effectView.wantsLayer = true
        //self.effectView.layer?.cornerRadius = 8
        //self.effectView.layer?.masksToBounds = true
        self.effectViewContainer.wantsLayer = true
        self.effectViewContainer.layer?.cornerRadius = 8
        self.effectViewContainer.layer?.masksToBounds = true
        self.effectViewContainer.layer?.backgroundColor = nil

        self.effectView.alphaValue = 0.6
        self.effectTintView.wantsLayer = true
        self.effectTintView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.05).cgColor
        
        //let image = NSImage.init(named: "circle")!
        //image.capInsets = NSEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        //image.resizingMode = .stretch
        //self.effectView.maskImage = image
        
        self.textView.delegate = self
        self.textView.font = NSFont.systemFont(ofSize: 14)
        self.textView.string = UserDefaults.standard.string(forKey: "TextValue") ?? ""
        self.textView.scrollToEndOfDocument(nil)
        
        setupEmoji: do
        {
            let emoji = [ "•", "✅", "❎", "🕑", "⚠️", "🔷", "💜", "🛑" ]
            
            let subviews = self.buttonStackView.arrangedSubviews
            for view in subviews
            {
                self.buttonStackView.removeArrangedSubview(view)
            }
            
            for emojo in emoji
            {
                let button = InsetButton.init()
                button.bezelStyle = .recessed
                button.setButtonType(.momentaryPushIn)
                button.showsBorderOnlyWhileMouseInside = true
                button.title = emojo
                button.verticalPadding = 4
                
                button.target = self
                button.action = #selector(buttonTapped)
                
                self.buttonStackView.addArrangedSubview(button)
            }
            
            self.buttonStackView.spacing = 2
        }
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        resizeTextView()
        resizeInsets()
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        
        resizeTextView()
        resizeInsets()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        //let lastSnapshot = UserDefaults.standard.string(forKey: "LastSnapshot")
        //UserDefaults.standard.set(textView.string.hashValue, forKey: "LastSnapshot")
        //
        //if lastSnapshot?.hashValue != textView.string.hashValue
        //{
        //    self.textView.scrollToEndOfDocument(nil)
        //    completionHandler(.newData)
        //}
        //else
        //{
        //    completionHandler(.noData)
        //}
        completionHandler(.noData)
    }
    
    @objc func buttonTapped(_ sender: NSButton)
    {
        self.textView.insertText(sender.title)
    }
}

extension TodayViewController: NSTextViewDelegate
{
    func textDidChange(_ notification: Notification)
    {
        UserDefaults.standard.set(self.textView.string, forKey: "TextValue")
        
        resizeTextView()
    }
    
    func resizeTextView()
    {
        let rect = self.textView.layoutManager!.boundingRect(forGlyphRange: NSRange.init(location: 0, length: (self.textView.string as NSString).length), in: self.textView.textContainer!)
        
        self.textViewHeight.constant = min(max(50, rect.size.height), 250)
        
        // TODO: weird scroll bar behavior here
        
        resizeInsets()
    }
    
    func resizeInsets()
    {
        //let inset = self.buttonStackView.bounds.size.height
        //self.textView.textContainerInset = NSSize.init(width: 0, height: 4 + inset)
        //self.textViewScrollView.scrollerInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: 4 + inset, right: 0)

        //self.barTopOffset.constant = 0
        //self.textView.textContainerInset = NSSize.init(width: 0, height: 4)
        
        self.textViewScrollView.contentInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: 8, right: 0)
        self.textViewScrollView.scrollerInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: -8, right: 0)
    }
}

// https://stackoverflow.com/a/47240834/89812
class InsetButton: NSButton
{
    @IBInspectable var horizontalPadding: CGFloat = 0
    @IBInspectable var verticalPadding: CGFloat = 0
    
    override var intrinsicContentSize: NSSize
    {
        var size = super.intrinsicContentSize
        
        size.width += self.horizontalPadding
        size.height += self.verticalPadding
        
        return size;
    }
}

class BottomInsetTextView: NSTextView
{
    //override var textContainerOrigin: NSPoint
    //{
    //    return NSPoint.zero
    //}
}
