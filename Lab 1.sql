--Part – A 
--1. Retrieve a unique genre of songs. 
select distinct * from songs
--2. Find top 2 albums released before 2010. 
select top 2 * 
from albums 
where Release_year<2010
--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005) 
insert into songs values(1245, 'Zaroor', 2.55, 'Feel good', 1005) 
select * from songs
--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
update songs
set song_title='Happy'
where song_title='Zaroor'
select * from songs
--5. Delete an Artist ‘Ed Sheeran’ 
delete from Artists
where Artist_name ='Ed Sheeran'
--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)] 
alter table songs
add Ratings decimal(3,2)
--7. Retrieve songs whose title starts with 'S'. 
select song_title from Songs where Song_title like('s%')
--8. Retrieve all songs whose title contains 'Everybody'.
select song_title from songs where song_title like('%everybody%')
--9. Display Artist Name in Uppercase. 
select upper(artist_name) from artists 
--10. Find the Square Root of the Duration of a Song ‘Good Luck’ 
select SQRT(duration)
from songs 
where song_title='Good Luck'
--11. Find Current Date. 
select GETDATE()
--12. Find the number of albums for each artist.
select count(al.album_id)
from  Artists ar
join albums al
on al.Artist_id=ar.Artist_id
group by ar.artist_id

--13. Retrieve the Album_id which has more than 5 songs in it. 
select album_id 
from songs
group by album_id
having count(*)>5

--14. Retrieve all songs from the album 'Album1'. (using Subquery) 
select * 
from albums
where album_title = (select Album_title
						from albums
						where Album_title='album1')
--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery) 
select * 
from albums al
join artists ar
on al.Artist_id=ar.Artist_id
where Artist_name=(select Artist_name
					from Artists
					where Artist_name='aparshakti khurana')

--16. Retrieve all the song titles with its album title. 
select song_title, album_title
from songs s
join albums al
on s.Album_id=al.Album_id

--17. Find all the songs which are released in 2020. 
select song_title
from songs s
join Albums al
on s.Album_id=al.Album_id
where Release_year=2020
--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.  
create view fav_songs
as select song_id
from songs
where song_id between 101 and 105
--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view. 
create  view fav
as select *
from songs

update fav
set Song_title ='Jannat' 
where song_id='101'

select * from fav
--20. Find all artists who have released an album in 2020.  
select * 
from Artists ar
join Albums al
on ar.Artist_id=al.Artist_id
where Release_year=2020
--21. Retrieve all songs by Shreya Ghoshal and order them by duration. 
select *
from Artists ar
join Albums al
on ar.Artist_id=al.Artist_id
join Songs s
on s.Album_id = al.Album_id
where ar.Artist_name='Shreya Ghoshal'
order by s.Duration

--Part – B 
--22. Retrieve all song titles by artists who have more than one album.
select s.Song_title
from songs s
join Albums al
on s.Album_id=al.Album_id
where al.Artist_id in (select Artist_id 
						from albums 
						group by Artist_id
						having count(album_id)>1)

--23. Retrieve all albums along with the total number of songs.
select al.album_title, count(s.song_id)
from albums al
join songs s
on al.Album_id = s.Album_id
group by al.Album_title
--24. Retrieve all songs and release year and sort them by release year.
select s.song_title, al.release_year
from Albums al
join Songs s
on al.Album_id=s.Album_id
order by al.Release_year
--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs. 
select count(song_id), genre
from songs
group by Genre
having count(song_id)>2
--26. List all artists who have albums that contain more than 3 songs.
select ar.Artist_name,al.Album_title,count(s.Song_id)
from Artists ar
join Albums al
on ar.Artist_id=al.Artist_id
join Songs s
on s.Album_id = al.Album_id
group by ar.Artist_name, al.Album_title
having COUNT(s.song_id)>3


--Part – C 
--27. Retrieve albums that have been released in the same year as 'Album4' 
select Album_title
from Albums
where Release_year = (select Release_year
						from Albums
						where Album_title='Album4')
--28. Find the longest song in each genre 
select max(duration),Genre
from songs
group by Genre

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title. 
select s.song_title,al.album_title
from songs s
join Albums al
on s.Album_id=al.Album_id
where al.Album_title like '%Album%'
--30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes. 
select sum(s.Duration),ar.artist_name
from songs s
inner join albums a
on s.Album_id = a.Album_id
inner join Artists ar
on a.Artist_id=ar.Artist_id
group by ar.Artist_name
having sum(s.Duration)<15