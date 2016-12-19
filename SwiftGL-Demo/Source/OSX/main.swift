//
//  main.swift
//  SwiftGL-Demo
//
//  Created by Jerry Chan on 2015-02-23.
//  Copyright (c) 2015 Jerry Chan. All rights reserved.
//



//NSApplicationMain(Process.argc, Process.unsafeArgv)
UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(AppDelegate.self)
)
