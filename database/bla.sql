select distinct(Hotel_Address)
from Hotel_Reviews_Collection
where Hotel_Address like '%Amsterdam%' and Hotel_Address NOT like '%Paris%'
