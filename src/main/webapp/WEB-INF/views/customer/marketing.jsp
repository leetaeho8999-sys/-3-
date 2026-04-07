<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle"  value="마케팅"/>
<c:set var="activeMenu" value="marketing"/>
<%@ include file="header.jsp" %>

<c:if test="${param.issued == 'true'}">
  <div class="alert-success-banner">✓ 쿠폰이 발급되었습니다.</div>
</c:if>
<c:if test="${param.revoked == 'true'}">
  <div class="alert-success-banner">✓ 쿠폰이 회수되었습니다.</div>
</c:if>

<%-- ══════════════════════════════════════════════════════
     이탈 의심 고객 (28일 이상 미방문)
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" style="margin-bottom:20px">
  <div class="card-header">
    <h3>이탈 의심 고객 <span style="font-size:13px;color:var(--text-faint);font-weight:400">(28일 이상 미방문)</span></h3>
    <span style="font-size:12px;color:var(--text-faint)">${fn:length(inactiveCustomers)}명</span>
  </div>
  <c:choose>
    <c:when test="${empty inactiveCustomers}">
      <div class="empty-msg">이탈 의심 고객이 없습니다. 모든 고객이 활발히 방문 중입니다!</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th>이름</th>
            <th>연락처</th>
            <th>등급</th>
            <th style="text-align:right">누적 방문</th>
            <th>마지막 방문</th>
            <th>보유 쿠폰</th>
            <th style="width:130px">쿠폰 발급</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="ic" items="${inactiveCustomers}">
            <tr>
              <td class="td-name">
                <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${ic.c_idx}">${ic.name}</a>
              </td>
              <td class="td-muted">${ic.phone}</td>
              <td><span class="grade-badge grade-${ic.grade}">${ic.grade}</span></td>
              <td style="text-align:right">${ic.visitCount}회</td>
              <td class="td-faint">
                ${empty ic.lastVisitDate ? '기록 없음' : ic.lastVisitDate}
              </td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${ic.couponCount > 0}">
                    <span style="color:var(--brown-hi);font-weight:600">${ic.couponCount}장</span>
                  </c:when>
                  <c:otherwise><span class="td-faint">없음</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <button class="btn-ghost" style="font-size:11px;padding:4px 10px"
                        onclick="openIssueModal('${ic.c_idx}', '${ic.name}')">쿠폰 발급</button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%-- ══════════════════════════════════════════════════════
     이번 달 생일 고객
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" style="margin-bottom:20px">
  <div class="card-header">
    <h3>이번 달 생일 고객 🎂</h3>
    <span style="font-size:12px;color:var(--text-faint)">${fn:length(birthdayCustomers)}명</span>
  </div>
  <c:choose>
    <c:when test="${empty birthdayCustomers}">
      <div class="empty-msg">이번 달 생일인 고객이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th>이름</th>
            <th>연락처</th>
            <th>등급</th>
            <th>생일</th>
            <th>보유 쿠폰</th>
            <th style="width:130px">쿠폰 발급</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="bc" items="${birthdayCustomers}">
            <tr>
              <td class="td-name">
                <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${bc.c_idx}">${bc.name}</a>
              </td>
              <td class="td-muted">${bc.phone}</td>
              <td><span class="grade-badge grade-${bc.grade}">${bc.grade}</span></td>
              <td class="td-faint">${bc.birthday}</td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${bc.couponCount > 0}">
                    <span style="color:var(--brown-hi);font-weight:600">${bc.couponCount}장</span>
                  </c:when>
                  <c:otherwise><span class="td-faint">없음</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <button class="btn-ghost" style="font-size:11px;padding:4px 10px"
                        onclick="openIssueModal('${bc.c_idx}', '${bc.name}')">쿠폰 발급</button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%-- ══════════════════════════════════════════════════════
     최근 발급 쿠폰 내역
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" style="margin-bottom:20px">
  <div class="card-header">
    <h3>최근 쿠폰 발급 내역</h3>
    <span style="font-size:12px;color:var(--text-faint)">최근 30건</span>
  </div>
  <c:choose>
    <c:when test="${empty recentIssued}">
      <div class="empty-msg">발급된 쿠폰이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th>고객명</th>
            <th>등급</th>
            <th>쿠폰명</th>
            <th>종류</th>
            <th>발급일</th>
            <th>만료일</th>
            <th style="text-align:center">상태</th>
            <th style="width:80px">회수</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="ri" items="${recentIssued}">
            <tr>
              <td>${ri.customer_name}</td>
              <td><span class="grade-badge grade-${ri.grade}">${ri.grade}</span></td>
              <td>${ri.coupon_name}</td>
              <td class="td-faint" style="font-size:11px">
                <c:choose>
                  <c:when test="${ri.coupon_type == 'FREE'}">무료음료</c:when>
                  <c:when test="${ri.coupon_type == 'DISCOUNT'}">할인</c:when>
                  <c:otherwise>업그레이드</c:otherwise>
                </c:choose>
              </td>
              <td class="td-faint">${ri.issued_date}</td>
              <td class="td-faint">${ri.expire_date}</td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${ri.used == 1}">
                    <span style="font-size:11px;color:var(--text-faint)">사용완료</span>
                  </c:when>
                  <c:otherwise>
                    <span style="font-size:11px;color:var(--brown-hi)">미사용</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${ri.used == 0}">
                  <form action="${pageContext.request.contextPath}/customer/marketing/revokeCoupon"
                        method="post" style="display:inline"
                        onsubmit="return confirm('쿠폰을 회수하시겠습니까?')">
                    <input type="hidden" name="cc_idx" value="${ri.cc_idx}">
                    <button type="submit" class="btn-ghost"
                            style="font-size:11px;padding:3px 8px;color:#e06060">회수</button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%-- ══════════════════════════════════════════════════════
     쿠폰 발급 모달
     ══════════════════════════════════════════════════════ --%>
<div id="issueModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;
     background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center">
  <div style="background:var(--bg-card);border:1px solid var(--border-hi);border-radius:var(--radius);
              padding:28px 32px;min-width:380px;max-width:480px">
    <h3 style="margin:0 0 4px;font-size:16px">쿠폰 발급</h3>
    <div id="modalCustomerName" style="font-size:13px;color:var(--text-faint);margin-bottom:20px"></div>
    <form action="${pageContext.request.contextPath}/customer/marketing/issueCoupon" method="post">
      <input type="hidden" id="modal_c_idx" name="c_idx">
      <div class="form-group" style="margin-bottom:14px">
        <label style="font-size:12px;color:var(--text-dim);display:block;margin-bottom:6px">쿠폰 선택</label>
        <select name="couponIdx"
                style="width:100%;background:var(--bg);border:1px solid var(--border);
                       border-radius:var(--radius-sm);color:var(--text);padding:8px 12px;font-size:13px">
          <c:forEach var="cp" items="${activeCoupons}">
            <option value="${cp.couponIdx}" data-days="${cp.expireDays}">
              ${cp.name}
              <c:if test="${cp.type == 'DISCOUNT'}"> (${cp.value}${cp.value > 100 ? '원' : '%'} 할인)</c:if>
              (유효기간 ${cp.expireDays}일)
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group" style="margin-bottom:20px">
        <label style="font-size:12px;color:var(--text-dim);display:block;margin-bottom:6px">유효 기간 (일)</label>
        <input type="number" id="modal_expireDays" name="expireDays" min="1" max="365" value="30"
               style="width:100%;background:var(--bg);border:1px solid var(--border);
                      border-radius:var(--radius-sm);color:var(--text);padding:8px 12px;font-size:13px">
      </div>
      <div style="display:flex;gap:10px;justify-content:flex-end">
        <button type="button" class="btn-ghost" onclick="closeIssueModal()">취소</button>
        <button type="submit" class="btn-primary">발급</button>
      </div>
    </form>
  </div>
</div>

<script>
  function openIssueModal(c_idx, name) {
    document.getElementById('modal_c_idx').value = c_idx;
    document.getElementById('modalCustomerName').textContent = name + ' 님에게 쿠폰을 발급합니다.';
    const modal = document.getElementById('issueModal');
    modal.style.display = 'flex';
  }
  function closeIssueModal() {
    document.getElementById('issueModal').style.display = 'none';
  }
  // 쿠폰 선택 시 만료일 자동 업데이트
  document.querySelector('select[name="couponIdx"]')?.addEventListener('change', function() {
    const days = this.options[this.selectedIndex].dataset.days;
    if (days) document.getElementById('modal_expireDays').value = days;
  });
</script>

<%@ include file="footer.jsp" %>
