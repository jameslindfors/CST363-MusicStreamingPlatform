create database music_streaming_platform;

-- SUBSCRIPTIONS
create table subscriptions (
    id serial primary key,
    name varchar(50) not null,
    price decimal(6,2) not null,
    duration_months integer not null,
    created_at timestamp default now(),
    updated_at timestamp default now() 
);

-- USERS
create table users (
    id serial primary key,
    name varchar(100) not null,
    email varchar(150) unique not null,
    subscription_id integer references subscriptions(id),
    created_at timestamp default now(),
    updated_at timestamp default now()
);

-- LABELS
create table labels (
    id serial primary key,
    name varchar(100) unique not null,
    created_at timestamp default now()
);

-- ARTISTS
create table artists (
    id serial primary key,
    name varchar(100) not null,
    bio text,
    country varchar(50),
    created_at timestamp default now()
);

-- ALBUMS
create table albums (
    id serial primary key,
    title varchar(150) not null,
    release_date date not null,
    label_id integer references labels(id),
    genre varchar(50),
    cover_url varchar(255),
    created_at timestamp default now()
);

-- ALBUM_ARTISTS
create table album_artists (
    album_id integer not null references albums(id) on delete cascade,
    artist_id integer not null references artists(id) on delete cascade,
    primary key (album_id, artist_id)
);

-- TRACKS
create table tracks (
    id serial primary key,
    title varchar(150) not null,
    duration integer not null, -- duration in seconds
    release_date date not null,
    album_id integer references albums(id),
    genre varchar(50),
    track_number integer,
    explicit boolean default false,
    audio_url varchar(255),
    created_at timestamp default now()
);

-- TRACK_ARTISTS
create table track_artists (
    track_id integer not null references tracks(id) on delete cascade,
    artist_id integer not null references artists(id) on delete cascade,
    primary key (track_id, artist_id)
);

-- PLAYLISTS
create table playlists (
    id serial primary key,
    user_id integer not null references users(id),
    title varchar(150) not null,
    description text,
    is_public boolean default false,
    created_at timestamp default now(),
    updated_at timestamp default now()
);

-- PLAYLIST_TRACKS
create table playlist_tracks (
    playlist_id integer not null references playlists(id) on delete cascade,
    track_id integer not null references tracks(id) on delete cascade,
    position integer not null,
    primary key (playlist_id, track_id)
);

-- LISTENING_HISTORIES
create table listening_histories (
    id serial primary key,
    user_id integer not null references users(id),
    track_id integer not null references tracks(id),
    played_at timestamp default now()
);

-- LISTENING_QUEUES
create table listening_queues (
    id serial primary key,
    user_id integer not null references users(id),
    track_id integer not null references tracks(id),
    position integer not null,
    added_at timestamp default now()
);

-- FAVORITE_TRACKS
create table favorite_tracks (
    id serial primary key,
    user_id integer not null references users(id),
    track_id integer not null references tracks(id),
    favorited_at timestamp default now()
);

-- FAVORITE_ALBUMS
create table favorite_albums (
    id serial primary key,
    user_id integer not null references users(id),
    album_id integer not null references albums(id),
    favorited_at timestamp default now()
);

-- EXAMPLE DATA

insert into subscriptions (name, price, duration_months) values
('free', 0.00, 0),
('premium', 9.99, 1);

insert into users (name, email, subscription_id) values
('alice', 'alice@example.com', 2),
('bob', 'bob@example.com', 1),
('carol', 'carol@example.com', 2),
('dave', 'dave@example.com', 1),
('eve', 'eve@example.com', 2),
('frank', 'frank@example.com', 1);

insert into labels (name) values
('universal music group'),
('indie vibes records');

insert into artists (name, bio, country) values
('luna waves', 'Ambient producer from the UK.', 'uk'),
('dj fox', 'Electronic dance music DJ.', 'usa'),
('nina vale', 'Indie singer-songwriter.', 'canada'),
('cosmic owl', 'Synthwave artist.', 'germany'),
('the lo-fi kid', 'Lo-fi hip hop producer.', 'japan'),
('midnight echo', 'Experimental electronic duo.', 'france');

insert into albums (title, release_date, label_id, genre, cover_url) values
('ocean dreams', '2023-06-15', 1, 'ambient', 'http://example.com/ocean.jpg'),
('sunset beats', '2024-03-20', 2, 'edm', 'http://example.com/sunset.jpg'),
('night ride', '2022-11-11', 2, 'synthwave', 'http://example.com/nightride.jpg'),
('quiet storms', '2023-01-05', 1, 'lo-fi', 'http://example.com/quietstorms.jpg');

insert into album_artists (album_id, artist_id) values
(1, 1), (2, 2), (2, 3), (3, 4), (4, 5);

insert into tracks (title, duration, release_date, album_id, genre, track_number, explicit, audio_url) values
('waveform', 210, '2023-06-15', 1, 'ambient', 1, false, 'http://example.com/audio/waveform.mp3'),
('deep blue', 195, '2023-06-15', 1, 'ambient', 2, false, 'http://example.com/audio/deepblue.mp3'),
('sunrise jam', 180, '2024-03-20', 2, 'edm', 1, false, 'http://example.com/audio/sunrisejam.mp3'),
('echo fire', 200, '2024-03-20', 2, 'edm', 2, true, 'http://example.com/audio/echofire.mp3'),
('cyberdrive', 230, '2022-11-11', 3, 'synthwave', 1, false, 'http://example.com/audio/cyberdrive.mp3'),
('neon fog', 220, '2022-11-11', 3, 'synthwave', 2, false, 'http://example.com/audio/neonfog.mp3'),
('rain notes', 175, '2023-01-05', 4, 'lo-fi', 1, false, 'http://example.com/audio/rainnotes.mp3'),
('coffee break', 160, '2023-01-05', 4, 'lo-fi', 2, false, 'http://example.com/audio/coffeebreak.mp3');

insert into track_artists (track_id, artist_id) values
(1, 1), (2, 1), (3, 2), (4, 2), (4, 3),
(5, 4), (6, 4), (7, 5), (8, 5);

insert into playlists (user_id, title, description, is_public) values
(1, 'morning calm', 'Relaxing ambient music.', true),
(2, 'party mode', 'Upbeat tracks for the night.', false),
(3, 'late night drive', 'Synthwave essentials.', true),
(4, 'study zone', 'Lo-fi beats to focus.', false);

insert into playlist_tracks (playlist_id, track_id, position) values
(1, 1, 1), (1, 2, 2), (2, 3, 1), (2, 4, 2),
(3, 5, 1), (3, 6, 2), (4, 7, 1), (4, 8, 2),
(2, 2, 3),
(3, 3, 2),
(4, 1, 4),
(1, 6, 3),
(2, 5, 4),
(3, 7, 3),
(1, 5, 4),
(2, 8, 5),
(4, 3, 2),
(3, 4, 4);


insert into listening_histories (user_id, track_id, played_at) values
(1, 1, now() - interval '1 day'),
(1, 2, now() - interval '2 hours'),
(2, 3, now() - interval '3 days'),
(3, 4, now() - interval '5 minutes'),
(4, 5, now() - interval '10 minutes'),
(5, 6, now() - interval '1 hour'),
(1, 3, '2024-04-20 08:57:13'),
(6, 4, '2024-04-28 23:17:42'),
(2, 5, '2024-05-05 00:48:29'),
(4, 8, '2024-04-18 17:46:38'),
(1, 1, '2024-04-25 16:39:39'),
(6, 1, '2024-04-17 08:47:32'),
(4, 5, '2024-04-15 20:50:56'),
(6, 3, '2024-04-15 10:23:09'),
(4, 7, '2024-05-01 06:53:28'),
(2, 7, '2024-04-24 15:16:57'),
(2, 3, '2024-04-27 11:37:19'),
(6, 5, '2024-05-07 04:32:10'),
(1, 6, '2024-04-29 13:17:55'),
(3, 2, '2024-04-19 18:44:59'),
(4, 6, '2024-04-19 10:52:04'),
(5, 8, '2024-04-23 04:17:39'),
(2, 6, '2024-04-21 14:07:58'),
(4, 3, '2024-05-02 09:42:31'),
(2, 4, '2024-05-06 02:33:05'),
(5, 2, '2024-04-30 19:12:17');


insert into listening_queues (user_id, track_id, position, added_at) values
(1, 3, 1, now()), (1, 4, 2, now()), (2, 1, 1, now()),
(3, 5, 1, now()), (4, 6, 1, now()), (5, 7, 1, now()),
(6, 6, 3, '2024-04-19 01:27:54'),
(1, 1, 1, '2024-04-23 03:43:09'),
(4, 3, 5, '2024-05-08 22:11:48'),
(2, 6, 1, '2024-04-21 18:00:18'),
(5, 4, 2, '2024-05-04 02:07:02'),
(3, 5, 2, '2024-04-13 21:03:17'),
(1, 7, 4, '2024-04-18 11:00:11'),
(5, 2, 3, '2024-04-15 08:43:32'),
(3, 2, 1, '2024-04-13 06:12:47'),
(4, 8, 5, '2024-04-27 17:03:22');

insert into favorite_tracks (user_id, track_id, favorited_at) values
(4, 1, '2025-05-07 14:18:30'),
(5, 2, '2024-04-22 08:51:11'),
(5, 4, '2024-04-25 13:06:29'),
(6, 7, '2024-04-24 02:58:02'),
(2, 8, '2024-05-04 10:04:00'),
(1, 3, '2024-04-21 19:39:15'),
(4, 3, '2024-04-14 20:06:31'),
(5, 6, '2024-04-13 10:03:29'),
(4, 4, '2024-04-22 18:27:57'),
(3, 1, '2024-05-08 14:42:05'),
(1, 6, '2024-04-23 01:35:26'),
(2, 5, '2024-05-01 07:08:35'),
(1, 7, '2025-05-10 14:59:12'),
(6, 4, '2024-04-30 20:22:02'),
(2, 7, '2024-04-29 06:09:42'),
(6, 6, '2024-04-12 03:24:56'),
(4, 8, '2024-04-13 14:50:43'),
(2, 2, '2024-04-27 03:17:38'),
(5, 1, '2024-04-15 20:18:48'),
(3, 5, '2024-04-30 11:50:07');

insert into favorite_albums (user_id, album_id) values
(1, 1), (2, 2), (3, 3), (4, 4);

-- Queries

-- Get artists from the tracks in a playlist
select 
    distinct a.name as artist_name,
    t.title as track_title,
    p.title as playlist_title
from 
    playlists p
inner join 
    playlist_tracks pt on p.id = pt.playlist_id
inner join 
    tracks t on pt.track_id = t.id
inner join 
    track_artists ta on t.id = ta.track_id
inner join 
    artists a on ta.artist_id = a.id
where 
    p.id = 1  -- Playlist ID
    and a.name is not null
order by 
    a.name, t.title;



-- Get the most played tracks by genre
select 
    t.genre, 
    t.title as track_title,
    count(lh.id) as play_count
from 
    listening_histories lh
inner join 
    tracks t on lh.track_id = t.id
where 
    t.genre is not null
group by 
    t.genre, t.title
having 
    count(lh.id) > 0
order by 
    play_count desc
limit 10;


-- Get user's listening history, track's artist, and most recent track played
select 
    distinct u.name as user_name,
    t.title as track_title,
    a.name as artist_name,
    lh.played_at
from 
    listening_histories lh
inner join 
    users u on lh.user_id = u.id
inner join 
    tracks t on lh.track_id = t.id
left outer join 
    track_artists ta on t.id = ta.track_id
left outer join 
    artists a on ta.artist_id = a.id
where 
    u.id = 1
    and lh.played_at = (
        select max(played_at)
        from listening_histories
        where user_id = u.id
    )
    and t.title is not null
order by 
    lh.played_at desc;


-- Get tracks in a playlist by genre and count of tracks per genre
select 
    t.genre,
    count(t.id) as track_count
from 
    playlist_tracks pt
inner join 
    tracks t on pt.track_id = t.id
where 
    pt.playlist_id = 1
    and t.genre is not null
group by 
    t.genre
having 
    count(t.id) > 1
order by 
    track_count desc;


-- Get tracks a user has favorited in the past 7 days
select 
    distinct u.name as user_name,
    t.title as track_title,
    ft.favorited_at
from 
    favorite_tracks ft
inner join 
    users u on ft.user_id = u.id
inner join 
    tracks t on ft.track_id = t.id
where 
    u.id = 1
    and ft.favorited_at between (current_date - interval '7 days') and current_date
    and t.title is not null
order by 
    ft.favorited_at desc;
