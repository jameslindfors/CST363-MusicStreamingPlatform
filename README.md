# Music Streaming Platform
- @Author: James Lindfors
- @Date: 5/2/2025
- @Last Updated: 5/10/2025

## Overview - Problem Statement
The goal of this project is to design a database schema for a music streaming platform. The platform allows users to listen to music, create playlists, and manage their listening habits. Users can subscribe to different plans, which determine their access level and billing rate. The platform also tracks user engagement and playback habits to provide personalized recommendations.

Each user on the platform has a subscription, which defines their access level and billing rate. Subscriptions can be shared across many users, but each user may only have one active subscription at a time. Users also have listening behaviors tracked by the system, including a personal listening queue (tracks they intend to listen to), a listening history (tracks they have played), and a library of content they have favorited.

A user may favorite either tracks or albums, and each favorite is time-stamped to reflect when it was added. A favorite may refer to either a track, an album, or both, but it is not required to include both.

Each user can also create multiple playlists. A playlist belongs to one user and contains a sequential list of tracks. Each track in a playlist is stored with its position in the list. A playlist may be marked as public or private, and includes a title and optional description.

The music itself is organized into tracks, albums, artists, and labels:

Each track has metadata including title, duration (in seconds), release date, genre, and a flag to indicate if the content is explicit. It may optionally belong to an album but can also exist as a single. Each track must have at least one artist but may have multiple, such as in a collaboration. These artist-track relationships are stored in a join table.

Tracks may be grouped into albums, and each album can have multiple tracks. Albums also have associated metadata such as release date, genre, and cover image. Albums are produced by labels, with each label capable of releasing many albums. An album may also feature multiple artists. Just like tracks, the many-to-many relationship between albums and artists is stored in a separate join table.

Artists can appear on many albums and many tracks. Each artist has a name, an optional biography, and an associated country of origin.

The listening queue for a user contains an ordered list of tracks. Each track in the queue is assigned a position, indicating its order in playback. New tracks added to the queue are timestamped. The listening history logs when users have played specific tracks, recording both the user and the timestamp of the interaction.

Each record label has a unique identity and may be responsible for many albums and, by extension, many tracks. Labels do not own artists directly, but artists may appear on multiple albums across different labels.

The platform tracks user engagement and playback habits in order to support features such as personalized recommendations and public playlists. The database must be able to store detailed metadata about music content, support many-to-many relationships between entities (such as artists and tracks), and record temporal events like listening activity and content favoriting.

## Preliminary ERD 

![Initial ERD](data/initial_erd.png)

## Final ERD

TODO: Add final ERD normalized to 3NF.

## Solution Analysis

TODO: Add analysis of the solution, including any trade-offs made in the design.

## Highlighted Queries

### Listening Queue
Find all tracks in a user's listening queue, ordered by their position.

```sql
SELECT t.title, t.duration, t.release_date
FROM tracks t
JOIN listening_queue q ON t.track_id = q.track_id
WHERE q.user_id = ?
ORDER BY q.position;
```

## Highlighted Indexes

### Listening Queue

Users will frequently query their listening queue to see what tracks are next in line. To optimize this, we can create an index on the `user_id` column in the `listening_queue` table.

- Index on `user_id` in the `listening_queue` table to speed up queries that filter by user.

```sql
CREATE INDEX idx_user_id ON listening_queue(user_id);
```

### Listening History
Users may want to analyze their listening history to see what tracks they have played. To optimize this, we can create an index on the `track_id` column in the `listening_history` table.

- Index on `track_id` in the `listening_history` table to speed up queries that filter by track.

```sql
CREATE INDEX idx_track_id ON listening_history(track_id);
```