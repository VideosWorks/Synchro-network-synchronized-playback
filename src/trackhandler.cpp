#include "trackhandler.h"
#include "iso639.h"

#include <QDebug>

TrackHandler::TrackHandler(mpv_handle *newMpvHandler, QObject *parent) : QObject(parent)
{
    mpvHandler = newMpvHandler;
}

void TrackHandler::updateTracks() 
{
    trackList.clear();
    // For each track (video, audio, or subtitle track)
    for (int i = 0; i < getTrackProperty("count").toInt(); i++) {
        // Initialize a track struct with all zero values
        Track track = {0};

        // Set properties
        // Plenty more to add here - see https://mpv.io/manual/master/#property-list
        track.id = getTrackProperty(QString::number(i) + "/id").toInt();

        track.type = getTrackProperty(QString::number(i) + "/type").toString();

        track.title = getTrackProperty(QString::number(i) + "/title").toString();
        if (track.title.isEmpty()) {
            track.title = "Track " + QString::number(track.id);
        }

        track.lang = getTrackProperty(QString::number(i) + "/lang").toString();
        
        track.codec = getTrackProperty(QString::number(i) + "/codec").toString();

        // Create a readable name for menus and such
        // Simple for now but much to be improved on in the future
        track.readable = track.title;

        // If track is audio or sub, add language to the end
        if (track.type != "video")
                track.readable += " - [" + iso639LanguageHash.value(track.lang) + "]";

        // Add to global track list
        trackList.append(track);
    }

}

QStringList TrackHandler::getAudioTrackList() {
    QStringList list;
    list.append("None");
    foreach (auto track, trackList) {
        if (track.type == "audio")
            list.append(track.readable);
    }
    return list;
}

QStringList TrackHandler::getSubTrackList() {
    QStringList list;
    list.append("None");
    foreach (auto track, trackList) {
        if (track.type == "sub")
            list.append(track.readable);
    }
    return list;
}

QStringList TrackHandler::getVideoTrackList() {
    QStringList list;
    list.append("None");
    foreach (auto track, trackList) {
        if (track.type == "video")
            list.append(track.readable);
    }
    return list;
}

QVariant TrackHandler::getTrackProperty(QString property) 
{
    return mpv::qt::get_property(mpvHandler, "track-list/" + property);
}
