#' Add row colors of an object of ztable
#'
#' @param z An object of ztable
#' @param rows An integer vector indicating specific rows
#' @param bg A character vector indicating background color
#' @param color A character vector indicating color
#' @param condition Logical expression to select rows
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' z=ztable(head(iris))
#' z=addRowColor(z,c(1,3),color="platinum")
#' z
addRowColor=function(z,rows=NULL,bg=NULL,color=NULL,condition=NULL){
    if(!is.null(bg)){
    for(i in 1:length(bg)) bg[i]=validColor(bg[i])
    selected=NULL
    selected <- if (!missing(condition)) {
        e <- substitute(condition)
        r <- eval(e, z$x, parent.frame())
        if (!is.logical(r))
            stop("'subset' must be logical")
        selected=which(r & !is.na(r) )+1
    }
    rows=c(rows,selected)
    if(is.null(rows)) rows=1:(nrow(z$x)+1)
    if(length(rows)>length(bg)) bg=rep(bg,1+length(rows)/length(bg))
    for(i in 1:length(rows))
        for(j in 1:ncol(z$cellcolor))
            z$cellcolor[rows[i],j]=bg[i]
        z$zebra.type=3
        z$zebra=3
        if(is.null(z$rowcolor)) z$rowcolor=rep("white",nrow(z$cellcolor))
        for(j in 1:length(rows)) z$rowcolor[rows[j]]=bg[j]

    }
    if(!is.null(color)){
    for(i in 1:length(color)) color[i]=validColor(color[i])
    if(length(rows)>length(color)) color=rep(color,1+length(rows)/length(color))
    for(i in 1:length(rows))
        for(j in 1:ncol(z$frontcolor))
              z$frontcolor[rows[i],j]=color[i]
    }
    z
}

#' Add column colors of an object of ztable
#'
#' @param z An object of ztable
#' @param cols An integer vector indicating specific columns
#' @param bg A character vector indicating background color
#' @param color A character vector indicating color
#'@export
#' @examples
#' z=ztable(head(iris))
#' z=addColColor(z,c(1,3),color="platinum")
#' z
addColColor=function(z,cols=NULL,bg=NULL,color=NULL){
    cols <- if (missing(cols))
        1:(ncol(z$x)+1)
    else {
        nl <- as.list(seq_along(z$x))
        names(nl) <- names(z$x)
        result=tryCatch(class(cols),error=function(e) "error")
        add=0
        if(result=="error") add=1
        eval(substitute(cols), nl, parent.frame())+add
    }
    if(!is.null(bg)){
    for(i in 1:length(bg)) bg[i]=validColor(bg[i])
    if(length(cols)>length(bg)) bg=rep(bg,1+length(cols)/length(bg))
    for(j in 1:length(cols))
        for(i in 1:nrow(z$cellcolor))
            z$cellcolor[i,cols[j]]=bg[j]
    z$zebra.type=3
    z$zebra=3
    if(is.null(z$colcolor)) z$colcolor=rep("white",ncol(z$cellcolor))
    for(j in 1:length(cols)) z$colcolor[cols[j]]=bg[j]
    }
    if(!is.null(color)){
    for(i in 1:length(color)) color[i]=validColor(color[i])
    if(length(cols)>length(color)) color=rep(color,1+length(cols)/length(color))
    for(j in 1:length(cols))
        for(i in 1:nrow(z$frontcolor))
            z$frontcolor[i,cols[j]]=color[j]
    }
    z
}

#' Add column colors of an object of ztable
#'
#' @param z An object of ztable
#' @param rows An integer vector indicating specific rows
#' @param cols An integer vector indicating specific columns
#' @param bg A character vector indicating background color
#' @param color A character vector indicating color
#' @param condition Logical expression to select rows
#' @export
#' @examples
#' z=ztable(head(iris))
#' z=addRowColor(z,c(1,3),color="platinum")
#' z=addColColor(z,2,color="syan")
#' z=addCellColor(z,cols=c(5,4),rows=5,color="red")
#' z
addCellColor=function(z,rows=NULL,cols=NULL,bg=NULL,color=NULL,condition=NULL){
    selected=NULL
    selected <- if (!missing(condition)) {
        e <- substitute(condition)
        r <- eval(e, z$x, parent.frame())
        if (!is.logical(r))
            stop("'subset' must be logical")
        selected=which(r & !is.na(r) )+1
    }
    rows=c(rows,selected)
    if(is.null(rows)) rows=1:(nrow(z$x)+1)
    cols <- if (missing(cols))
        1:(ncol(z$x)+1)
    else {
        nl <- as.list(seq_along(z$x))
        names(nl) <- names(z$x)
        result=tryCatch(class(cols),error=function(e) "error")
        add=0
        if(result=="error") add=1
        eval(substitute(cols), nl, parent.frame())+add
    }
    # while(length(rows)!=length(cols)){
    #     if(length(rows)<length(cols)){
    #         rows=c(rows,rows)
    #         if(length(rows)>length(cols)) rows=rows[1:length(cols)]
    #     }
    #     if(length(rows)>length(cols)){
    #         cols=c(cols,cols)
    #         if(length(cols)>length(rows)) cols=cols[1:length(rows)]
    #     }
    # }
    if(!is.null(bg)){
    for(i in 1:length(bg)) bg[i]=validColor(bg[i])
    if(length(cols)>length(bg)) bg=rep(bg,1+length(cols)/length(bg))
    for(i in 1:length(rows)) {
        for(j in 1:length(cols)){
           z$cellcolor[rows[i],cols[j]]=bg[j]
        }
    }
    }
    if(!is.null(color)){
    for(i in 1:length(color)) color[i]=validColor(color[i])
    if(length(cols)>length(color)) color=rep(color,1+length(cols)/length(color))
    for(i in 1:length(rows)) {
        for(j in 1:length(cols)){
            z$frontcolor[rows[i],cols[j]]=color[j]
        }
    }
    # for(i in 1:length(cols)) {
    #     z$frontcolor[rows[i],cols[i]]=color[i]
    #     result=getspanRowLength(z,rows[i],cols[i])
    #
    #     if(!is.null(result)){
    #         if(result>1){
    #             for(j in 1:(result-1)) z$frontcolor[(rows[i]+j),cols[i]]=color[i]
    #         }
    #     }
    # }
    }
    z$zebra.type=3
    z$zebra=3
    z
}

#' Add column colors of an object of ztable
#'
#' @param z An object of ztable
#' @param rows An integer vector indicating specific rows
#' @param cols An integer vector indicating specific columns
#' @param color A character vector indicating color
#' @export
#' @examples
#' z=ztable(head(iris))
#' z=addFrontColor(z,rows=2:4,cols=c(2,4,6),color=c("red","green","blue"))
#' z
addFrontColor=function(z,rows,cols,color){
    for(i in 1:length(color)) color[i]=validColor(color[i])
    if(length(cols)>length(color)) color=rep(color,1+length(cols)/length(color))

    for(i in 1:length(rows)) {
        for(j in 1:length(cols)){
            z$frontcolor[rows[i],cols[j]]=color[j]
            result=getspanRowLength(z,rows[i],cols[j])
            if(!is.null(result)){
                if(result>1){
                    for(k in 1:(result-1)) z$frontcolor[(rows[i]+k),cols[j]]=color[j]
                }
             }
        }
    }
    z
}

#' Gets spanRow length
#'
#'@param z An object of ztable
#'@param i An integer indicating the row of specific cell
#'@param j An integer indicating the column of specific cell
#'@export
#'@return row count when spanRow starts, 0 when column spans.
getspanRowLength=function(z,i,j){
    if(is.null(z$spanRow)) return(NULL)
    newspan=z$spanRow
    for(k in 1:nrow(newspan)) {
        if(newspan[k,1]!=j) next
        if(newspan[k,2]>i) next
        if(newspan[k,2]==i) return(newspan[k,3]-newspan[k,2]+1)
        else if((newspan[k,2]<j) & (newspan[k,3]>=j)) return(0)
        else next
    }
    return(NULL)
}

#' Add column groups of an object of ztable
#'
#'@param z An object of ztable
#'@param cgroup A character vector or matrix indicating names of column group. Default value is NULL
#'@param n.cgroup A integer vector or matrix indicating the numbers of columns included in each cgroup
#'       Default value is NULL
#'@param color A character vector indicating the font color of each cells.
#'@param bg A character vector indicating the background color of each cells.
#'@param top Logical. Whether or not cgroup be placed at top.
#'@export
addcgroup=function(z,cgroup,n.cgroup,color="black",bg="white",top=FALSE){

    if(length(color)==1){
        color=rep(color,length(cgroup)+1)
    } else{
        color=c("black",color)
    }
    if(length(bg)==1){
        bg=rep(bg,length(cgroup)+1)
    } else{
        bg=c("white",bg)
    }

    if(length(z$cgroup)==0) {
        z$cgroup=list()
        z$cgroup[[1]]=cgroup
        z$cgroupcolor=list()
        z$cgroupcolor[[1]]=color
        z$cgroupbg=list()
        z$cgroupbg[[1]]=bg
        z$n.cgroup=list()
        z$n.cgroup[[1]]=n.cgroup
    } else{
        if(top){
            no=length(z$cgroup)
            for(i in no:1){
                z$cgroup[[no+1]]=z$cgroup[[no]]
                z$cgroupcolor[[no+1]]=z$cgroupcolor[[no]]
                z$cgroupbg[[no+1]]=z$cgroupbg[[no]]
                z$n.cgroup[[no+1]]=z$n.cgroup[[no]]
            }
            z$cgroup[[1]]=cgroup
            z$cgroupcolor[[1]]=color
            z$cgroupbg[[1]]=bg
            z$n.cgroup[[1]]=n.cgroup
        } else{
            no=length(z$cgroup)+1
            z$cgroup[[no]]=cgroup
            z$cgroupcolor[[no]]=color
            z$cgroupbg[[no]]=bg
            z$n.cgroup[[no]]=n.cgroup
        }
    }

    z
}

#' Add row groups of an object of ztable
#'
#'@param z An object of ztable
#'@param rgroup A character vector indicating names of row group. Default value is NULL
#'@param n.rgroup A integer vector indicating the numbers of rows included in each rgroup
#'       Default value is NULL
#'@param cspan.rgroup An integer indicating the column span of rgroup
#'@param color A character vector indicating the font color of rgroup.
#'@param bg A character vector indicating the background color of rgroup.
#'@export
addrgroup=function(z,rgroup,n.rgroup,cspan.rgroup=NULL,color="black",bg="white"){
    if(is.null(rgroup)) return(z)
    for(i in 1:length(rgroup)) {
        if(is.na(rgroup[i])) rgroup[i]=""
    }
    z$rgroup=rgroup
    z$n.rgroup=n.rgroup
    z$cspan.rgroup=cspan.rgroup
    if(length(bg)==1) bg=rep(bg,length(rgroup))
    if(length(color)==1) color=rep(color,length(rgroup))
    z$colcolor=rep(bg,ncol(z$cellcolor))
    z$rgroupcolor=color
    z$rgroupbg=bg
    z
}

#' Count the colgroup of an object of ztable
#'
#' @param z An object of class ztable
#' @return A vector indicating the position of colgroup
#'@export
colGroupCount=function(z){
    if(is.null(z$cgroup)) return(NULL)
    if(is.null(z$n.cgroup)) return(NULL)
    result=c()
    for(i in 1:length(z$n.cgroup)){
        count=0
        for(j in 1:length(z$n.cgroup[[i]])) {
            if(is.na(z$n.cgroup[[i]][j])) break
            count=count+z$n.cgroup[[i]][j]
            result=c(result,count)
        }
    }
    a=unique(result)
    a[order(a)]
}

#' Count the colspan of each colgroup
#'
#' @param z An object of ztable
#' @return A matrix indicating the column span occupied by each colgroup
#' @export
cGroupSpan=function(z){
    (vlines=align2lines(z$align))
    (colCount=colGroupCount(z))

    newCount=c()
    addrow=ifelse(z$include.rownames,1,0)
    for(i in 1:length(colCount)) {
        if(vlines[colCount[i]+1+addrow]==0) newCount=c(newCount,colCount[i])
    }
    newCount
    if(is.null(newCount)) return(z$n.cgroup)
    result=z$n.cgroup
    for(i in 1:length(z$n.cgroup)){
        start=0
        for(j in 1:length(z$n.cgroup[[i]])) {
            if(is.na(z$n.cgroup[[i]][j])) break
            end=start+z$n.cgroup[[i]][j]
            count=0
            for(k in 1:length(newCount)){
                if(newCount[k]>start & newCount[k]<end) count=count+1
            }
            result[[i]][j]=result[[i]][j]+count
            #cat("start=",start,",end=",end,",result[",i,",",j,"]=",result[i,j],"\n")
            start=end
        }
    }
    result
}

#' Print the head of latex table if the object of ztable has a colgroup
#'
#' @param z An object of ztable
#' @export
printLatexHead=function(z){
    if(is.null(z$cgroup)) return
    if(is.null(z$n.cgroup)) return
    #colCount=colGroupCount(z)
    ncount=ncol(z$x)
    addrow=ifelse(z$include.rownames,1,0)
    cGroupSpan=cGroupSpan(z)
    totalCol=totalCol(z)
    vlines=align2lines(z$align)
    #vlines=align2lines(getNewAlign(z))
    #vlines

    for(i in 1:length(z$cgroup)){
            colSum=0
            linecount=1
            if(z$include.rownames) {
                firstrow=cat(paste("\\cellcolor{",z$cgroupbg[[i]][1],"} &",sep=""))
                colSum=1
                linecount=1
            }
            for(j in 1:length(z$cgroup[[i]])) {
                if(is.na(z$cgroup[[i]][j])) break
                mcalign="c"
                if((j==1) & (addrow==0) & (vlines[linecount+1]>0))
                    for(k in 1:vlines[linecount+1]) mcalign=paste("|",mcalign,sep="")
                end=colSum+cGroupSpan[[i]][j]+1
                linecount=linecount+z$n.cgroup[[i]][j]
                if(vlines[linecount+1]>0)
                    for(k in 1:vlines[linecount+1]) mcalign=paste(mcalign,"|",sep="")
                second=paste("\\multicolumn{",cGroupSpan[[i]][j],"}{",mcalign,"}{",sep="")
                colSum=colSum+cGroupSpan[[i]][j]
                if(z$cgroupbg[[i]][j+1]!="white")
                    second=paste(second,"\\cellcolor{",z$cgroupbg[[i]][j+1],"}",sep="")
                if(z$cgroupcolor[[i]][j+1]!=z$color) {
                    second=paste(second,"\\color{",z$cgroupcolor[[i]][j+1],"}",sep="")
                }
                if(z$colnames.bold)
                    second=paste(second,"\\textbf{",z$cgroup[[i]][j],"}}",sep="")
                else second=paste(second,z$cgroup[[i]][j],"}",sep="")

                if(j!=1) second=paste("&",second,sep="")
                cat(second)
                if(linecount<(ncol(z$x)+1)) if(vlines[linecount+1]==0) cat("&")
            }
            cat("\\\\ \n")
            colSum=addrow+1
            start=1
            for(j in 1:length(z$cgroup[[i]])) {
                if(is.na(z$cgroup[[i]][j])) break
                if(z$cgroup[[i]][j]!="")
                    cat(paste("\\cline{",colSum,"-",colSum+cGroupSpan[[i]][j]-1,"}",sep=""))
                colSum=colSum+cGroupSpan[[i]][j]
                start=start+z$n.cgroup[[i]][j]
                if(j < length(z$cgroup[[i]])) if(vlines[start+1]==0) colSum=colSum+1

            }
            cat("\n")
    }
}


#' Calculating total columns of ztable
#'
#' @param z An object of ztable
totalCol=function(z){
    ncount=ncol(z$x)
    addrow=ifelse(z$include.rownames,1,0)
    result=ncount+addrow
    vlines=align2lines(z$align)
    if(!is.null(z$cgroup)) {
        colCount=colGroupCount(z)
        for(i in 1:(length(colCount)-1)) {
            if(vlines[colCount[i]+2]==0) result=result+1
        }
    }
    result
}

#' Merging data cells of ztable object in columns
#'
#' @param z An object of ztable
#' @param row An integer indicating the row of merging data cell
#' @param from An integer indicating start column of merging data cell
#' @param to An integer indicating end column of merging data cell
#' @param bg An optional character indicating the background color of merging cell
#' @param color An optional character indicating the font color of merging cell
#' @export
spanCol=function(z,row,from,to,bg=NULL,color=NULL){
    if(length(row)!=1) {
        warning("Only one row is permitted")
        return(z)
    }
    if(row<0 | (row > (nrow(z$x)+1))) {
        warning("Out of range : row")
        return(z)
    }
    if(from>to){
        warning("\"to\" must be equal to or greater than \"from\"")
        return(z)
    }
    if(is.null(z$spanCol)) z$spanCol=matrix(c(row,from,to),nrow=1)
    else z$spanCol=rbind(z$spanCol,c(row,from,to))
    #colnames(z$spanCol)=c("row","from","to")
    z=addCellColor(z,cols=from,rows=row,bg=bg,color=color)
    z
}


#' Merging data cells of ztable object in rows
#'
#' @param z An object of ztable
#' @param col An integer indicating the column of merging data cell
#' @param from An integer indicating start row of merging data cell
#' @param to An integer indicating end row of merging data cell
#' @param bg An optional character indicating the background color of merging cell
#' @param color An optional character indicating the font color of merging cell
#' @export
spanRow=function(z,col,from,to,bg=NULL,color=NULL){
    if(length(row)!=1) {
        warning("Only one row is permitted")
        return(z)
    }
    if(col<0 | col > (ncol(z$x)+1)) {
        warning("Out of range : col")
        return(z)
    }
    if(from>to){
        warning("\"to\" must be equal to or greater than \"from\"")
        return(z)
    }
    if(is.null(z$spanRow)) z$spanRow=matrix(c(col,from,to),nrow=1)
    else z$spanRow=rbind(z$spanRow,c(col,from,to))
    #colnames(z$spanRow)=c("col","from","to")
    #if(!is.null(color)) z=addCellColor(z,cols=col,rows=from,color=color)
    z=addCellColor(z,cols=col,rows=from,bg=bg,color=color)
    z
}

#' Identify the spanCol status of a cell
#'
#'@param z An object of ztable
#'@param i An integer indicating the row of specific cell
#'@param j An integer indicating the column of specific cell
#'@return column plus space count when spanCol starts, 0 when column spans,
#'        minus value when spanCol ends, NULL when no span.
isspanCol=function(z,i,j){
    if(is.null(z$spanCol)) return(NULL)
    newspan=getNewSpanCol(z)
    for(k in 1:nrow(newspan)) {
        if(newspan[k,1]!=i) next
        if(newspan[k,2]>j) next
        if(newspan[k,2]==j) return(newspan[k,3]-newspan[k,2]+1)
        else if((newspan[k,2]<j) & (z$spanCol[k,3]>=j)) return(0)
        else next
    }
    return(NULL)
}

#' Calculate the spanColWidth when spanCol start
#'
#'@param z An object of ztable
#'@param i An integer indicating the row of specific cell
#'@param j An integer indicating the column of specific cell
#
#'@return column count when spanCol start
spanColWidth=function(z,i,j){
    if(is.null(z$spanCol)) return(NULL)
    newspan=z$spanCol
    for(k in 1:nrow(newspan)) {
        if(newspan[k,1]!=i) next
        if(newspan[k,2]>j) next
        if(newspan[k,2]==j) return(newspan[k,3]-newspan[k,2]+1)
        else next
    }
    return(NULL)
}

#' Calculating new spanCol with spanCol plus space made by column group
#'
#'@param z An object of ztable
#'@export
getNewSpanCol=function(z){
    result=z$spanCol
    result1=result
    result1
    if(is.null(z$cgroup)) return(result)
    if(is.null(colGroupCount(z))) return(result)
    vlines=align2lines(z$align)
    vlines
    addcol=ifelse(z$include.rownames,1,0)

    #colCount=colGroupCount(z)+1
    colCount=colGroupCount(z)+addcol
    newCount=c()
    colCount
    for(i in 1:length(colCount)) {
        if(vlines[colCount[i]+1]==0) newCount=c(newCount,colCount[i])
    }
    if(is.null(newCount)) return(result)
    for(i in 1:nrow(result)) {
        for(j in 1:(length(newCount))) {
            if((result[i,2]<=newCount[j]) & (result[i,3]>newCount[j])) {
                result1[i,3]=result1[i,3]+1
            }
        }
    }
    return(result1)
}

#' Identify the spanRow status of a cell
#'
#'@param z An object of ztable
#'@param i An integer indicating the row of specific cell
#'@param j An integer indicating the column of specific cell
#'@return columns count plus spaces by rgroup when spanRow starts, 0 when row spans,
#'        minus value when spanRow ends, NULL when no span.
isspanRow=function(z,i,j){
    if(is.null(z$spanRow)) return(NULL)
    newspanRow=getNewSpanRow(z)
    for(k in 1:nrow(z$spanRow)) {
        if(z$spanRow[k,1]!=j) next
        if(z$spanRow[k,2]>i) next
        if(z$spanRow[k,2]==i) return(newspanRow[k,3]-newspanRow[k,2]+1)
        else if(z$spanRow[k,3]==i) return(-(newspanRow[k,3]-newspanRow[k,2]+1))
        else if((z$spanRow[k,2]<i) & (z$spanRow[k,3]>i)) return(0)
        else next
    }
    return(NULL)
}

#'Gets the spanRow start column
#'
#'@param z An object of ztable
#'@param i An integer indicating the row of specific cell
#'@param j An integer indicating the column of specific cell
#'
#'@return An integer indicating column where spanRow start. This function is for latex
#'        multirow
getspanRowData=function(z,i,j){
    for(k in 1:nrow(z$spanRow)) {
        if(z$spanRow[k,1]!=j) next
        if(z$spanRow[k,2]>=i) next
        if(z$spanRow[k,3]==i) return(z$spanRow[k,2])
    }
    return(NULL)
}

#' Calculating new spanRow with spanRow plus space made by row group
#'
#'@param z An object of ztable
getNewSpanRow=function(z){
    result=z$spanRow
    result1=result
    if(is.null(z$rgroup)) return(result)
    if(is.null(z$n.rgroup)) return(result)
    #colCount=colGroupCount(z)+1
    printrgroup=1
    if(!is.null(z$n.rgroup)){
        if(length(z$n.rgroup)>1) {
            for(i in 2:length(z$n.rgroup)) {
                printrgroup=c(printrgroup,printrgroup[length(printrgroup)]+z$n.rgroup[i-1])
            }
        }
    }
    for(i in 1:nrow(result)) {
        for(j in 2:(length(printrgroup))) {
            if((result[i,2]<=printrgroup[j]) & (result[i,3]>printrgroup[j])) {
                result1[i,3]=result1[i,3]+1
            }
        }
    }
    result1
}

#' Returns whether or not column with position start plus length is group column
#'
#' @param start An integer indicating start column position
#' @param length An integer indicating spanCol length
#' @param colCount An integer vector calculating from colGroupCount()
#' @export
isGroupCol=function(start,length,colCount){

    if(is.null(colCount)) return(0)
    newstart=start
    for(i in 1:length(colCount)){
        if(colCount[i]<start) newstart=start+1
    }
    result=colCount
    for(i in 1:length(colCount)){
        result[i]=colCount[i]+(i-1)+1
    }
    if((newstart+length) %in% result[-length(result)]) return(1)
    else return(0)
}

#' Add a adjunctive name below column name in a ztable
#'
#'@param z An object of ztable
#'@param subcolnames A charactor vector
#'@export
addSubColNames=function(z,subcolnames){
    if(length(subcolnames)!=length(z$x))
        warning("length of subconames is different from length of z$x")
    else z$subcolnames=subcolnames
    z
}

#' Add row color or cellcolor for rows or cells of p-value less than sigp in a ztable
#'
#'@param z An object of ztable
#'@param level A p-value
#'@param bg A character indicating background color
#'@param color A character indicating color
#'@export
addSigColor=function(z,level=0.05,bg="lightcyan",color="black"){

    if("ztable.mytable" %in% class(z))  {
        if(is.null(z$cgroup)){
            temp=z$x[[ncol(z$x)]]
            temp[temp=="< 0.001"]=0
            below05=which(as.numeric(temp)<level)+1
            if(length(below05)>0) {
                z1=addRowColor(z,rows=below05,bg=bg,color=color)
            } else{
                z1=z
            }
        } else{
            count=length(z$cgroup[[1]])-1
            count
            colpergroup=(ncol(z$x)-1)/count
            colpergroup
            z1<-z
            for(i in 2:(count+1)){
                pcol=1+colpergroup*(i-1)
                temp=z$x[[pcol]]
                temp[temp=="< 0.001"]=0
                below05=which(as.numeric(temp)<level)+1
                if(length(below05)>0) for(j in 1:length(below05))
                    z1=addCellColor(z1,rows=below05[j],
                                   cols=(pcol+1-(colpergroup-1)):(pcol+1),bg=bg,color=color)

            }
        }
    } else {
        if(!is.null(z$pcol)){
            temp=z$x[[z$pcol]]
            below05=which(as.numeric(temp)<level)+1
            if(length(below05)>0){
                z1=addRowColor(z,rows=below05,bg=bg,color=color)
            }  else{
                z1<-z
            }
        } else{
            z1=z
        }
    }
    z1
}
