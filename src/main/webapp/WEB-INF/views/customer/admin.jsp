<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<c:set var="pageTitle"  value="시스템 관리"/>
<c:set var="activeMenu" value="admin"/>
<%@ include file="header.jsp" %>

<c:if test="${param.roleUpdated == 'true'}">
  <div class="alert-success-banner">✓ 권한이 변경되었습니다.</div>
</c:if>
<c:if test="${param.memberDeleted == 'true'}">
  <div class="alert-success-banner">✓ 계정이 삭제되었습니다.</div>
</c:if>
<c:if test="${param.selfEdit == 'true' or param.selfDelete == 'true'}">
  <div style="background:rgba(200,60,60,.12);border:1px solid rgba(200,60,60,.3);
              color:#e08080;border-radius:var(--radius);padding:12px 16px;margin-bottom:20px;font-size:13px">
    ⚠ 자기 자신의 계정은 변경·삭제할 수 없습니다.
  </div>
</c:if>
<c:if test="${param.accessDenied == 'true'}">
  <div style="background:rgba(200,60,60,.12);border:1px solid rgba(200,60,60,.3);
              color:#e08080;border-radius:var(--radius);padding:12px 16px;margin-bottom:20px;font-size:13px">
    ⚠ 접근 권한이 없습니다.
  </div>
</c:if>

<%-- ══════════════════════════════════════════════════════
     직원 계정 권한 관리
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" style="margin-bottom:20px">
  <div class="card-header">
    <h3>직원 계정 권한 관리</h3>
    <span style="font-size:12px;color:var(--text-faint)">ADMIN: 전체 / MANAGER: 통계·마케팅 / STAFF: 방문기록·조회 / MEMBER: 고객계정(CRM 접근불가)</span>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th>번호</th>
        <th>이메일</th>
        <th>이름</th>
        <th style="text-align:center">현재 권한</th>
        <th>가입일</th>
        <th style="width:200px">권한 변경</th>
        <th style="width:70px;text-align:center">삭제</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty members}">
          <tr><td colspan="7" class="empty-msg">등록된 직원 계정이 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="m" items="${members}" varStatus="vs">
            <tr>
              <td class="td-faint">${vs.count}</td>
              <td>${m.email}</td>
              <td>${m.name}</td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${m.role == 'ADMIN'}">
                    <span style="font-size:12px;font-weight:700;color:#cc88ee">ADMIN</span>
                  </c:when>
                  <c:when test="${m.role == 'MANAGER'}">
                    <span style="font-size:12px;font-weight:700;color:var(--brown-hi)">MANAGER</span>
                  </c:when>
                  <c:when test="${m.role == 'STAFF'}">
                    <span style="font-size:12px;color:var(--text-dim)">STAFF</span>
                  </c:when>
                  <c:otherwise>
                    <span style="font-size:12px;color:var(--text-faint)">MEMBER</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="td-faint">${m.regDate}</td>
              <td>
                <form action="${pageContext.request.contextPath}/customer/admin/updateRole"
                      method="post" style="display:flex;gap:6px;align-items:center">
                  <input type="hidden" name="m_idx" value="${m.m_idx}">
                  <select name="role"
                          style="background:var(--bg);border:1px solid var(--border);
                                 border-radius:var(--radius-sm);color:var(--text);
                                 padding:5px 8px;font-size:12px">
                    <option value="ADMIN"   ${m.role == 'ADMIN'   ? 'selected' : ''}>ADMIN</option>
                    <option value="MANAGER" ${m.role == 'MANAGER' ? 'selected' : ''}>MANAGER</option>
                    <option value="STAFF"   ${m.role == 'STAFF'   ? 'selected' : ''}>STAFF</option>
                    <option value="MEMBER"  ${m.role == 'MEMBER'  ? 'selected' : ''}>MEMBER</option>
                  </select>
                  <button type="submit" class="btn-ghost" style="font-size:11px;padding:4px 10px">변경</button>
                </form>
              </td>
              <td style="text-align:center">
                <form action="${pageContext.request.contextPath}/customer/admin/deleteMember"
                      method="post" style="display:inline"
                      onsubmit="return confirm('${m.name} 계정을 삭제하시겠습니까?')">
                  <input type="hidden" name="m_idx" value="${m.m_idx}">
                  <button type="submit" class="btn-delete" style="font-size:11px;padding:3px 8px">삭제</button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%-- ══════════════════════════════════════════════════════
     스케줄러 실행 이력
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card">
  <div class="card-header">
    <h3>스케줄러 실행 이력</h3>
    <span style="font-size:12px;color:var(--text-faint)">최근 50건 — 매월 1일 자정 자동 실행</span>
  </div>
  <c:choose>
    <c:when test="${empty schedulerLogs}">
      <div class="empty-msg">스케줄러 실행 기록이 없습니다. 매월 1일 00:00에 자동 실행됩니다.</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th>작업명</th>
            <th style="text-align:center">결과</th>
            <th style="text-align:right">처리 건수</th>
            <th>메시지</th>
            <th>실행 일시</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="sl" items="${schedulerLogs}">
            <tr>
              <td style="font-weight:600">${sl.job_name}</td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${sl.status == 'SUCCESS'}">
                    <span style="font-size:12px;color:#88cc88">✓ 성공</span>
                  </c:when>
                  <c:otherwise>
                    <span style="font-size:12px;color:#e08080">✗ 실패</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:right;color:var(--text-dim)">${sl.affected}건</td>
              <td class="td-faint" style="max-width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                ${sl.message}
              </td>
              <td class="td-faint">${sl.reg_date}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%@ include file="footer.jsp" %>
