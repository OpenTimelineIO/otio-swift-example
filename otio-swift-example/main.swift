//
//  main.swift
//  otio-swift-example
//

import Foundation
import OpenTimelineIO

if CommandLine.arguments.count != 2 {
    print("Usage: \(CommandLine.arguments[0]) <file.otio>")
    exit(1)
}

let path = CommandLine.arguments[1]

let object: SerializableObject
do {
    object = try OpenTimelineIO.SerializableObject.fromJSON(filename: path)
} catch {
    print("Error: \(error)")
    exit(2)
}

print("Loaded OTIO file: \(path)")

guard let timeline = object as? OpenTimelineIO.Timeline
else {
    print("Error: \(object) is not a Timeline.")
    exit(3)
}

do {
    print("Timeline name: \(timeline.name)")
    print("Timeline duration: \(try timeline.duration().toTimecode())")

    print("Video Tracks:")
    if timeline.videoTracks.count == 0 {
        print("  No video tracks")
    }else{
        for track in timeline.videoTracks {
            print("  Track: \(track.name)")
            print("    Kind: \(track.kind)")
            print("    Duration: \(try track.duration().toTimecode())")

            for clip in track.children {
                print("  Clip: \(clip.name)")
                print("    Duration: \(try clip.duration().toTimecode())")
            }
        }
    }

    print("Audio Tracks:")
    if timeline.audioTracks.count == 0 {
        print("  No audio tracks")
    }else{
        for track in timeline.audioTracks {
            print("  Track: \(track.name)")
            print("    Kind: \(track.kind)")
            print("    Duration: \(try track.duration().toTimecode())")

            for clip in track.children {
                print("  Clip: \(clip.name)")
                print("    Duration: \(try clip.duration().toTimecode())")
            }
        }
    }

    // TODO: Recursive each_clip() or clip_if() is missing?
//    for clip in timeline.clip_if() {
//        print("  Clip: \(clip.name)")
//        print("    Duration: \(try clip.duration().toTimecode())")
//    }

} catch {
    print(error)
}
