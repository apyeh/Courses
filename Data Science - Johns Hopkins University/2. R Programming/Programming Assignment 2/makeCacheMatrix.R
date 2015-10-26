# R Programming, Programming Assignment 2, part 1
# by Andrew Yeh

## makeCacheMatrix function creates a list containing a function to do the following:
## 1. set the value of the matrix
## 2. get the value of the matrix
## 3. set the value of the matrix inverse
## 4. get the value of the matrix inverse

makeCacheMatrix <- function(x = matrix()) {
        inv <- NULL                        ## initialize value of inverse to NULL
        set <- function(y) {               ## create function 'set' whose arg y is the matrix passed to makeCacheMatrix function
                x <<- y                    ## and caches input matrix y to x
                inv <<- NULL               ## and sets inverse to NULL
        }
        get <- function() x                ## create function 'get' and assign vector x to it
        setinverse <- function(inverse) inv <<- inverse    ## create function 'setinverse'
        getinverse <- function() inv       ## create function getinverse and assign vector inv to it
        list(set = set, get = get,         ## lists the values of the functions within makeCacheMatrix function
             setinverse = setinverse,
             getinverse = getinverse)
}