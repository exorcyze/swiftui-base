//
//  CPUMonitor.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 5/1/25.
//

import Foundation
import os

public class CPUMonitor {
    /*
    fileprivate static var loadPrevious: host_cpu_load_info?
    public static func cpuUsage() -> ( system: Double, user: Double, idle : Double, nice: Double ) {
        let load = hostCPULoadInfo();

        let usrDiff: Double = Double(load.cpu_ticks.0 - loadPrevious.cpu_ticks.0);
        let systDiff = Double(load.cpu_ticks.1 - loadPrevious.cpu_ticks.1);
        let idleDiff = Double(load.cpu_ticks.2 - loadPrevious.cpu_ticks.2);
        let niceDiff = Double(load.cpu_ticks.3 - loadPrevious.cpu_ticks.3);

        let totalTicks = usrDiff + systDiff + idleDiff + niceDiff
        print( "Total ticks is ", totalTicks );
        let sys = systDiff / totalTicks * 100.0
        let usr = usrDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0

        loadPrevious = load
        return (sys, usr, idle, nice);
    }
    private static func hostCPULoadInfo() -> host_cpu_load_info? {
        let  HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride / MemoryLayout<integer_t>.stride

        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)

        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
            host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
        }

        if result != KERN_SUCCESS{
            print( "CPU Load Error : kern_result_t = \(result)", module: .application, level: .error )
            return nil
        }
        let data = hostInfo.move()
        //hostInfo.deallocate(capacity: 1)
        hostInfo.deinitialize( count: 1 )
        return data
    }
    */
}
