#' @title Turn-In Report

#' @description Makes a data frame showing which students have turned in assignments of a given type.
#' 
#' @rdname SubmissionReport
#' @usage SubmissionReport(studentfile=NULL,folder=NULL,assigntype=NULL)
#' @param studentfile Text file containing student usernames, one per line.
#' @param folder path name to folder in Home directory that contains assignments of the desired type
#' @param assigntype substring of directory-name, indicating type of assignment
#' @return a data frame
#' @export
#' @author Homer White \email{hwhite0@@georgetowncollege.edu}
#' @examples
#' \dontrun{
#' SubmissionReport(studentfile="students.txt", folder="homework/mat331" ,assigntype="HW")
#' }
SubmissionReport <- function(studentfile=NULL,folder=NULL,assigntype=NULL) {
  
  if (is.null(studentfile) | is.null(folder) | is.null(assigntype) ) {
    stop("Must provide student file, assignment folder and code for the type of assignment.")
  }
  
  options(warn=-1) # suppress the warning message about incomplete final line in studentfile
  
  conn <- file(studentfile,"r")
  usernames <- readLines(con=conn)
  close(conn)
  
  #now clean up, for files created by pasting in from Windows:  needs testing
  usernames <- gsub(pattern='\\cM\\cJ|\\cM|\\cJ',replacement="\n",x=usernames,perl=TRUE)
  
  fr <- data.frame(usernames)
  
  typeDirs <- grep(assigntype,list.dirs(path=folder,full.names=FALSE,recursive=FALSE),
                   value=TRUE)
  
  for (dir in typeDirs) {
    
    foldernames <- character(length(usernames))
    for (i in 1:length(foldernames)) {
      foldernames[i] <- paste0(folder,"/",dir,"/",usernames[i])
    }
    
    temp <- data.frame(file.exists(foldernames))
    fr <- cbind(fr,temp)
  }
  
  names(fr) <- c("username",typeDirs)
  non.submissions <- length(typeDirs) - rowSums(as.matrix(fr[,2:(length(typeDirs)+1)]))
  fr <- cbind(fr,non.submissions)
  
  options(warn=0)
  
  return(fr)
  
}