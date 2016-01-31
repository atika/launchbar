#!/usr/bin/env swift

// Redeem a Mac App Store promo code
// Dominique Da Silva
// Septembre 2015
// https://github.com/atika/launchbar


import Foundation
import Cocoa

let code = Process.arguments[1]
let urlstring = "macappstores://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/redeemLandingPage?code=\(code)"
let url = NSURL(string: urlstring)
// NSLog("URL %@", urlstring)

NSWorkspace.sharedWorkspace().openURL(url!)
