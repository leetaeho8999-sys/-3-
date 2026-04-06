package org.study.brewcrm.common;

// 기존 프로젝트의 common/Paging.java와 완전히 동일
public class Paging {

    private int nowPage     = 1;   // 현재 페이지
    private int numPerPage  = 10;  // 페이지당 고객 수 (BBS는 4개, CRM은 10개)
    private int pagePerBlock = 5;  // 블록당 페이지 수
    private int totalRecord;       // 전체 고객 수
    private int totalPage;         // 전체 페이지 수
    private int offset;            // SQL OFFSET 값
    private int beginBlock;        // 현재 블록 시작 페이지
    private int endBlock;          // 현재 블록 끝 페이지

    public int getNowPage()      { return nowPage; }
    public void setNowPage(int nowPage) { this.nowPage = nowPage; }

    public int getNumPerPage()   { return numPerPage; }
    public void setNumPerPage(int numPerPage) { this.numPerPage = numPerPage; }

    public int getPagePerBlock() { return pagePerBlock; }
    public void setPagePerBlock(int pagePerBlock) { this.pagePerBlock = pagePerBlock; }

    public int getTotalRecord()  { return totalRecord; }
    public void setTotalRecord(int totalRecord) { this.totalRecord = totalRecord; }

    public int getTotalPage()    { return totalPage; }
    public void setTotalPage(int totalPage) { this.totalPage = totalPage; }

    public int getOffset()       { return offset; }
    public void setOffset(int offset) { this.offset = offset; }

    public int getBeginBlock()   { return beginBlock; }
    public void setBeginBlock(int beginBlock) { this.beginBlock = beginBlock; }

    public int getEndBlock()     { return endBlock; }
    public void setEndBlock(int endBlock) { this.endBlock = endBlock; }
}
