
import Foundation
import Commandant
import Result

print("Hello, World! command Line tools")


struct ArgumentsError: Error {
    
}

/*
 
 VersionCheck check --a [architecture ...]    [path [--r]]
 
 -a  x86_64, i386, arm64, arm
 -r  recursive find framework
 
 */

struct CheckCommand: CommandProtocol {
    typealias Options = LogOptions
    
    typealias ClientError = ArgumentsError
    
    //    typealias Options = LogOptions
    //
    let verb = "check"
    let function = "check framework is validate"
    
    func run(_ options: Options) -> Result<(), ArgumentsError> {
        // Use the parsed options to do something interesting here.
        print(options)
        
        if #available(OSX 10.13, *) {
        launch(options.path, isRecursive: options.recursive, onliyHardware: options.onliyHardware)
        }
        
      //  func launch(_ path:  String, isRecursive: Bool, onliyHardware: [String])
        
        return Result<(), ArgumentsError>.init(value: ())
        //return ()
    }
}

struct LogOptions: OptionsProtocol {
    let onliyHardware: Bool
    let recursive: Bool
    let path: String
    
    static func create(_ onliyHardware: Bool) -> (Bool) -> (String) -> LogOptions {
        return { recursive in { path in LogOptions(onliyHardware: onliyHardware, recursive: recursive, path: path) } }
    }
    
    static func evaluate(_ m: CommandMode) -> Result<LogOptions, CommandantError<ArgumentsError>> {
        return create
            <*> m <| Option(key: "onliyHardware", defaultValue: false, usage: "only contain hardware  architectures")
            <*> m <| Option(key: "recursive", defaultValue: false, usage: "recursive find framework from folder")
            <*> m <| Argument(usage: "framework path")
    }
}

let commands = CommandRegistry<ArgumentsError>()
commands.register(CheckCommand())
//commands.register(VersionCommand())
//commands.register(CheckCommand())

commands.register(HelpCommand(registry: commands))
var arguments = CommandLine.arguments

// Remove the executable name.
assert(!arguments.isEmpty)
arguments.remove(at: 0)

if let verb = arguments.first {
    // Remove the command name.
    arguments.remove(at: 0)
    
    if let result = commands.run(command: verb, arguments: arguments) {
        // Handle success or failure.
    } else {
        // Unrecognized command.
    }
} else {
    // No command given.
    
}
