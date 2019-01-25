//
//  CheckManager.swift
//  VersionCheck
//
//  Created by 李腾芳 on 2018/4/10.
//  Copyright © 2018年 李腾芳. All rights reserved.
//

import Cocoa
import Foundation

class CheckManager {
    let baseURL: URL
    let isRecursive: Bool
    let onliyHardware: Bool

    
    var subFilesString: [String] {
        if isRecursive {
            print("isRecursive")
            return try! FileManager.default.subpathsOfDirectory(atPath: baseURL.path)
            
        } else {
            print("unRecursive")
           return try! FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: [],options: [.skipsSubdirectoryDescendants])
                .map { $0.path }
            
         //   return ( FileManager.default.subpaths(atPath: baseURL.path))!
            
        }
    }
    
    func startCheck() {
        

        guard #available(OSX 10.13, *) else {
            return
        }
//
        var subFiles = subFilesString.map { URL(fileURLWithPath: $0, relativeTo: baseURL) }
        subFiles = subFiles.filter { $0.pathExtension == "framework" }
        
        guard subFiles.count > 0 else {
            print("unfind frameworks in \(baseURL)")
            exit(1)
        }
        
        
        if checkMinimumOSVersion(subFiles) {
            print("checkMinimumOSVersion sucess\n")
        }
        
        
        
        if checkXcodeVersion(subFiles) {
            print("checkXcodeVersion sucess\n")
        }
        
        
        
        if checkPlatformVersion(subFiles) {
            print("checkPlatformVersion sucess\n")
        }
        
   /*
        let swiftmodulesPath = subFiles.map { url -> (URL, String) in
            
            func getFrameworkName() -> String {
                var temp = url
                temp.deletePathExtension()
                
                return temp.lastPathComponent
            }
            
            let frameworkName = getFrameworkName()
            
            let result = url.appendingPathComponent("Modules/\(frameworkName).swiftmodule")
            return (result, frameworkName)
        }
        
        if checkModules(swiftmodulesPath) {
            print("checkModules sucess\n")
        }
    */
        execShellScript()
        exit(0)
      
    }

    init(baseURL: URL, isRecursive: Bool, onliyHardware: Bool) {
        self.baseURL = baseURL
        self.onliyHardware = onliyHardware
        self.isRecursive = isRecursive
    }

    private func checkPlistParameter(_ urls: [URL], key: String, isvalid: (String) -> Bool) -> Bool {
        var issucess = true
        urls.forEach { url in

            let dictionary = NSDictionary(contentsOf: url.appendingPathComponent("Info.plist"))!
            //  assert(Bool, String)
            let value = dictionary[key] as! String

            if !isvalid(value) {
                print("\(key) unvalid:\(value), url: \(url.path)")
                issucess = false
            } else {
            }
        }
        return issucess
    }

    private func checkMinimumOSVersion(_ urls: [URL]) -> Bool {
        return checkPlistParameter(urls, key: "MinimumOSVersion") { version -> Bool in
            version <= minimumOSVersion
        }
    }

    private func checkXcodeVersion(_ urls: [URL]) -> Bool {
        return checkPlistParameter(urls, key: "DTXcodeBuild") { version -> Bool in
            version == DTXcodeBuild
        }
    }

    private func checkPlatformVersion(_ urls: [URL]) -> Bool {
        return checkPlistParameter(urls, key: "DTPlatformVersion") { version -> Bool in
            version == DTPlatformVersion
        }
    }

    private func checkModules(_ modulesInfo: [(URL, String)]) -> Bool {
        var issucess = true
        let modules = ["x86_64.swiftmodule", "i386.swiftmodule", "arm64.swiftmodule", "arm.swiftmodule"]
        modulesInfo.forEach { url, frameworkName in
            modules.map { file -> URL in
                return url.appendingPathComponent(file)
            }
            .forEach { url in
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue {
                } else {
                    issucess = false
                    print("unExists file \(url.path) , frameworkName: \(frameworkName)")
                }
            }
        }
        return issucess
    }

    
    func execShellScript(){
       
        
        let task = Process()
        let pipe = Pipe()
        var filePath = baseURL.path
      //  filePath = (filePath.prefix(through: filePath.index(filePath.startIndex, offsetBy: 5))) as String
        task.standardOutput = pipe
        
        
        
         task.launchPath = "/bin/bash"
       
        task.arguments = [FileManager.default.currentDirectoryPath.appending("/checkCPU_codeSet.sh"), filePath, (isRecursive == true ? "true" : "false"), (onliyHardware == true ? "onliyHardware" : "___")
        ]
         
         task.launch()
     //   task.exit
        
       
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: String.Encoding.utf8)!
        
        print("*****************")
        print(output)
    }

}
