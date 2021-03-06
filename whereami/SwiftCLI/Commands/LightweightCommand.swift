//
//  LightweightCommand.swift
//  SwiftCLI
//
//  Created by Jake Heiser on 7/25/14.
//  Copyright (c) 2014 jakeheis. All rights reserved.
//

import Foundation

typealias CommandExecutionBlock = ((arguments: NSDictionary, options: Options) -> CommandResult)

class LightweightCommand: Command {
    
    var lightweightCommandName: String = ""
    var lightweightCommandSignature: String = ""
    var lightweightCommandShortDescription: String = ""
    var lightweightCommandShortcut: String? = nil
    var lightweightExecutionBlock: CommandExecutionBlock? = nil
    
    var shouldFailOnUnrecognizedOptions = true
    var shouldShowHelpOnHFlag = true
    var printingBehaviorOnUnrecognizedOptions: UnrecognizedOptionsPrintingBehavior = .PrintAll
    private var flagHandlingBlocks: [LightweightCommandFlagOptionHandler] = []
    private var keyHandlingBlocks: [LightweightCommandKeyOptionHandler] = []
    
    init(commandName: String) {
        super.init()
        
        lightweightCommandName = commandName
    }

    override func commandName() -> String  {
        return self.lightweightCommandName
    }
    
    override func commandSignature() -> String  {
        return self.lightweightCommandSignature
    }
    
    override func commandShortDescription() -> String  {
        return self.lightweightCommandShortDescription
    }
    
    override func commandShortcut() -> String?  {
        return self.lightweightCommandShortcut
    }
    
    // MARK: - Options
    
    func handleFlags(flags: [String], block: OptionsFlagBlock?, usage: String = "") {
        let handler = LightweightCommandFlagOptionHandler(flags: flags, flagBlock: block, usage: usage)
        self.flagHandlingBlocks.append(handler)
    }
    
    func handleKeys(keys: [String], block: OptionsKeyBlock?, usage: String = "", valueSignature: String = "value") {
        let handler = LightweightCommandKeyOptionHandler(keys: keys, keyBlock: block, usage: usage, valueSignature: valueSignature)
        self.keyHandlingBlocks.append(handler)
    }
    
    override func handleOptions()  {
        for handlingBlock in self.flagHandlingBlocks {
            self.onFlags(handlingBlock.flags, block: handlingBlock.flagBlock, usage: handlingBlock.usage)
        }
        
        for handlingBlock in self.keyHandlingBlocks {
            self.onKeys(handlingBlock.keys, block: handlingBlock.keyBlock, usage: handlingBlock.usage, valueSignature: handlingBlock.valueSignature)
        }
    }
    
    override func showHelpOnHFlag() -> Bool {
        return self.shouldShowHelpOnHFlag
    }
    
    override func unrecognizedOptionsPrintingBehavior() -> UnrecognizedOptionsPrintingBehavior {
        return self.printingBehaviorOnUnrecognizedOptions
    }
    
    override func failOnUnrecognizedOptions() -> Bool  {
        return self.shouldFailOnUnrecognizedOptions
    }
    
    // MARK: - Execution

    override func execute() -> CommandResult {
        return self.lightweightExecutionBlock!(arguments: self.arguments, options: self.options)
    }
    
    // MARK: - Option block wrappers
    
    class LightweightCommandFlagOptionHandler {
        let flags: [String]
        let flagBlock: OptionsFlagBlock?
        let usage: String
        
        init(flags: [String], flagBlock: OptionsFlagBlock?, usage: String) {
            self.flags = flags
            self.flagBlock = flagBlock
            self.usage = usage
        }
    }
    
    class LightweightCommandKeyOptionHandler {
        let keys: [String]
        let keyBlock: OptionsKeyBlock?
        let usage: String
        let valueSignature: String
        
        init(keys: [String], keyBlock: OptionsKeyBlock?, usage: String, valueSignature: String) {
            self.keys = keys
            self.keyBlock = keyBlock
            self.usage = usage
            self.valueSignature = valueSignature
        }
    }
}

