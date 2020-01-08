library(ff)
# creating the file
my.obj <- ff(vmode = "double", length = 10)
# modifying the file
my.obj[1:10] <- iris$Sepal.Width[1:10]

# create ff data frame
Girth <- ff(trees$Girth)
Height <- ff(trees$Height)
Volume <- ff(trees$Volume)

fftrees <- ffdf(Girth=Girth, Height=Height, Volume=Volume)
