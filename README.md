# threeviews
Three views of one problem

This is a set of R scripts in response to the article 

http://dirk.eddelbuettel.com/blog/2018/01/21/ by Dirk Eddelbuettel

and you should read this first, so that other approaches I have taken make more sense, as my comment has been jotting down the points of difference to the original.

It felt to me that the core approach was a very database based approach (based on joining datasets). While a database approach can be very flexible, it is machine intensive (less so for data table which is optimised for database approaches).

There are however, other ways of thinking about the problem:

Version 1 is a small tweak, rather than joining the data we are appending the needed extra entries.

Version 2 is a bigger difference, looking at it as a find and summarise rather than join and summarise problem.

Version 3 is a radical rethink, based on think about the data we have and the data we want to solve the problem.
