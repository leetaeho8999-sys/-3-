package org.study.cafe.common;
public class Paging {
    private int nowPage=1,numPerPage=10,pagePerBlock=5,totalRecord,totalPage,offset,beginBlock,endBlock;
    public int getNowPage(){return nowPage;} public void setNowPage(int v){this.nowPage=v;}
    public int getNumPerPage(){return numPerPage;} public void setNumPerPage(int v){this.numPerPage=v;}
    public int getPagePerBlock(){return pagePerBlock;} public void setPagePerBlock(int v){this.pagePerBlock=v;}
    public int getTotalRecord(){return totalRecord;} public void setTotalRecord(int v){this.totalRecord=v;}
    public int getTotalPage(){return totalPage;} public void setTotalPage(int v){this.totalPage=v;}
    public int getOffset(){return offset;} public void setOffset(int v){this.offset=v;}
    public int getBeginBlock(){return beginBlock;} public void setBeginBlock(int v){this.beginBlock=v;}
    public int getEndBlock(){return endBlock;} public void setEndBlock(int v){this.endBlock=v;}
}
