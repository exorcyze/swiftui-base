//
//  MemoryMonitor.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 5/1/25.
//

import Foundation
import SwiftUI
import Charts

public class MemoryMonitor {

    public static var totalMemory: Float { Float( ProcessInfo.processInfo.physicalMemory ) / 1048576.0 }
    
    public static func reportMemory() -> Float {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t( MemoryLayout<task_vm_info>.size ) / 4
        let result: kern_return_t = withUnsafeMutablePointer( to: &taskInfo ) {
            $0.withMemoryRebound( to: integer_t.self, capacity: 1 ) {
                task_info( mach_task_self_, task_flavor_t(TASK_VM_INFO ), $0, &count )
            }
        }
        let usedMb = Float( taskInfo.phys_footprint ) / 1048576.0
        return result != KERN_SUCCESS ? 0 : usedMb
    }
}

struct MemoryData: Identifiable {
    let id = UUID()
    let value: Float
    let date: Date
}

@Observable
class MemoryUsageModel {
    var data = [MemoryData]()
    
    let pollFrequency: Double = 1.0
    
    var availableMb: Float = 50 // MemoryMonitor.totalMemory
    var latestUsageMb: Float { data.last?.value ?? 0 }
    var averageUsageMb: Float { data.reduce( 0 ) { $0 + $1.value } / Float( data.count ) }
    var maxUsageMb: Float { data.max { $0.value < $1.value }?.value ?? 0 }
    
    var averageUsagePercent: Float { averageUsageMb / availableMb * 100 }
    var maxUsagePercent: Float { maxUsageMb / availableMb * 100 }
    var latestUsagePercent: Float { latestUsageMb / availableMb * 100 }
    
    init() { scheduleReport() }
    
    private func scheduleReport() {
        data.append( MemoryData(value: MemoryMonitor.reportMemory(), date: Date() ) )
        DispatchQueue.main.asyncAfter( deadline: .now() + pollFrequency ) { [weak self] in self?.scheduleReport() }
    }
}

struct MemoryUsageChart: View {
    var model = MemoryUsageModel()
    let chartHeight: CGFloat = 200
    
    var body: some View {
        VStack( alignment: .leading, spacing: 8 ) {
            metricsGroup
            
            chartView
                .frame( height: chartHeight )
        }
        .padding( 16 )
    }
    
    var chartView: some View {
        Chart {
            ForEach( model.data ) { item in
                LineMark( x: .value( "Time", item.date ), y: .value( "Mb", item.value ) )
                    .foregroundStyle( Color.cyan.secondary )
                    .interpolationMethod( .linear )
            }
        }
        .chartXAxis {
            AxisMarks( position: .bottom, values: .stride( by: .second, count: 10 ) ) { value in
                AxisValueLabel( centered: true, anchor: .top, multiLabelAlignment: .center ) {
                    VStack( alignment: .center, spacing: 4 ) {
                        Circle()
                            .fill( .secondary )
                            .frame( width: 2, height: 4 )
                    }
                }
            }
        }
        .chartYScale( domain: 0...model.availableMb )
        .chartYAxis {
            AxisMarks( position: .leading ) { value in
                AxisGridLine( stroke: .init( dash: [ 2, 4 ] ) )
                AxisValueLabel {
                    Text( "\(value.as( Double.self ) ?? 0, specifier: "%.0f") Mb" )
                        .font( .system( size: 12 ) )
                }
            }
        }
    }
    
    var metricsGroup: some View {
        /*HStack( spacing: 32 ) {
            metricsInfo( value: model.averageUsageMb, metric: "Mb", title: "Average" )
            metricsInfo( value: model.maxUsageMb, metric: "Mb", title: "Max" )
            metricsInfo( value: model.latestUsageMb, metric: "Mb", title: "Current" )
            metricsInfo( value: model.availableMb, metric: "Mb", title: "Available" )
        }*/
        HStack( spacing: 32 ) {
            metricsInfo( value: model.averageUsagePercent, metric: "%", title: "Average" )
            metricsInfo( value: model.maxUsagePercent, metric: "%", title: "Max" )
            metricsInfo( value: model.latestUsagePercent, metric: "%", title: "Current" )
        }
    }
    
    @ViewBuilder
    private func metricsInfo( value: Float, metric: String, title: String ) -> some View {
        VStack( alignment: .leading, spacing: 0 ) {
            HStack( alignment: .lastTextBaseline, spacing: 4 ) {
                Text( "\(value, specifier: "%0.1f")" )
                    .font( .system( size: 20, weight: .medium ) )
                Text( metric )
                    .font( .system( size: 14, weight: .regular ) )
                    .foregroundStyle( .secondary )
            }
            Text( title )
                .font( .system( size: 14, weight: .regular ) )
                .foregroundStyle( .secondary )
        }
    }
}

#Preview {
    MemoryUsageChart()
}
