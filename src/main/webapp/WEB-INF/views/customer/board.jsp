<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle"  value="게시판 관리"/>
<c:set var="activeMenu" value="board"/>
<%@ include file="header.jsp" %>

<style>
  .tab-bar {
    display: flex;
    gap: 4px;
    margin-bottom: 22px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 0;
  }
  .tab-btn {
    padding: 9px 20px;
    font-size: 13px;
    font-weight: 600;
    color: var(--text-dim);
    background: none;
    border: none;
    border-bottom: 2px solid transparent;
    cursor: pointer;
    text-decoration: none;
    transition: color 0.15s, border-color 0.15s;
    margin-bottom: -1px;
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .tab-btn.active { color: var(--brown-hi); border-bottom-color: var(--brown-hi); }
  .tab-btn:hover  { color: var(--text); }
  .badge-count {
    background: rgba(180,100,220,0.75);
    color: #fff;
    font-size: 10px;
    font-weight: 700;
    padding: 1px 6px;
    border-radius: 10px;
    min-width: 18px;
    text-align: center;
  }
  .badge-warn {
    background: rgba(220,80,60,0.75);
  }

  .filter-bar {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 16px;
    flex-wrap: wrap;
  }
  .filter-bar input[type=text] {
    flex: 1; min-width: 160px; max-width: 280px;
    padding: 7px 12px;
    background: var(--bg-input);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: 13px;
  }
  .filter-bar select {
    padding: 7px 10px;
    background: var(--bg-input);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: 13px;
  }
  .filter-bar .btn-sm {
    padding: 7px 16px;
    font-size: 13px;
    font-weight: 600;
    border-radius: var(--radius);
    border: none;
    cursor: pointer;
  }
  .btn-search { background: var(--brown-hi); color: #fff; }
  .btn-reset2 { background: rgba(255,255,255,0.07); color: var(--text-dim); }

  .report-badge {
    display: inline-block;
    background: rgba(220,80,60,0.2);
    color: rgba(255,100,80,0.9);
    border: 1px solid rgba(220,80,60,0.3);
    font-size: 10px;
    font-weight: 700;
    padding: 1px 7px;
    border-radius: 10px;
  }

  .status-badge {
    font-size: 11px;
    font-weight: 700;
    padding: 2px 8px;
    border-radius: 10px;
    display: inline-block;
  }
  .status-PENDING   { background: rgba(220,160,40,0.18); color: rgba(240,200,60,0.9);  border: 1px solid rgba(220,160,40,0.3); }
  .status-PROCESSED { background: rgba(60,180,100,0.15); color: rgba(80,210,120,0.9);  border: 1px solid rgba(60,180,100,0.3); }
  .status-DISMISSED { background: rgba(150,150,150,0.12);color: rgba(180,180,180,0.7); border: 1px solid rgba(150,150,150,0.2); }

  .action-form { display: inline; }
  .btn-del   { background: rgba(220,60,50,0.18); color: rgba(255,100,80,0.9); border: 1px solid rgba(220,60,50,0.3); font-size:11px; padding:3px 10px; border-radius:6px; cursor:pointer; }
  .btn-rest  { background: rgba(60,180,100,0.15); color: rgba(80,210,120,0.9); border: 1px solid rgba(60,180,100,0.3); font-size:11px; padding:3px 10px; border-radius:6px; cursor:pointer; }
  .btn-proc  { background: rgba(60,140,220,0.15); color: rgba(100,180,255,0.9); border: 1px solid rgba(60,140,220,0.3); font-size:11px; padding:3px 10px; border-radius:6px; cursor:pointer; }
  .btn-dism  { background: rgba(150,150,150,0.12); color: rgba(180,180,180,0.8); border: 1px solid rgba(150,150,150,0.2); font-size:11px; padding:3px 10px; border-radius:6px; cursor:pointer; }

  .content-preview {
    max-width: 260px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: var(--text-dim);
    font-size: 12px;
  }

  .kpi-grid-sm {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    margin-bottom: 22px;
  }
  .kpi-sm {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 16px 18px;
    display: flex;
    align-items: center;
    gap: 14px;
  }
  .kpi-sm-icon { font-size: 22px; width: 40px; text-align: center; }
  .kpi-sm-val  { font-size: 22px; font-weight: 700; color: var(--text); }
  .kpi-sm-lbl  { font-size: 11px; color: var(--text-faint); }

  .pager { display: flex; justify-content: center; gap: 6px; margin-top: 16px; flex-wrap: wrap; }
  .pager a, .pager span {
    padding: 5px 11px;
    border-radius: 6px;
    font-size: 12px;
    color: var(--text-dim);
    background: var(--bg-card);
    border: 1px solid var(--border);
    text-decoration: none;
  }
  .pager a:hover   { background: var(--bg-hover); }
  .pager .cur      { background: var(--brown-hi); color: #fff; border-color: var(--brown-hi); font-weight: 700; }

  .deleted-row td  { opacity: 0.45; }
  .toast {
    position: fixed; bottom: 28px; right: 28px;
    background: var(--bg-card); border: 1px solid var(--border);
    border-left: 3px solid var(--brown-hi);
    color: var(--text); padding: 12px 20px;
    border-radius: var(--radius); box-shadow: var(--shadow);
    font-size: 13px; z-index: 9999;
    animation: slideIn 0.25s ease;
  }
  @keyframes slideIn { from { transform: translateX(40px); opacity:0; } to { transform: none; opacity:1; } }
</style>

<%-- 토스트 알림 --%>
<c:if test="${not empty param.deleted}">  <div class="toast" id="toast">게시글을 삭제했습니다.</div></c:if>
<c:if test="${not empty param.restored}"> <div class="toast" id="toast">게시글을 복구했습니다.</div></c:if>
<c:if test="${not empty param.done}">     <div class="toast" id="toast">신고를 처리했습니다.</div></c:if>

<%-- KPI 요약 --%>
<div class="kpi-grid-sm">
  <div class="kpi-sm">
    <div class="kpi-sm-icon">📋</div>
    <div>
      <div class="kpi-sm-val">${totalBoardCount}</div>
      <div class="kpi-sm-lbl">정상 게시글</div>
    </div>
  </div>
  <div class="kpi-sm">
    <div class="kpi-sm-icon">🗑</div>
    <div>
      <div class="kpi-sm-val">${deletedBoardCount}</div>
      <div class="kpi-sm-lbl">삭제된 게시글</div>
    </div>
  </div>
  <div class="kpi-sm">
    <div class="kpi-sm-icon">🚨</div>
    <div>
      <div class="kpi-sm-val" style="color:${pendingReportCount > 0 ? 'rgba(255,100,80,0.9)' : 'var(--text)'}">
        ${pendingReportCount}
      </div>
      <div class="kpi-sm-lbl">미처리 신고</div>
    </div>
  </div>
</div>

<%-- 탭 바 --%>
<div class="tab-bar">
  <a href="${pageContext.request.contextPath}/customer/board?tab=board"
     class="tab-btn ${tab == 'board' ? 'active' : ''}">
    📋 게시판 관리
  </a>
  <a href="${pageContext.request.contextPath}/customer/board?tab=reports"
     class="tab-btn ${tab == 'reports' ? 'active' : ''}">
    🚨 신고 게시물
    <c:if test="${pendingReportCount > 0}">
      <span class="badge-count badge-warn">${pendingReportCount}</span>
    </c:if>
  </a>
  <a href="${pageContext.request.contextPath}/customer/board?tab=users"
     class="tab-btn ${tab == 'users' ? 'active' : ''}">
    👤 신고 유저
  </a>
</div>

<%-- ══════════════════════════════════════════════
     탭 1: 게시판 관리
     ══════════════════════════════════════════════ --%>
<c:if test="${tab == 'board'}">

  <form method="get" action="${pageContext.request.contextPath}/customer/board" class="filter-bar">
    <input type="hidden" name="tab" value="board"/>
    <input type="text" name="keyword" value="${keyword}" placeholder="제목 또는 작성자 검색..."/>
    <select name="status">
      <option value=""       ${status == ''        ? 'selected' : ''}>전체</option>
      <option value="normal" ${status == 'normal'  ? 'selected' : ''}>정상</option>
      <option value="deleted"${status == 'deleted' ? 'selected' : ''}>삭제됨</option>
    </select>
    <button type="submit" class="btn-sm btn-search">검색</button>
    <a href="${pageContext.request.contextPath}/customer/board?tab=board" class="btn-sm btn-reset2">초기화</a>
    <span style="margin-left:auto;font-size:12px;color:var(--text-faint)">총 ${total}건</span>
  </form>

  <div class="glass-card">
    <table class="crm-table">
      <thead>
        <tr>
          <th style="width:50px;text-align:center">번호</th>
          <th style="width:70px">카테고리</th>
          <th>제목</th>
          <th>작성자</th>
          <th style="text-align:center;width:60px">조회</th>
          <th style="text-align:center;width:60px">댓글</th>
          <th style="text-align:center;width:60px">신고</th>
          <th style="width:130px">작성일</th>
          <th style="width:80px">상태</th>
          <th style="width:100px;text-align:center">관리</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty boards}">
            <tr><td colspan="10" class="empty-msg">게시글이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="b" items="${boards}">
              <tr class="${b.active == 1 ? 'deleted-row' : ''}">
                <td style="text-align:center;color:var(--text-faint)">${b.bIdx}</td>
                <td>
                  <span style="font-size:11px;padding:2px 7px;border-radius:6px;
                    background:rgba(255,255,255,0.06);color:var(--text-dim)">${b.category}</span>
                </td>
                <td class="td-name" style="max-width:220px">
                  <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;display:block">
                    ${b.title}
                    <c:if test="${b.active == 1}">
                      <span style="font-size:10px;color:rgba(255,80,60,0.7);margin-left:4px">[삭제됨]</span>
                    </c:if>
                  </span>
                </td>
                <td style="font-size:13px">${b.author}</td>
                <td style="text-align:center;color:var(--text-faint);font-size:12px">${b.views}</td>
                <td style="text-align:center;color:var(--text-faint);font-size:12px">${b.comments}</td>
                <td style="text-align:center">
                  <c:if test="${b.reportCount > 0}">
                    <span class="report-badge">${b.reportCount}</span>
                  </c:if>
                  <c:if test="${b.reportCount == 0}">
                    <span style="color:var(--text-faint);font-size:11px">—</span>
                  </c:if>
                </td>
                <td class="td-faint" style="font-size:11px">${b.regDate}</td>
                <td>
                  <c:choose>
                    <c:when test="${b.active == 0}">
                      <span style="font-size:11px;color:rgba(80,210,120,0.8)">정상</span>
                    </c:when>
                    <c:otherwise>
                      <span style="font-size:11px;color:rgba(255,100,80,0.7)">삭제</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td style="text-align:center">
                  <c:choose>
                    <c:when test="${b.active == 0}">
                      <form class="action-form" method="post"
                            action="${pageContext.request.contextPath}/customer/board/delete"
                            onsubmit="return confirm('이 게시글을 삭제하시겠습니까?')">
                        <input type="hidden" name="bIdx"    value="${b.bIdx}"/>
                        <input type="hidden" name="page"    value="${page}"/>
                        <input type="hidden" name="keyword" value="${keyword}"/>
                        <button type="submit" class="btn-del">삭제</button>
                      </form>
                    </c:when>
                    <c:otherwise>
                      <form class="action-form" method="post"
                            action="${pageContext.request.contextPath}/customer/board/restore">
                        <input type="hidden" name="bIdx" value="${b.bIdx}"/>
                        <input type="hidden" name="page" value="${page}"/>
                        <button type="submit" class="btn-rest">복구</button>
                      </form>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <%-- 페이지네이션 --%>
  <c:if test="${totalPage > 1}">
    <div class="pager">
      <c:if test="${page > 1}">
        <a href="${pageContext.request.contextPath}/customer/board?tab=board&page=${page-1}&keyword=${keyword}&status=${status}">‹</a>
      </c:if>
      <c:forEach begin="1" end="${totalPage}" var="p">
        <c:choose>
          <c:when test="${p == page}"><span class="cur">${p}</span></c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/customer/board?tab=board&page=${p}&keyword=${keyword}&status=${status}">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
      <c:if test="${page < totalPage}">
        <a href="${pageContext.request.contextPath}/customer/board?tab=board&page=${page+1}&keyword=${keyword}&status=${status}">›</a>
      </c:if>
    </div>
  </c:if>
</c:if>

<%-- ══════════════════════════════════════════════
     탭 2: 신고 게시물
     ══════════════════════════════════════════════ --%>
<c:if test="${tab == 'reports'}">

  <form method="get" action="${pageContext.request.contextPath}/customer/board" class="filter-bar">
    <input type="hidden" name="tab" value="reports"/>
    <select name="status">
      <option value=""          ${status == ''          ? 'selected' : ''}>전체 상태</option>
      <option value="PENDING"   ${status == 'PENDING'   ? 'selected' : ''}>미처리</option>
      <option value="PROCESSED" ${status == 'PROCESSED' ? 'selected' : ''}>처리완료</option>
      <option value="DISMISSED" ${status == 'DISMISSED' ? 'selected' : ''}>기각</option>
    </select>
    <select name="targetType">
      <option value=""       ${targetType == ''        ? 'selected' : ''}>전체 유형</option>
      <option value="POST"   ${targetType == 'POST'    ? 'selected' : ''}>게시글</option>
      <option value="COMMENT"${targetType == 'COMMENT' ? 'selected' : ''}>댓글</option>
    </select>
    <button type="submit" class="btn-sm btn-search">조회</button>
    <a href="${pageContext.request.contextPath}/customer/board?tab=reports" class="btn-sm btn-reset2">초기화</a>
    <span style="margin-left:auto;font-size:12px;color:var(--text-faint)">총 ${total}건</span>
  </form>

  <div class="glass-card">
    <table class="crm-table">
      <thead>
        <tr>
          <th style="width:50px;text-align:center">번호</th>
          <th style="width:70px">유형</th>
          <th>대상 제목/내용</th>
          <th>피신고자</th>
          <th>신고자</th>
          <th>신고 사유</th>
          <th style="width:80px;text-align:center">상태</th>
          <th style="width:120px">신고일</th>
          <th style="width:180px;text-align:center">처리</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty reports}">
            <tr><td colspan="9" class="empty-msg">신고 내역이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="r" items="${reports}">
              <tr>
                <td style="text-align:center;color:var(--text-faint)">${r.rIdx}</td>
                <td>
                  <c:choose>
                    <c:when test="${r.targetType == 'POST'}">
                      <span style="font-size:11px;padding:2px 7px;border-radius:6px;
                        background:rgba(60,140,220,0.15);color:rgba(100,180,255,0.9)">게시글</span>
                    </c:when>
                    <c:otherwise>
                      <span style="font-size:11px;padding:2px 7px;border-radius:6px;
                        background:rgba(180,100,220,0.15);color:rgba(204,136,238,0.9)">댓글</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div style="font-size:12px;font-weight:600;color:var(--text);margin-bottom:2px;
                    max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                    ${r.targetTitle}
                  </div>
                  <div class="content-preview">
                    <c:choose>
                      <c:when test="${fn:length(r.targetContent) > 60}">
                        ${fn:substring(r.targetContent, 0, 60)}...
                      </c:when>
                      <c:otherwise>${r.targetContent}</c:otherwise>
                    </c:choose>
                  </div>
                </td>
                <td style="font-size:13px;font-weight:600">${r.targetAuthor}</td>
                <td style="font-size:12px;color:var(--text-dim)">${r.reporter}</td>
                <td style="font-size:12px;color:var(--text-dim);max-width:140px;
                  overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                  <c:choose>
                    <c:when test="${not empty r.reason}">${r.reason}</c:when>
                    <c:otherwise><span style="color:var(--text-faint)">—</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="text-align:center">
                  <span class="status-badge status-${r.status}">
                    <c:choose>
                      <c:when test="${r.status == 'PENDING'}">미처리</c:when>
                      <c:when test="${r.status == 'PROCESSED'}">처리완료</c:when>
                      <c:otherwise>기각</c:otherwise>
                    </c:choose>
                  </span>
                </td>
                <td class="td-faint" style="font-size:11px">${r.regDate}</td>
                <td style="text-align:center">
                  <c:if test="${r.status == 'PENDING'}">
                    <form class="action-form" method="post"
                          action="${pageContext.request.contextPath}/customer/board/deleteReported"
                          onsubmit="return confirm('게시글을 삭제하고 신고를 처리 완료로 변경합니까?')">
                      <input type="hidden" name="rIdx" value="${r.rIdx}"/>
                      <input type="hidden" name="page" value="${page}"/>
                      <button type="submit" class="btn-del" style="margin-right:4px">삭제처리</button>
                    </form>
                    <form class="action-form" method="post"
                          action="${pageContext.request.contextPath}/customer/board/processReport">
                      <input type="hidden" name="rIdx"   value="${r.rIdx}"/>
                      <input type="hidden" name="action" value="dismiss"/>
                      <input type="hidden" name="page"   value="${page}"/>
                      <button type="submit" class="btn-dism">기각</button>
                    </form>
                  </c:if>
                  <c:if test="${r.status != 'PENDING'}">
                    <span style="font-size:11px;color:var(--text-faint)">처리 완료</span>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <%-- 페이지네이션 --%>
  <c:if test="${totalPage > 1}">
    <div class="pager">
      <c:if test="${page > 1}">
        <a href="${pageContext.request.contextPath}/customer/board?tab=reports&page=${page-1}&status=${status}&targetType=${targetType}">‹</a>
      </c:if>
      <c:forEach begin="1" end="${totalPage}" var="p">
        <c:choose>
          <c:when test="${p == page}"><span class="cur">${p}</span></c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/customer/board?tab=reports&page=${p}&status=${status}&targetType=${targetType}">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
      <c:if test="${page < totalPage}">
        <a href="${pageContext.request.contextPath}/customer/board?tab=reports&page=${page+1}&status=${status}&targetType=${targetType}">›</a>
      </c:if>
    </div>
  </c:if>
</c:if>

<%-- ══════════════════════════════════════════════
     탭 3: 신고 유저
     ══════════════════════════════════════════════ --%>
<c:if test="${tab == 'users'}">

  <div class="glass-card">
    <div class="card-header" style="margin-bottom:16px">
      <h3>신고된 유저 목록</h3>
      <span style="font-size:11px;color:var(--text-faint)">누적 신고 횟수 기준 내림차순</span>
    </div>
    <table class="crm-table">
      <thead>
        <tr>
          <th style="width:50px;text-align:center">순위</th>
          <th>유저명</th>
          <th style="text-align:center;width:90px">총 신고 수</th>
          <th style="text-align:center;width:90px">미처리</th>
          <th style="text-align:center;width:90px">처리완료</th>
          <th style="width:140px">최초 신고일</th>
          <th style="width:140px">최근 신고일</th>
          <th style="min-width:160px">신고 비율</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty reportedUsers}">
            <tr><td colspan="8" class="empty-msg">신고된 유저가 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <%-- 최대 신고 수 계산 --%>
            <c:set var="maxReportCount" value="1"/>
            <c:forEach var="u" items="${reportedUsers}">
              <c:if test="${u.report_count > maxReportCount}">
                <c:set var="maxReportCount" value="${u.report_count}"/>
              </c:if>
            </c:forEach>
            <c:forEach var="u" items="${reportedUsers}" varStatus="st">
              <c:set var="barPct" value="${maxReportCount > 0 ? u.report_count * 100 / maxReportCount : 0}"/>
              <c:set var="danger" value="${u.report_count >= 5}"/>
              <tr>
                <td style="text-align:center;font-weight:700;
                  color:${st.index == 0 ? '#cc88ee' : st.index == 1 ? 'var(--brown-hi)' : 'var(--text-dim)'}">
                  #${st.index + 1}
                </td>
                <td>
                  <span style="font-weight:600;color:${danger ? 'rgba(255,100,80,0.9)' : 'var(--text)'}">
                    ${u.author}
                  </span>
                  <c:if test="${danger}">
                    <span style="font-size:10px;margin-left:4px;
                      background:rgba(220,60,50,0.18);color:rgba(255,80,60,0.9);
                      padding:1px 6px;border-radius:8px;border:1px solid rgba(220,60,50,0.3)">위험</span>
                  </c:if>
                </td>
                <td style="text-align:center;font-weight:700;
                  color:${danger ? 'rgba(255,100,80,0.9)' : 'var(--text)'}">
                  ${u.report_count}건
                </td>
                <td style="text-align:center;color:rgba(240,200,60,0.9);font-weight:600">
                  <c:if test="${u.pending_count > 0}">${u.pending_count}건</c:if>
                  <c:if test="${u.pending_count == 0}"><span style="color:var(--text-faint)">—</span></c:if>
                </td>
                <td style="text-align:center;color:rgba(80,210,120,0.8)">
                  <c:if test="${u.processed_count > 0}">${u.processed_count}건</c:if>
                  <c:if test="${u.processed_count == 0}"><span style="color:var(--text-faint)">—</span></c:if>
                </td>
                <td class="td-faint" style="font-size:11px">${u.first_report}</td>
                <td class="td-faint" style="font-size:11px">${u.last_report}</td>
                <td>
                  <div style="display:flex;align-items:center;gap:8px">
                    <div style="flex:1;height:6px;background:rgba(255,255,255,0.07);border-radius:3px;overflow:hidden">
                      <div style="height:100%;border-radius:3px;
                        width:<fmt:formatNumber value="${barPct}" maxFractionDigits="0"/>%;
                        background:${danger ? 'rgba(220,60,50,0.7)' : 'rgba(200,131,42,0.75)'}">
                      </div>
                    </div>
                    <span style="font-size:11px;color:var(--text-faint);width:32px">
                      <fmt:formatNumber value="${barPct}" maxFractionDigits="0"/>%
                    </span>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</c:if>

<script>
  // 토스트 자동 닫기
  var t = document.getElementById('toast');
  if (t) setTimeout(function() { t.style.opacity = '0'; t.style.transition = 'opacity 0.4s'; }, 2800);
</script>

<%@ include file="footer.jsp" %>
