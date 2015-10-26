# R Programming, Programming Assignment 2, part 2
# by Andrew Yeh

## Function to check if matrix inverse has already been calculated and is in cache.
## If not, function calculates the matrix inverse and places it into cache.

cacheSolve <- function(x, ...) {
        inv <- x$getinverse()                   ## retrieves value stored in cache (x) and assigns it to inv 
        if(!is.null(inv)) {                     ## if there already is a computed matrix inverse in cache,
                message("getting cached data")  ## print message "getting cached data"
                return(inv)                     ## and return the cached matrix
        }
        data <- x$get()                         ## If computed matrix inverse is not in cache already, 
        inv <- solve(data, ...)                 ## compute the matrix inverse
        x$setinverse(inv)                       ## and place the computed matrix inverse into cache.
        inv
}