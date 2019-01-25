//
//  main.swift
//  VersionCheck
//
//  Created by 李腾芳 on 2018/4/9.
//  Copyright © 2018年 李腾芳. All rights reserved.
//

import Foundation


/*
 
 
 --help
 
这个工具是用来检测framework合法性的， 检查其包含的指令集， XCode build 版本， 支持的最小iOS版本，支持的最新的iOS版本
 
 
 instruments [-t template] [-D document] [-l timeLimit] [-i #] [-w device] [[-p pid] | [application [-e variable value] [argument ...]]]
 
 VersionCheck check --a [architecture ...]    [path [--r]]
 
 -a  x86_64, i386, arm64, arm
 -r  recursive find framework
 */

var minimumOSVersion = ""
var DTXcodeBuild = ""
var DTPlatformVersion = ""

//print("**********  current versions 1.0.1 *************")

func readStandardPlist() {
    // read configure info from plist
    guard let configureDictionary = NSDictionary(contentsOfFile: FileManager.default.currentDirectoryPath.appending("/configure.plist")) else {
        print("unfind configure file")
        exit(1)
    }
    
    
    minimumOSVersion = configureDictionary["minimumOSVersion"] as! String
    DTXcodeBuild = configureDictionary["DTXcodeBuild"] as! String
    DTPlatformVersion = configureDictionary["DTPlatformVersion"] as! String
}

func parsingPathFromArguments(_ path:  String) -> URL {

    var baseURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    
    if path.hasPrefix("/") { // absolute path
        baseURL = URL(fileURLWithPath: path)
    } else { // relative path
        baseURL.appendPathComponent(path)
    }
    
    return baseURL
}

func startCheckFrameworkConfigure(_ path:  String, isRecursive: Bool, onliyHardware: Bool) {
    var isDirectory: ObjCBool = false
    let baseURL = parsingPathFromArguments(path)
    guard FileManager.default.fileExists(atPath: baseURL.path, isDirectory: &isDirectory) && isDirectory.boolValue  else {
        
        print("unExists file \(baseURL.path)")
        exit(1)
    }
    
    // let isRecursive: Bool
    // let onliyHardware: [String]
    let checkManager = CheckManager(baseURL: baseURL, isRecursive: isRecursive, onliyHardware: onliyHardware)
    checkManager.startCheck()
}


func launch(_ path:  String, isRecursive: Bool, onliyHardware: Bool) {
    readStandardPlist()
    startCheckFrameworkConfigure(path, isRecursive: isRecursive, onliyHardware: onliyHardware)

}





